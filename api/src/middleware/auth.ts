import { Request, Response, NextFunction } from "express";
import admin from "../firebaseAdmin";

declare global {
  namespace Express {
    interface Request {
      uid?: string;
    }
  }
}

export const verifyToken = async (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split("Bearer ")[1];

  if (!token) {
    return res.status(401).send({ message: "Unauthenticated" });
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.uid = decodedToken.uid;
    next();
  } catch (error) {
    console.error("Error verifying ID token:", error);
    return res.status(401).send({ message: "Invalid token", error: error });
  }
};