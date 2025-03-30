import { Request, Response, NextFunction } from "express";
import admin from "../firebaseAdmin";

declare global {
  namespace Express {
    interface Request {
      uid?: string;
    }
  }
}

export const verifyToken = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const token = req.headers.authorization?.split("Bearer ")[1];

  if (!token) {
    res.status(401).json({ message: "Unauthenticated" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.uid = decodedToken.uid;
    next(); // ✅ Ensure we call `next()` properly
  } catch (error) {
    console.error("Error verifying ID token:", error);
    res.status(401).json({ message: "Invalid token", error });
  }
};