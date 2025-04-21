import mongoose from 'mongoose';
import User from '../models/UserSchema.js'; // Correct
import bcrypt from 'bcryptjs';

// Default Super Admin Credentials
const superAdminCredentials = {
  name: 'Super Admin',
  email: 'super@admin.com',
  password: 'superadmin123',
  role: 'super_admin',
};

const createSuperAdmin = async () => {
  try {
    // Check if a Super Admin already exists
    const superAdmin = await User.findOne({ role: 'super_admin' });

    if (superAdmin) {
      console.log('Super Admin already exists');
      return;
    }

    const hashedPassword = await bcrypt.hash(superAdminCredentials.password, 10);

    // Create a new Super Admin
    const newSuperAdmin = new User({
      ...superAdminCredentials,
      password: hashedPassword,
    });

    await newSuperAdmin.save();

    console.log('Super Admin created successfully');
  } catch (error) {
    console.error('Error creating Super Admin:', error.message);
  }
};

export default createSuperAdmin;
