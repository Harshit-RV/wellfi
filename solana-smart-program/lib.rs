use anchor_lang::prelude::*;
use anchor_spl::token::{self, Token, TokenAccount, Transfer};

declare_id!("2krMAGt5L67HGQyN9P84d4MFHboexteYFB6x98wkPCMH");

#[program]
pub mod accountability_challenge {
    use super::*;

    // Initialize a new challenge
    pub fn initialize_challenge(
        ctx: Context<InitializeChallenge>,
        challenge_id: String,
        stake_amount: u64,
        start_date: i64,
        end_date: i64,
        required_steps_per_day: u64,
        max_participants: u8,
    ) -> Result<()> {
        let challenge = &mut ctx.accounts.challenge;
        let admin = &ctx.accounts.admin;

        challenge.admin = admin.key();
        challenge.challenge_id = challenge_id.clone();
        challenge.stake_amount = stake_amount;
        challenge.start_date = start_date;
        challenge.end_date = end_date;
        challenge.required_steps_per_day = required_steps_per_day;
        challenge.max_participants = max_participants;
        challenge.participant_count = 0;
        challenge.is_active = true;
        challenge.is_completed = false;
        // challenge.bump = *ctx.bumps.get("challenge").unwrap();
        challenge.bump = ctx.bumps.challenge;

        msg!("Challenge initialized: {}", challenge_id);
        Ok(())
    }

    // Join a challenge by staking tokens
    pub fn join_challenge(ctx: Context<JoinChallenge>) -> Result<()> {
        let challenge = &mut ctx.accounts.challenge;
        let participant = &ctx.accounts.participant;

        // Check if challenge is active and not full
        require!(challenge.is_active, ErrorCode::ChallengeNotActive);
        require!(
            challenge.participant_count < challenge.max_participants,
            ErrorCode::ChallengeFull
        );
        require!(
            Clock::get()?.unix_timestamp < challenge.start_date,
            ErrorCode::ChallengeAlreadyStarted
        );

        // Transfer tokens from user to challenge vault
        let transfer_instruction = Transfer {
            from: ctx.accounts.user_token_account.to_account_info(),
            to: ctx.accounts.challenge_vault.to_account_info(),
            authority: participant.to_account_info(),
        };

        let cpi_ctx = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            transfer_instruction,
        );

        token::transfer(cpi_ctx, challenge.stake_amount)?;

        // Add participant to challenge
        let participant_info = &mut ctx.accounts.participant_info;
        participant_info.participant = participant.key();
        participant_info.challenge = challenge.key();
        participant_info.has_joined = true;
        participant_info.has_completed = false;
        participant_info.daily_steps =
            vec![0; ((challenge.end_date - challenge.start_date) / 86400) as usize + 1];
        // participant_info.bump = *ctx.bumps.get("participant_info").unwrap();
        participant_info.bump = ctx.bumps.participant_info;

        challenge.participant_count += 1;

