import type {
  Request,
  Response,
  NextFunction
} from "express";

import jwt from "jsonwebtoken";

interface TokenPayload {
  id: string;
}

export function authenticate(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      success: false,
      message: "Authentication required"
    });
  }

  const token = authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: "Invalid token"
    });
  }

  try {
    const secret = process.env.JWT_SECRET;

    if (!secret) {
      throw new Error("JWT_SECRET is not configured");
    }

    const decoded = jwt.verify(token, secret) as TokenPayload;

    if (!decoded.id) {
      return res.status(401).json({
        success: false,
        message: "Invalid token payload"
      });
    }

    req.user = {
      id: decoded.id
    };

    next();
  } catch {
    return res.status(401).json({
      success: false,
      message: "Invalid or expired token"
    });
  }
}