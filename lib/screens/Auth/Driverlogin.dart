import 'package:flutter/material.dart';
import 'package:parking_booking_system/screens/Auth/DriverReg.dart';

class DriverLoginPage extends StatefulWidget {
  @override
  _DriverLoginPageState createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    // Dummy credentials for login
    String emailOrPhone = _emailController.text;
    String password = _passwordController.text;

    if ((emailOrPhone == "aoturi@kabarak.ac.ke" || emailOrPhone == "0714205641") &&
        password == "12345678") {
      // Navigate to Dashboard if login is successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      // Show an alert for failed login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text("Invalid email/phone number or password."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
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
              'assets/dr.png', // Ensure this path is correct
              height: 150,
            ),
            SizedBox(height: 40),

            // Email/Phone No Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email/Phone No",
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
            SizedBox(height: 40),

            // Login Button
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF07244C), // Button color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7E7F9C), // Button text color
                ),
              ),
            ),
            SizedBox(height: 20),

            // Forgot Password link
            TextButton(
              onPressed: () {
                // Action for forgot password
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(color: Color(0xFFE5EAF3)), // Text color
              ),
            ),
            SizedBox(height: 10),

            // Register link
            TextButton(
             onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()), // Navigate to DriverRegPage
    );
  },
              child: Text(
                "Don't have an Account? Register",
                style: TextStyle(color: Color(0xFFE5EAF3)), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Text("Welcome to the Dashboard!"),
      ),
    );
  }
}