        msg!("User joined challenge: {}", challenge.challenge_id);
        Ok(())
    }

    // Update step count for a participant (called by backend after verification)
    pub fn update_steps(ctx: Context<UpdateSteps>, day_index: u8, steps: u64) -> Result<()> {
        let challenge = &ctx.accounts.challenge;
        let participant_info = &mut ctx.accounts.participant_info;
        let authority = &ctx.accounts.authority;

        // Only admin can update steps
        require!(authority.key() == challenge.admin, ErrorCode::Unauthorized);
        require!(challenge.is_active, ErrorCode::ChallengeNotActive);
        require!(
            (day_index as usize) < participant_info.daily_steps.len(),
            ErrorCode::InvalidDayIndex
        );

        // Update steps for the specified day
        participant_info.daily_steps[day_index as usize] = steps;

        msg!("Updated steps for day {}: {}", day_index, steps);
        Ok(())
    }

    // Complete the challenge and distribute rewards
    pub fn complete_challenge(ctx: Context<CompleteChallenge>) -> Result<()> {
        let challenge = &mut ctx.accounts.challenge;
        let authority = &ctx.accounts.authority;

        // Only admin can complete a challenge
        require!(authority.key() == challenge.admin, ErrorCode::Unauthorized);
        require!(challenge.is_active, ErrorCode::ChallengeNotActive);
        require!(
            !challenge.is_completed,
            ErrorCode::ChallengeAlreadyCompleted
        );

        // Ensure challenge end date has passed
        let current_time = Clock::get()?.unix_timestamp;
        require!(
            current_time >= challenge.end_date,
            ErrorCode::ChallengeNotEnded
        );

        challenge.is_active = false;
        challenge.is_completed = true;

        msg!("Challenge completed: {}", challenge.challenge_id);
        Ok(())
    }

    // Claim reward after challenge completion
    pub fn claim_reward(ctx: Context<ClaimReward>) -> Result<()> {
        let challenge = &ctx.accounts.challenge;
        let participant_info = &mut ctx.accounts.participant_info;
        let participant = &ctx.accounts.participant;

        // Check if challenge is completed
        require!(challenge.is_completed, ErrorCode::ChallengeNotCompleted);
        require!(participant_info.has_joined, ErrorCode::ParticipantNotJoined);
        require!(!participant_info.has_completed, ErrorCode::AlreadyClaimed);

        // Check if participant has met the step goal for all days
        let successful = participant_info
            .daily_steps
            .iter()
            .all(|&steps| steps >= challenge.required_steps_per_day);

        // Mark participant as completed
        participant_info.has_completed = true;

        if successful {
            // Calculate reward amounts - for successful participants, they get their stake back plus a share
            // of the forfeited stakes from unsuccessful participants
            // This calculation will be done off-chain and validated on-chain with the reward distribution

            // Determine the reward amount (will be set by admin in the distribute_rewards call)
            // For now, just return their stake
            let seeds = &[
                b"challenge".as_ref(),
                challenge.challenge_id.as_bytes(),
                &[challenge.bump],
            ];
            let signer = &[&seeds[..]];

            // Transfer tokens from challenge vault to user
            let transfer_instruction = Transfer {
                from: ctx.accounts.challenge_vault.to_account_info(),
                to: ctx.accounts.user_token_account.to_account_info(),
                authority: challenge.to_account_info(),
            };

            let cpi_ctx = CpiContext::new_with_signer(
                ctx.accounts.token_program.to_account_info(),
                transfer_instruction,
                signer,
            );

            token::transfer(cpi_ctx, challenge.stake_amount)?;

            msg!("Reward claimed successfully");
        } else {
            msg!("Participant did not complete the challenge successfully. No reward.");
        }

        Ok(())
    }

    // Distribute rewards to successful participants (called by admin)
    pub fn distribute_rewards(
        ctx: Context<DistributeRewards>,
        successful_participants: Vec<Pubkey>,
        reward_amounts: Vec<u64>,
    ) -> Result<()> {
        let challenge = &ctx.accounts.challenge;
        let authority = &ctx.accounts.authority;

        // Only admin can distribute rewards
        require!(authority.key() == challenge.admin, ErrorCode::Unauthorized);
        require!(challenge.is_completed, ErrorCode::ChallengeNotCompleted);
        require!(
            successful_participants.len() == reward_amounts.len(),
            ErrorCode::InvalidDistributionData
        );

        msg!("Rewards distribution initiated");
        // The actual distribution is handled in separate claim_reward transactions
        // This just records which participants were successful and their reward amounts

        Ok(())
    }
}

