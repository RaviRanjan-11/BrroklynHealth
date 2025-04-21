import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/UserSchema.js'; // Ensure the path is correct

const loginUser = async (req, res) => {
  try {

    console.log('Login attempt:', req.body);
    const { email, password } = req.body;

    // Check if user exists
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Create token
    const token = jwt.sign(
      { userId: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Return user without password
    const { password: _, ...userData } = user.toObject();

    res.json({
      token,
      user: userData
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
};

export default loginUser;
