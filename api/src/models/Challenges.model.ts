import mongoose, { Document, Schema, Types } from 'mongoose';

export interface ChallengeTarget {
  steps: {
    number: number;
    deadline: Date;
    type: 'per day' | 'total' | 'per week';
  };
}

export interface ChallengeDoc extends Document {
  title: string;
  desc: string;
  creator: Types.ObjectId;
  type: 'public' | 'private';
  start_date: Date;
  users: Types.ObjectId[];
  required_stake: number;
  target: ChallengeTarget;
  escrow_account: string;
  status: 'active' | 'completed';
}

const ChallengeSchema: Schema = new Schema(
  {
    title: { type: String, required: true },
    desc: { type: String, required: true },
    creator: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    type: { type: String, enum: ['public', 'private'], required: true },
    start_date: { type: Date, required: true },
    users: [{ type: Schema.Types.ObjectId, ref: 'User' }],
    required_stake: { type: Number, required: true },
    target: {
      steps: {
        number: { type: Number, required: true },
        deadline: { type: Date, required: true },
        type: { type: String, enum: ['per day', 'total', 'per week'], required: true },
      },
    },
    escrow_account: { type: String, required: true },
    status: { type: String, enum: ['active', 'completed'], required: true },
  },
  { timestamps: true }
);

ChallengeSchema.index({ creator: 1, start_date: 1 });

const Challenge = mongoose.model<ChallengeDoc>('Challenge', ChallengeSchema);
export default Challenge;