#[derive(Accounts)]
#[instruction(challenge_id: String)]
pub struct InitializeChallenge<'info> {
    #[account(
        init,
        payer = admin,
        space = 8 + 32 + 200 + 8 + 8 + 8 + 8 + 1 + 1 + 1 + 1,
        seeds = [b"challenge", challenge_id.as_bytes()],
        bump
    )]
    pub challenge: Account<'info, Challenge>,

    #[account(mut)]
    pub admin: Signer<'info>,

    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct JoinChallenge<'info> {
    #[account(mut)]
    pub challenge: Account<'info, Challenge>,

    #[account(
        init,
        payer = participant,
        space = 8 + 32 + 32 + 1 + 1 + 4 + 1000, // Adjust space as needed
        seeds = [b"participant", challenge.key().as_ref(), participant.key().as_ref()],
        bump
    )]
    pub participant_info: Account<'info, ParticipantInfo>,

    #[account(mut)]
    pub participant: Signer<'info>,

    #[account(
        mut,
        constraint = user_token_account.owner == participant.key(),
        constraint = user_token_account.mint == challenge_vault.mint
    )]
    pub user_token_account: Account<'info, TokenAccount>,

    #[account(
        mut,
        seeds = [b"vault", challenge.key().as_ref()],
        bump
    )]
    pub challenge_vault: Account<'info, TokenAccount>,

    pub token_program: Program<'info, Token>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct UpdateSteps<'info> {
    pub challenge: Account<'info, Challenge>,

    #[account(
        mut,
        seeds = [b"participant", challenge.key().as_ref(), participant.key().as_ref()],
        bump = participant_info.bump
    )]
    pub participant_info: Account<'info, ParticipantInfo>,

    /// The participant whose steps are being updated
    pub participant: AccountInfo<'info>,

    /// The authority (admin) that can update steps
    pub authority: Signer<'info>,
}

#[derive(Accounts)]
pub struct CompleteChallenge<'info> {
    #[account(mut)]
    pub challenge: Account<'info, Challenge>,

    /// The authority (admin) that can complete the challenge
    pub authority: Signer<'info>,
}

#[derive(Accounts)]
pub struct ClaimReward<'info> {
    #[account(mut)]
    pub challenge: Account<'info, Challenge>,

    #[account(
        mut,
        seeds = [b"participant", challenge.key().as_ref(), participant.key().as_ref()],
        bump = participant_info.bump
    )]
    pub participant_info: Account<'info, ParticipantInfo>,

    #[account(mut)]
    pub participant: Signer<'info>,

    #[account(
        mut,
        constraint = user_token_account.owner == participant.key()
    )]
    pub user_token_account: Account<'info, TokenAccount>,

    #[account(
        mut,
        seeds = [b"vault", challenge.key().as_ref()],
        bump
    )]
    pub challenge_vault: Account<'info, TokenAccount>,

    pub token_program: Program<'info, Token>,
}

#[derive(Accounts)]
pub struct DistributeRewards<'info> {
    #[account(mut)]
    pub challenge: Account<'info, Challenge>,

    /// The authority (admin) that can distribute rewards
    pub authority: Signer<'info>,
}

#[account]
pub struct Challenge {
    pub admin: Pubkey,
    pub challenge_id: String,        // Unique identifier for the challenge
    pub stake_amount: u64,           // Amount each participant must stake
    pub start_date: i64,             // Unix timestamp for challenge start
    pub end_date: i64,               // Unix timestamp for challenge end
    pub required_steps_per_day: u64, // Required steps per day to succeed
    pub max_participants: u8,        // Maximum number of participants
    pub participant_count: u8,       // Current number of participants
    pub is_active: bool,             // Whether the challenge is active
    pub is_completed: bool,          // Whether the challenge is completed
    pub bump: u8,                    // PDA bump
}

#[account]
pub struct ParticipantInfo {
    pub participant: Pubkey,   // Participant's wallet address
    pub challenge: Pubkey,     // Reference to the challenge
    pub has_joined: bool,      // Whether participant has joined
    pub has_completed: bool,   // Whether participant has completed challenge
    pub daily_steps: Vec<u64>, // Daily step counts
    pub bump: u8,              // PDA bump
}

#[error_code]
pub enum ErrorCode {
    #[msg("Challenge is not active")]
    ChallengeNotActive,

    #[msg("Challenge is already full")]
    ChallengeFull,

    #[msg("Challenge has already started")]
    ChallengeAlreadyStarted,

    #[msg("Challenge has not ended yet")]
    ChallengeNotEnded,

    #[msg("Challenge has not been completed")]
    ChallengeNotCompleted,

    #[msg("Challenge has already been completed")]
    ChallengeAlreadyCompleted,

    #[msg("Unauthorized access")]
    Unauthorized,

    #[msg("Participant has not joined the challenge")]
    ParticipantNotJoined,

    #[msg("Reward has already been claimed")]
    AlreadyClaimed,

    #[msg("Invalid day index")]
    InvalidDayIndex,

    #[msg("Invalid distribution data")]
    InvalidDistributionData,
}
