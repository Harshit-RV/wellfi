import express, { Application, NextFunction, Request, Response } from 'express';
import mongoose from 'mongoose';
// import userRoutes from './routes/user.route';
// import fileRoutes from './routes/file.route';
// import ratingRoutes from './routes/rating.route';
// import roomRouter from './routes/room.routes';
// import messageRouter from './routes/message.route';
// import exploreRouter from './routes/explore.route';
// import chemistryTestRouter from './routes/chemistryTest.route';
// import chemistryTestResponseRouter from './routes/chemistryTestResponse.route';
// import deletionRequestsRouter from './routes/deletionRequest.route';
// import reportedUserRouter from './routes/reportedUser.route';
// import blockedUserRouter from './routes/blockedUser.route';
// import genaiRouter from './routes/genai.route';
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

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// Routes
// app.use('/users', userRoutes);


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