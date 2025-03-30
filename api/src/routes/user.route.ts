import express from 'express';
import {
  createUser,
  updateUserById,
  getAllUsers,
  getUserById,
  getUserByEmail,
  getUserByWalletAddress,
  deleteUser,
  addActivityData,
  updateActivityData,
  getActivityDataByDateRange,
} from '../services/user.service';
import { verifyToken } from '../middleware/auth';

const router = express.Router();

// router.use(verifyToken);

// Create a new user
router.post("/create", async (req, res): Promise<any> => {
  try {
    const newUser = await createUser(req.body);
    return res.status(201).json(newUser);
  } catch (err) {
    console.error('Error creating user:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Update a user by ID
router.put('/update/:id', async (req, res): Promise<any> => {
  try {
    const updatedUser = await updateUserById(req.params.id, req.body);
    if (!updatedUser) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(updatedUser);
  } catch (err) {
    console.error('Error updating user:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get all users
router.get('/all', async (req, res): Promise<any> => {
  try {
    const users = await getAllUsers();
    return res.status(200).json(users);
  } catch (err) {
    console.error('Error fetching users:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get a user by ID
router.get('/:id', async (req, res): Promise<any> => {
  try {
    const user = await getUserById(req.params.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(user);
  } catch (err) {
    console.error('Error fetching user by ID:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get a user by email
router.get('/email/:email', async (req, res): Promise<any> => {
  try {
    const user = await getUserByEmail(req.params.email);
    if (!user) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(user);
  } catch (err) {
    console.error('Error fetching user by email:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get a user by wallet address
router.get('/wallet/:walletAddress', async (req, res): Promise<any> => {
  try {
    const user = await getUserByWalletAddress(req.params.walletAddress);
    if (!user) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(user);
  } catch (err) {
    console.error('Error fetching user by wallet address:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Delete a user by ID
router.delete('/:id', async (req, res): Promise<any> => {
  try {
    const deletedUser = await deleteUser(req.params.id);
    if (!deletedUser) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(deletedUser);
  } catch (err) {
    console.error('Error deleting user:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Add activity data for a user
router.post('/:id/activity', async (req, res): Promise<any> => {
  try {
    const updatedUser = await addActivityData(req.params.id, req.body);
    if (!updatedUser) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(updatedUser);
  } catch (err) {
    console.error('Error adding activity data:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Update activity data for a specific date
router.put('/:id/activity', async (req, res): Promise<any> => {
  try {
    const { date, ...updates } = req.body;
    if (!date) return res.status(400).json({ message: 'Date is required' });
    
    const updatedUser = await updateActivityData(req.params.id, new Date(date), updates);
    if (!updatedUser) return res.status(404).json({ message: 'User or activity data not found' });
    return res.status(200).json(updatedUser);
  } catch (err) {
    console.error('Error updating activity data:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get activity data for a specific date range
router.get('/:id/activity', async (req, res): Promise<any> => {
  try {
    const { startDate, endDate } = req.query;
    
    if (!startDate || !endDate) {
      return res.status(400).json({ message: 'Start date and end date are required' });
    }
    
    const user = await getActivityDataByDateRange(
      req.params.id, 
      new Date(startDate as string), 
      new Date(endDate as string)
    );
    
    if (!user) return res.status(404).json({ message: 'User not found' });
    return res.status(200).json(user);
  } catch (err) {
    console.error('Error fetching activity data by date range:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

export default router;