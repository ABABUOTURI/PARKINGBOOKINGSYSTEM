import 'dart:async';
import 'package:flutter/material.dart';

class LoaderPage extends StatefulWidget {
  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),  // Time for a single pulse
    )..repeat(reverse: true);  // Make it pulsate

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Navigate to the GetStartedPage after 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/getstarted');
    });
  }

  @override
  void dispose() {
    _controller.dispose();  // Always dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7671FA),  // Background color: #7671FA
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image above the loader
            Image.asset(
              'assets/Park.png', // Replace with your image path
              height: 250, // Set the desired height for the image
            ),
            SizedBox(height: 20), // Add some spacing
            Text(
              "Parking Booking App",
              style: TextStyle(
                color: Color(0xFFE5EAF3), // Text color: #E5EAF3
                fontSize: 24, // Font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            SizedBox(height: 40), // Space between text and loader
            ScaleTransition(
              scale: _animation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE5EAF3)),  // Loader color: #E5EAF3
                strokeWidth: 6.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
