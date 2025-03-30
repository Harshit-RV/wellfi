import User, { UserDoc, DailyActivity } from "../models/User.model";

/**
 * Create a new user
 * @param args - User properties
 * @returns The created user document
 */
export const createUser = async (args: Omit<UserDoc, "createdAt" | "updatedAt">): Promise<UserDoc> => {
  const newUser = new User(args);
  return newUser.save();
};

/**
 * Update a user by ID
 * @param id - User ID
 * @param updatedData - Updated user properties
 * @returns The updated user document or null if not found
 */
export const updateUserById = async (
  id: string,
  updatedData: Partial<UserDoc>
): Promise<UserDoc | null> => {
  return User.findByIdAndUpdate(id, updatedData, { new: true });
};

/**
 * Get all users
 * @returns An array of all user documents
 */
export const getAllUsers = async (): Promise<UserDoc[]> => {
  return User.find({});
};

/**
 * Get a user by ID
 * @param id - User ID
 * @returns The user document or null if not found
 */
export const getUserById = async (id: string): Promise<UserDoc | null> => {
  return User.findById(id);
};

/**
 * Get a user by _id
 * @param _id - The _id
 * @returns The user document or null if not found
 */
export const getUserBy_id = async (_id: string): Promise<UserDoc | null> => {
  return User.findOne({ _id });
};

/**
 * Get a user by email
 * @param email - User email
 * @returns The user document or null if not found
 */
export const getUserByEmail = async (email: string): Promise<UserDoc | null> => {
  return User.findOne({ email });
};

/**
 * Get a user by wallet address
 * @param walletAddress - User wallet address
 * @returns The user document or null if not found
 */
export const getUserByWalletAddress = async (walletAddress: string): Promise<UserDoc | null> => {
  return User.findOne({ walletAddress });
};

/**
 * Delete a user by ID
 * @param id - User ID
 * @returns The deleted user document or null if not found
 */
export const deleteUser = async (id: string): Promise<UserDoc | null> => {
  return User.findByIdAndDelete(id);
};

/**
 * Add activity data for a user
 * @param _id - User ID
 * @param activityData - Daily activity data to add
 * @returns The updated user document or null if not found
 */
export const addActivityData = async (
  _id: string,
  activityData: DailyActivity
): Promise<UserDoc | null> => {
  // First check if an entry already exists for this date
  const user = await User.findById(_id);
  if (!user) return null;

  const existingEntryIndex = user.activityData.findIndex(
    entry => entry.date.toDateString() === activityData.date.toDateString()
  );

  if (existingEntryIndex >= 0) {
    // Update existing entry
    return User.findByIdAndUpdate(
      _id,
      { $set: { [`activityData.${existingEntryIndex}`]: activityData } },
      { new: true }
    );
  } else {
    // Add new entry
    return User.findByIdAndUpdate(
      _id,
      { $push: { activityData: activityData } },
      { new: true }
    );
  }
};

/**
 * Update activity data for a specific date
 * @param _id - User ID
 * @param date - Date to update
 * @param updates - Activity data updates
 * @returns The updated user document or null if not found
 */
export const updateActivityData = async (
  _id: string,
  date: Date,
  updates: Partial<DailyActivity>
): Promise<UserDoc | null> => {
  const user = await User.findById(_id);
  if (!user) return null;

  const existingEntryIndex = user.activityData.findIndex(
    entry => entry.date.toDateString() === date.toDateString()
  );

  if (existingEntryIndex >= 0) {
    const updateData: any = {};
    
    if (updates.steps !== undefined) {
      updateData[`activityData.${existingEntryIndex}.steps`] = updates.steps;
    }
    
    if (updates.distance !== undefined) {
      updateData[`activityData.${existingEntryIndex}.distance`] = updates.distance;
    }

    return User.findByIdAndUpdate(
      _id,
      { $set: updateData },
      { new: true }
    );
  }
  
  return null;
};

/**
 * Get activity data for a specific date range
 * @param _id - User ID
 * @param startDate - Start date (inclusive)
 * @param endDate - End date (inclusive)
 * @returns The user with filtered activity data or null if not found
 */
export const getActivityDataByDateRange = async (
  _id: string,
  startDate: Date,
  endDate: Date
): Promise<UserDoc | null> => {
  const user = await User.findById(_id);
  if (!user) return null;

  // Clone the user object to avoid modifying the database document
  const userClone = user.toObject();
  
  // Filter activity data to only include entries within the date range
  userClone.activityData = userClone.activityData.filter(
    (entry: DailyActivity) => {
      const entryDate = new Date(entry.date);
      return entryDate >= startDate && entryDate <= endDate;
    }
  );

  return userClone as UserDoc;
};

/**
 * Update wallet address for a user
 * @param _id - User ID
 * @param walletAddress - New wallet address
 * @returns The updated user document or null if not found
 */
export const updateWalletAddress = async (
  _id: string,
  walletAddress: string
): Promise<UserDoc | null> => {
  return User.findByIdAndUpdate(
    _id,
    { walletAddress },
    { new: true }
  );
};

/**
 * Get total steps and distance for a specific date range
 * @param _id - User ID
 * @param startDate - Start date (inclusive)
 * @param endDate - End date (inclusive)
 * @returns An object with totals or null if user not found
 */
export const getActivityTotals = async (
  _id: string,
  startDate: Date,
  endDate: Date
): Promise<{ totalSteps: number, totalDistance: number } | null> => {
  const user = await User.findById(_id);
  if (!user) return null;
  
  const filteredActivity = user.activityData.filter(entry => {
    const entryDate = new Date(entry.date);
    return entryDate >= startDate && entryDate <= endDate;
  });
  
  const totalSteps = filteredActivity.reduce((sum, entry) => sum + entry.steps, 0);
  const totalDistance = filteredActivity.reduce((sum, entry) => sum + entry.distance, 0);
  
  return { totalSteps, totalDistance };
};