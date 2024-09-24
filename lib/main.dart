import 'package:flutter/material.dart';

import 'package:parking_booking_system/screens/Getstarted.dart';
import 'package:parking_booking_system/screens/loader.dart'; // For the delay functionality

void main() {
  runApp(MyApp());
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
      initialRoute: '/',  // Start with LoaderPage route
      routes: {
        '/': (context) => LoaderPage(),         // Loader page as the first route
        '/getstarted': (context) => GetStartedPage(),  // Route for the Get Started page
        // You can add more routes here for future pages (e.g., LoginPage, HomePage)
      },
    );
  }
}

