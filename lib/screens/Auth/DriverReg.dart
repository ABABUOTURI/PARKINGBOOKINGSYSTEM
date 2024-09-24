import 'package:flutter/material.dart';
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _register() {
    // Implement registration logic here

    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Simple validation (you can enhance this)
    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showDialog("Please fill in all fields.");
      return;
    }
    if (password != confirmPassword) {
      _showDialog("Passwords do not match.");
      return;
    }

    // Registration successful (you can add actual registration logic here)
    _showDialog("Registration successful!");
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notice"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7671FA), // Background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image at the top
            Image.asset(
              'assets/dr1.png', // Replace with your image asset path
              height: 150,
            ),
            SizedBox(height: 40),

            // Full Name Field
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),

            // Phone Number Field
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFFE5EAF3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword; // Toggle visibility
                    });
                  },
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFFE5EAF3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword; // Toggle visibility
                    });
                  },
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 40),

            // Register Button
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF07244C), // Button color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7E7F9C), // Button text color
                ),
              ),
            ),
            SizedBox(height: 20),

            // Login link
            TextButton(
            onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverLoginPage()), // Navigate to DriverRegPage
    );
  },
              child: Text(
                "Already have an Account? Login",
                style: TextStyle(color: Color(0xFFE5EAF3)), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
