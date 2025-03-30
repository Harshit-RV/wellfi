import express from 'express';
import {
  createChallenge,
  updateChallengeById,
  getAllChallenges,
  getChallengeById,
  getChallengesByCreator,
  getChallengesByParticipant,
  deleteChallenge,
  addParticipantToChallenge,
  removeParticipantFromChallenge
} from '../services/challenge.service';
import { verifyToken } from '../middleware/auth';

const router = express.Router();

// router.use(verifyTken);

// Create a new challenge
router.post("/create", async (req, res) : Promise<any> => {
  try {
    const newChallenge = await createChallenge(req.body);
    return res.status(201).json(newChallenge);
  } catch (err) {
    console.error('Error creating challenge:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Update a challenge by ID
router.put('/update/:id', async (req, res) : Promise<any> => {
  try {
    const updatedChallenge = await updateChallengeById(req.params.id, req.body);
    if (!updatedChallenge) return res.status(404).json({ message: 'Challenge not found' });
    return res.status(200).json(updatedChallenge);
  } catch (err) {
    console.error('Error updating challenge:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get all challenges
router.get('/all', async (req, res) : Promise<any> => {
  try {
    const challenges = await getAllChallenges();
    return res.status(200).json(challenges);
  } catch (err) {
    console.error('Error fetching challenges:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get a challenge by ID
router.get('/:id', async (req, res) : Promise<any> => {
  try {
    const challenge = await getChallengeById(req.params.id);
    if (!challenge) return res.status(404).json({ message: 'Challenge not found' });
    return res.status(200).json(challenge);
  } catch (err) {
    console.error('Error fetching challenge by ID:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get challenges by creator
router.get('/creator/:creatorId', async (req, res) : Promise<any> => {
  try {
    const challenges = await getChallengesByCreator(req.params.creatorId);
    return res.status(200).json(challenges);
  } catch (err) {
    console.error('Error fetching challenges by creator:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Get challenges by participant
router.get('/participant/:participantId', async (req, res) : Promise<any>=> {
  try {
    const challenges = await getChallengesByParticipant(req.params.participantId);
    return res.status(200).json(challenges);
  } catch (err) {
    console.error('Error fetching challenges by participant:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Delete a challenge by ID
router.delete('/:id', async (req, res) : Promise<any>=> {
  try {
    const deletedChallenge = await deleteChallenge(req.params.id);
    if (!deletedChallenge) return res.status(404).json({ message: 'Challenge not found' });
    return res.status(200).json(deletedChallenge);
  } catch (err) {
    console.error('Error deleting challenge:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Add a participant to a challenge
router.post('/:challengeId/participant/:participantId', async (req, res) : Promise<any>=> {
  try {
    const updatedChallenge = await addParticipantToChallenge(req.params.challengeId, req.params.participantId);
    if (!updatedChallenge) return res.status(404).json({ message: 'Challenge not found' });
    return res.status(200).json(updatedChallenge);
  } catch (err) {
    console.error('Error adding participant to challenge:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

// Remove a participant from a challenge
router.delete('/:challengeId/participant/:participantId', async (req, res) : Promise<any>=> {
  try {
    const updatedChallenge = await removeParticipantFromChallenge(req.params.challengeId, req.params.participantId);
    if (!updatedChallenge) return res.status(404).json({ message: 'Challenge not found' });
    return res.status(200).json(updatedChallenge);
  } catch (err) {
    console.error('Error removing participant from challenge:', err);
    res.status(500).json({ error: 'Internal server error', details: err });
  }
});

export default router;
