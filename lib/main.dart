import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import custom models
import 'package:parking_booking_system/models/feedback.dart' as customFeedback;
import 'package:parking_booking_system/models/notification.dart';
import 'package:parking_booking_system/models/parking_location.dart';
import 'package:parking_booking_system/models/user.dart';

// Import screens for routing
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

  // Register Hive adapters for all custom models
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ParkingLocationAdapter());
  Hive.registerAdapter(customFeedback.FeedbackAdapter());
  Hive.registerAdapter(CustomNotificationAdapter()); // Register the CustomNotification adapter

  try {
    // Open Hive boxes required for the app
    await Hive.openBox<User>('users');
    await Hive.openBox<ParkingLocation>('parking_slots');
    await Hive.openBox<customFeedback.Feedback>('feedback');
    await Hive.openBox<CustomNotification>('notifications'); // Open notification box

    // Run the main app
    runApp(MyApp());
  } catch (e) {
    // Log and handle initialization error by running an error app
    print('Hive initialization error: $e');
    runApp(HiveErrorApp(errorMessage: e.toString())); // Show error screen if Hive fails
  }
}

// Main application widget with defined routes and theme
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Booking System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF7671FA),
      ),
      initialRoute: '/', // Start with LoaderPage as the initial route
      routes: {
        '/': (context) => LoaderPage(),
        '/getstarted': (context) => GetStartedPage(),
        '/login': (context) => UnifiedLoginPage(),
        '/register': (context) => RegistrationPage(),
        '/submitfeedback': (context) => DriversSubmitFeedbackPage(),
        '/reservationmanagement': (context) => ReservationManagementPage(),
        // Additional routes can be added here
      },
    );
  }
}

// Fallback app widget to display an error message if Hive initialization fails
class HiveErrorApp extends StatelessWidget {
  final String errorMessage;

  HiveErrorApp({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
          child: Text(
            'Failed to initialize Hive.\nError: $errorMessage',
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

// Method to close all Hive boxes, ensuring they’re properly closed when the app terminates
Future<void> closeHiveBoxes() async {
  await Hive.close(); // Close all opened boxes
}

// Implementing App Lifecycle Management for cleanup
class MyAppLifecycle extends StatefulWidget {
  @override
  _MyAppLifecycleState createState() => _MyAppLifecycleState();
}

class _MyAppLifecycleState extends State<MyAppLifecycle> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer to manage app lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    closeHiveBoxes(); // Close Hive boxes when the app is about to exit
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      closeHiveBoxes(); // Close Hive boxes when the app is closed or detached
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyApp(); // Launch the main app
  }
}
