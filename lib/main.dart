import 'package:flutter/material.dart';
import 'package:parking_booking_system/firebase_options.dart';
import 'package:parking_booking_system/screens/Auth/DriverReg.dart';
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart';
import 'package:parking_booking_system/screens/Getstarted.dart';
import 'package:parking_booking_system/screens/loader.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase initialization
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Ensure this is correctly set
    );
    runApp(MyApp());
  } catch (e) {
    // Handle Firebase initialization error
    print('Firebase initialization error: $e');
    // Optionally, show an error screen or retry mechanism
    runApp(FirebaseErrorApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Booking System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7671FA),
      ),
      initialRoute: '/', // Start with LoaderPage route
      routes: {
        '/': (context) => LoaderPage(), // Loader page as the first route
        '/getstarted': (context) => GetStartedPage(), // Route for the Get Started page
        '/login': (context) => UnifiedLoginPage(), // Route for Login Page
        '/register': (context) => RegistrationPage(), // Add registration route
        // Add more routes here for future pages (e.g., HomePage)
      },
    );
  }
}

// Optional: A simple error app to display Firebase initialization errors
class FirebaseErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
          child: Text(
            'Failed to initialize Firebase.\nPlease check your configuration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
