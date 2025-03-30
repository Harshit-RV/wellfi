import Challenge, { ChallengeDoc } from "../models/Challenge.model";

/**
 * Create a new challenge
 * @param args - Challenge properties
 * @returns The created challenge document
 */
export const createChallenge = async (args: Omit<ChallengeDoc, "createdAt" | "updatedAt">): Promise<ChallengeDoc> => {
  const newChallenge = new Challenge(args);
  return newChallenge.save();
};

/**
 * Update a challenge by ID
 * @param id - Challenge ID
 * @param updatedData - Updated challenge properties
 * @returns The updated challenge document or null if not found
 */
export const updateChallengeById = async (
  id: string,
  updatedData: Partial<ChallengeDoc>
): Promise<ChallengeDoc | null> => {
  return Challenge.findByIdAndUpdate(id, updatedData, { new: true });
};

/**
 * Get all challenges
 * @returns An array of all challenge documents
 */
export const getAllChallenges = async (): Promise<ChallengeDoc[]> => {
  return Challenge.find({});
};

/**
 * Get a challenge by ID
 * @param id - Challenge ID
 * @returns The challenge document or null if not found
 */
export const getChallengeById = async (id: string): Promise<ChallengeDoc | null> => {
  return Challenge.findById(id);
};

/**
 * Get challenges by creator
 * @param creatorId - Creator user ID
 * @returns An array of challenges created by the user
 */
export const getChallengesByCreator = async (
  creatorId: string
): Promise<ChallengeDoc[]> => {
  return Challenge.find({ creator: creatorId });
};

/**
 * Get challenges by participant
 * @param participantId - Participant user ID
 * @returns An array of challenges the user is participating in
 */
export const getChallengesByParticipant = async (
  participantId: string
): Promise<ChallengeDoc[]> => {
  return Challenge.find({ participants: participantId });
};

/**
 * Delete a challenge by ID
 * @param id - Challenge ID
 * @returns The deleted challenge document or null if not found
 */
export const deleteChallenge = async (id: string): Promise<ChallengeDoc | null> => {
  return Challenge.findByIdAndDelete(id);
};

/**
 * Add a participant to a challenge
 * Ensures a participant is not added multiple times.
 * @param challengeId - Challenge ID
 * @param participantId - User ID of participant
 * @returns The updated challenge document or null if not found
 */
export const addParticipantToChallenge = async (
  challengeId: string,
  participantId: string
): Promise<ChallengeDoc | null> => {
  return Challenge.findByIdAndUpdate(
    challengeId,
    { $addToSet: { participants: participantId } },
    { new: true }
  );
};

/**
 * Remove a participant from a challenge
 * @param challengeId - Challenge ID
 * @param participantId - User ID of participant
 * @returns The updated challenge document or null if not found
 */
export const removeParticipantFromChallenge = async (
  challengeId: string,
  participantId: string
): Promise<ChallengeDoc | null> => {
  return Challenge.findByIdAndUpdate(
    challengeId,
    { $pull: { participants: participantId } },
    { new: true }
  );
};
