import 'package:flutter/material.dart';
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart';


class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with duration for the motion
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Duration for the sliding image
    );

    // Create an animation that moves from right to left for the image
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start off-screen to the right
      end: Offset(0.0, 0.0),   // End at the center of the screen
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Smooth animation
    ));

    // Create an animation for the text that fades and scales it
    _textAnimation = Tween<double>(
      begin: 0.0,  // Start with no opacity and scale
      end: 1.0,    // End fully visible and at normal scale
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top half background: #7671FA
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF7671FA),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
          // Bottom half background: #E5EAF3
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 - 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE5EAF3),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          // Content
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Welcome text
                FadeTransition(
                  opacity: _textAnimation,
                  child: ScaleTransition(
                    scale: _textAnimation,
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE5EAF3),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _textAnimation,
                  child: ScaleTransition(
                    scale: _textAnimation,
                    child: Text(
                      "Get started with the best parking experience",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFE5EAF3),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                
                // Sliding image with motion
                SlideTransition(
                  position: _slideAnimation,
                  child: Image.asset(
                    'assets/Park.png',  // Path to the image asset
                    width: 400,
                    height: 300,
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Get Started button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the DriverLogin page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UnifiedLoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF07244C),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7E7F9C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
