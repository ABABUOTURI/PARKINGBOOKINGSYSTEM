import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/screens/Admin/Owner/AdminDashboard.dart';
import 'package:parking_booking_system/screens/Auth/DriverReg.dart'; // Import your registration page
import 'package:parking_booking_system/screens/Driver/Dashboard.dart'; // Import the Driver dashboard page
import 'package:parking_booking_system/models/user.dart'; // Import the User model
import 'user_service.dart';

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

  // Initialize Hive
  Box<User>? userBox;

  @override
  void initState() {
    super.initState();
    // Open the Hive box for user data
    openUserBox();
  }

  void openUserBox() async {
    userBox = await Hive.openBox<User>('userBox'); // Open Hive box named 'userBox'
  }

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

    // Fetch user data from Hive
    bool loginSuccess = false;

    // Iterate through users in the Hive box
    for (int i = 0; i < userBox!.length; i++) {
      User user = userBox!.getAt(i)!; // Get the user data
      if (user.role == role && user.password == password) {
        if ((role == 'Parking Owner' || role == 'Admin') && user.email == email) {
          loginSuccess = true;
          break;
        } else if (role == 'Driver' && user.phone == phone) {
          loginSuccess = true;
          break;
        }
      }
    }

    if (loginSuccess) {
      // Navigate based on role
      if (role == "Parking Owner" || role == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardPage()),
        );
      } else if (role == "Driver") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()), // Use the correct Driver dashboard page
        );
      }
    } else {
      _showDialog("Invalid login credentials.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Notice"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
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
      backgroundColor: const Color(0xFF7671FA), // Background color
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
              const SizedBox(height: 40),

              // Role Dropdown Field
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: <String>['Admin', 'Parking Owner', 'Driver']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: "Select Role",
                  labelStyle: const TextStyle(color: Color(0xFFE5EAF3)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                dropdownColor: const Color(0xFFE5EAF3),
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
              const SizedBox(height: 20),

              // Conditionally display Email and Phone Number fields based on role
              if (_selectedRole == 'Driver') ...[
                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: const TextStyle(color: Color(0xFFE5EAF3)), // Text color
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
              ] else if (_selectedRole == 'Admin' || _selectedRole == 'Parking Owner') ...[
                // Email Field only
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Color(0xFFE5EAF3)), // Text color
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
              ],

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Color(0xFFE5EAF3)), // Text color
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFFE5EAF3),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _login, // Disable button while loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C7FEE), // Button color
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),

              // Registration Link
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()), // Navigate to the registration page
                  );
                },
                child: const Text(
                  "Don't have an account? Register here",
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
