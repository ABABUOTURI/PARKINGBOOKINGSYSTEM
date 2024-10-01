// UnifiedLoginPage.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_booking_system/screens/Admin/Owner/AdminDashboard.dart';
import 'package:parking_booking_system/screens/Auth/DriverReg.dart'; // Import your registration page
import 'package:parking_booking_system/screens/Driver/Dashboard.dart'; // Import the Driver dashboard page

class UnifiedLoginPage extends StatefulWidget {
  @override
  _UnifiedLoginPageState createState() => _UnifiedLoginPageState();
}

class _UnifiedLoginPageState extends State<UnifiedLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Controller for Phone Number
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole; // Selected Role
  bool _obscurePassword = true;
  bool _isLoading = false; // To show loading indicator

void _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text;
    String? role = _selectedRole;

    // Enhanced validation
    if (role == null) {
      _showDialog("Please select a role.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if ((role == 'Parking Owner' || role == 'Admin') && (email.isEmpty || password.isEmpty)) {
      _showDialog("Please enter your email and password.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (role == 'Driver' && (phone.isEmpty || password.isEmpty)) {
      _showDialog("Please enter your phone number and password.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Email format validation for Parking Owner and Admin
    if ((role == 'Parking Owner' || role == 'Admin') && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showDialog("Please enter a valid email address.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // If role is Driver, validate phone number format
    if (role == 'Driver' && !RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone)) {
      _showDialog("Please enter a valid phone number.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Password validation
    if (password.length < 6) {
      _showDialog("Password must be at least 6 characters long.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential;

      if (role == 'Driver') {
        // For Drivers, using phone number as a unique identifier by constructing a unique email
        String driverEmail = "$phone@drivers.com"; // Example email construction

        // Attempt to sign in with constructed email and password
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: driverEmail,
          password: password,
        );
      } else {
        // For Parking Owner and Admin
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      // Fetch user role from Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users').child(userCredential.user!.uid);
      DatabaseEvent event = await dbRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;

        String userRole = userData['role'];

        if (userRole != role) {
          _showDialog("User role does not match selected role.");
          await FirebaseAuth.instance.signOut();
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Navigate based on role
        if (userRole == "Parking Owner") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardPage()),
          );
        } else if (userRole == "Driver") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else if (userRole == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardPage()), // Replace with your Admin Dashboard Page
          );
        } else {
          _showDialog("Unknown user role.");
          await FirebaseAuth.instance.signOut();
        }
      } else {
        _showDialog("User data not found.");
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided for that user.";
      } else {
        message = "Authentication error: ${e.message}";
      }
      _showDialog(message);
    } catch (e) {
      _showDialog("An error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
}
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login Notice"),
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
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7671FA), // Background color
      body: SingleChildScrollView( // Ensures the content is scrollable to prevent overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image at the top
              Image.asset(
                'assets/dr.png', // Ensure this path is correct
                height: 150,
              ),
              SizedBox(height: 40),

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
                  labelText: "Select Role",
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
                    // Clear controllers when role changes
                    _emailController.clear();
                    _phoneController.clear();
                  });
                },
                validator: (value) => value == null ? 'Please select a role' : null,
              ),
              SizedBox(height: 20),

              // Conditionally display Email and Phone Number fields based on role
              if (_selectedRole == 'Driver') ...[
                // Phone Number Field
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
              ] else if (_selectedRole == 'Admin' || _selectedRole == 'Parking Owner') ...[
                // Email Field only
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
              ],

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
              SizedBox(height: 40),

              // Login Button
              _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE5EAF3), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
              SizedBox(height: 20),

              // Link to Registration Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()), // Ensure RegistrationPage is properly implemented
                  );
                },
                child: Text(
                  "Don't have an account? Register here",
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
