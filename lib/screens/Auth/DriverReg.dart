import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart'; // Update this import if necessary

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Controller for role selection
  String? _selectedRole;
  final DatabaseReference _database = FirebaseDatabase.instance.ref(); // Database reference

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  void _register() async {
  // Collect user input
  String fullName = _fullNameController.text.trim();
  String email = _emailController.text.trim();
  String phone = _phoneController.text.trim();
  String password = _passwordController.text;
  String confirmPassword = _confirmPasswordController.text;
  String? role = _selectedRole;

  // Enhanced validation
  if (fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty || role == null) {
    _showDialog("Please fill in all required fields and select a role.");
    return;
  }

  // Check role-specific requirements
  if (role == 'Driver' && phone.isEmpty) {
    _showDialog("Please enter your phone number.");
    return;
  } else if (role == 'Parking Owner' && email.isEmpty) {
    _showDialog("Please enter your email address.");
    return;
  }

  // Email format validation for Parking Owner
  if (role == 'Parking Owner' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    _showDialog("Please enter a valid email address.");
    return;
  }

  // Validate phone number format for Driver
  if (role == 'Driver' && !RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone)) {
    _showDialog("Please enter a valid phone number.");
    return;
  }

  if (password != confirmPassword) {
    _showDialog("Passwords do not match.");
    return;
  }

  if (password.length < 6) {
    _showDialog("Password must be at least 6 characters long.");
    return;
  }

  try {
    UserCredential userCredential;
    if (role == 'Driver') {
      // Construct a unique email address for Drivers
      String driverEmail = "$phone@drivers.com";

      // Register using the constructed email and password
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: driverEmail,
        password: password,
      );

      email = driverEmail; // Store this email for consistency
    } else {
      // Register for Parking Owners with the provided email
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    User? user = userCredential.user;

    if (user != null) {
      String userId = user.uid; // Get the unique user ID

      // Save additional user data to Firebase Realtime Database
      await _database.child('users/$userId').set({
        'fullName': fullName,
        'email': email,
        'phone': role == 'Driver' ? phone : '', // Only save phone if role is Driver
        'role': role,
        'userId': userId, // Store unique user ID
      });

      // Optionally, update the display name
      await user.updateDisplayName(fullName);

      // Show success message
      _showDialog("Successfully Registered!");

      // Navigate to login page after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UnifiedLoginPage()), // Update to your login page
        );
      });
    } else {
      _showDialog("Registration failed. User not found.");
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase-specific errors
    String errorMessage = "Registration failed.";
    if (e.code == 'email-already-in-use') {
      errorMessage = "The email address is already in use.";
    } else if (e.code == 'invalid-email') {
      errorMessage = "The email address is invalid.";
    } else if (e.code == 'weak-password') {
      errorMessage = "The password is too weak.";
    }
    _showDialog(errorMessage);
  } catch (e) {
    // Handle other errors
    _showDialog("Registration failed: $e");
  }
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
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7671FA), // Background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image at the top
              Image.asset(
                'assets/dr1.png', // Replace with your image asset path
                height: 100,
              ),
              SizedBox(height: 10),

              // Full Name Field
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
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
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Role Dropdown Field
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: <String>['Admin', 'Parking Owner', 'Driver']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: "Role",
                  labelStyle: TextStyle(color: Color(0xFFE5EAF3)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                dropdownColor: Color(0xFFE5EAF3),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a role' : null,
              ),
              SizedBox(height: 20),

              // Phone Number Field (conditionally displayed)
              if (_selectedRole == 'Driver')
                Column(
                  children: [
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color(0xFFE5EAF3)), // Text color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFFE5EAF3),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
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
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFFE5EAF3),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),

              // Register Button
              ElevatedButton(
                onPressed: _register,
                child: Text("Register"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Color(0xFFE5EAF3), // Text color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Already have an account
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UnifiedLoginPage()), // Update to your login page
                  );
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Color(0xFFE5EAF3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
