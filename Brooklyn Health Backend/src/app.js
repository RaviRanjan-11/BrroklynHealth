import express from 'express';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import createSuperAdmin from './config/seed.js';
import cors from 'cors'

dotenv.config();

const app = express();

app.use(express.json());

import userRoutes from './routes/authRoute.js';

// Connect to the MongoDB database
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('MongoDB connected');
    createSuperAdmin(); // Seed Super Admin on DB connection
  })
  .catch((err) => console.log('MongoDB connection error:', err));


//Routes 

app.use('/api/users', userRoutes);


app.use(cors({
  origin: '*', // Allow all origins (be more specific for production)
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.get('/', (req, res) => {
  res.send('Brooklyn Health Backend is running 🚀');
});

export default app;
