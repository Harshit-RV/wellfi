import express, { Application, NextFunction, Request, Response } from 'express';
import mongoose from 'mongoose';
// import userRoutes from './routes/user.route';
import challengeRoutes from './routes/challenge.route';
import userRoutes from './routes/user.route';
import config from './config';
import "dotenv/config";
import cors from 'cors';
import http from 'http';

const app: Application = express();

// Create HTTP Server
const server = http.createServer(app);

// Middleware
app.use(express.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect(config.mongoURI);

app.get('/v1/health', (req, res) => {
  res.status(200).send('OK');
});

app.use('/v1/challenges', challengeRoutes);
app.use('/v1/users', userRoutes);

// Global Error Handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error(err.stack);
  res.status(401).send('Unauthenticated!');
});

// Start the server
const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});