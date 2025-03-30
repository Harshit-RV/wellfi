import mongoose, { Document, Schema, Types } from 'mongoose';

export interface ChallengeTarget {
  steps: number
  distance: number
}

export interface ChallengeDoc extends Document {
  title: string;
  desc: string;
  creator: string;
  visibility: 'public' | 'private';
  start_date: Date;
  participants: string[];
  required_stake: number;
  type: 'per day' | 'total' | 'per week';
  targetType: 'steps' | 'distance';
  deadline: Date;
  target: ChallengeTarget;
  status: 'active' | 'completed' | 'upcoming';
  createdAt: Date;
  updatedAt: Date;
  // _id: Types.ObjectId;
}

const ChallengeSchema: Schema = new Schema(
  {
    title: { type: String, required: true },
    desc: { type: String, required: true },
    creator: { type: String, ref: 'User', required: true },
    visibility: { type: String, enum: ['public', 'private'], default: 'public' },
    start_date: { type: Date, required: true },
    participants: [{ type: String, ref: 'User' }],
    required_stake: { type: Number, required: true },
    type: { type: String, enum: ['per day', 'total', 'per week'], required: true },
    targetType: { type: String, enum: ['steps', 'distance'], required: true },
    deadline: { type: Date, required: true },
    target: {
      steps: { type: Number, required: true },
      distance: { type: Number, required: true },
    },
    status: { type: String, enum: ['active', 'completed', 'upcoming'], required: true },
  },
  { timestamps: true }
);

const Challenge = mongoose.model<ChallengeDoc>('Challenge', ChallengeSchema);

export default Challenge;
