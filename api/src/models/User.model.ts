import mongoose, { Document, Schema, Types } from 'mongoose';

export interface DailyActivity {
  date: Date;
  steps: number;
  distance: number;
}

export interface UserDoc extends Document {
  name: string;
  email: string;
  _id: string;
  walletAddress: string | null;
  activityData: DailyActivity[];
  createdAt: Date;
  updatedAt: Date;
}

// Create the User schema
const UserSchema: Schema = new Schema(
  {
    _id: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    walletAddress: { type: String, default: null },
    activityData: [
      {
        date: { type: Date, required: true },
        steps: { type: Number, default: 0 },
        distance: { type: Number, default: 0 },
      }
    ]
  },
  { timestamps: true }
);

UserSchema.index({ email: 1 });
UserSchema.index({ walletAddress: 1 });
UserSchema.index({ 'activityData.date': 1 });

const User = mongoose.model<UserDoc>('User', UserSchema);

export default User;