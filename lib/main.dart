import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parking_booking_system/models/feedback.dart' as customFeedback; // Alias for Feedback model
import 'package:parking_booking_system/models/notification.dart' as customNotification; // Alias for Notification model
import 'package:parking_booking_system/models/parking_location.dart'; // Import ParkingLocation model
import 'package:parking_booking_system/models/user.dart'; // Import User model

import 'package:parking_booking_system/screens/Auth/DriverReg.dart';
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart';
import 'package:parking_booking_system/screens/Driver/SubmitFeedback.dart';
import 'package:parking_booking_system/screens/Getstarted.dart';
import 'package:parking_booking_system/screens/loader.dart';
import 'package:parking_booking_system/screens/Driver/ReservationManagement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ParkingLocationAdapter());
  Hive.registerAdapter(customFeedback.FeedbackAdapter());
  

  try {
    // Open the boxes for different models
    await Hive.openBox<User>('users');
    await Hive.openBox<ParkingLocation>('parking_slots');
    await Hive.openBox<customFeedback.Feedback>('feedback');
   

    runApp(MyApp());
  } catch (e) {
    // Handle Hive initialization error
    print('Hive initialization error: $e');
    runApp(HiveErrorApp()); // Show an error screen if Hive fails
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
        '/getstarted': (context) => GetStartedPage(), // Route for Get Started page
        '/login': (context) => UnifiedLoginPage(), // Route for Login Page
        '/register': (context) => RegistrationPage(), // Registration page route
        '/submitfeedback': (context) => DriversSubmitFeedbackPage(), // Route for Submit Feedback page
        '/reservationmanagement': (context) => ReservationManagementPage(), // Route for Reservation Management page
        // Add more routes here for future pages
      },
    );
  }
}

// Optional: A simple error app to display Hive initialization errors
class HiveErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
          child: Text(
            'Failed to initialize Hive.\nPlease check your configuration.',
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

// Close all Hive boxes before the app terminates
Future<void> closeHiveBoxes() async {
  await Hive.close(); // Close all opened boxes
}
