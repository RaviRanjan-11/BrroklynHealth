import express from 'express';
import  loginUser  from '../controllers/UserController.js'; // ES6 import

const router = express.Router();

// POST /api/auth/login
router.post('/login', loginUser);

export default router;
