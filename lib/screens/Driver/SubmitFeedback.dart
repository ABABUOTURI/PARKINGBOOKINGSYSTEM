import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/feedback.dart' as customFeedback; // Alias the custom Feedback model
import 'package:parking_booking_system/models/parking_location.dart'; // Import the ParkingLocation model
import 'package:parking_booking_system/models/user.dart'; // Import the User model
import 'package:twilio_flutter/twilio_flutter.dart'; // Twilio for sending SMS
import 'package:mailer/mailer.dart'; // For sending email
import 'package:mailer/smtp_server.dart'; // For SMTP server

class DriversSubmitFeedbackPage extends StatefulWidget {
  @override
  _DriversSubmitFeedbackPageState createState() => _DriversSubmitFeedbackPageState();
}

class _DriversSubmitFeedbackPageState extends State<DriversSubmitFeedbackPage> {
  double _rating = 0.0; // Ensure rating is a double
  String? _selectedLocation; // Variable for selected parking location
  TextEditingController _commentsController = TextEditingController(); // Controller for comments

  List<String> parkingLocations = []; // List to store parking locations from Hive
  late String userEmail; // Driver's email
  late String userPhoneNumber; // Driver's phone number
  late TwilioFlutter twilioFlutter; // For sending SMS

  @override
  void initState() {
    super.initState();
    _fetchParkingLocations(); // Fetch parking locations from Hive when the page is initialized
    _fetchUserDetails(); // Fetch user's email and phone number from Hive

    // Initialize Twilio
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_ACCOUNT_SID', // Add your Twilio Account SID
      authToken: 'YOUR_AUTH_TOKEN', // Add your Twilio Auth Token
      twilioNumber: 'YOUR_TWILIO_NUMBER', // Add your Twilio phone number
    );
  }

  // Fetch parking locations from Hive
  void _fetchParkingLocations() async {
    final parkingBox = await Hive.openBox<ParkingLocation>('parking_slots'); // Open the Hive box for parking slots
    setState(() {
      parkingLocations = parkingBox.values.map((location) => location.name).toList(); // Fetch and store parking location names
    });
  }

  // Fetch user's email and phone number from Hive
  void _fetchUserDetails() async {
    final userBox = await Hive.openBox<User>('users'); // Open Hive box for users
    User? currentUser = userBox.get(0); // Assume that the current user is stored at index 0
    if (currentUser != null) {
      setState(() {
        userEmail = currentUser.email; // Fetch email from the current user's data
        userPhoneNumber = currentUser.phone; // Fetch phone number from the current user's data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text('Submit Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating Section
              Text(
                'Rate your Parking Experience:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF07244C)),
              ),
              SizedBox(height: 10),
              _buildRatingStars(),

              SizedBox(height: 20),

              // Comments Section
              Text(
                'Comments:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF07244C)),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _commentsController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your comments here...',
                ),
              ),

              SizedBox(height: 20),

              // Parking Location Dropdown
              Text(
                'Select Parking Location:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF07244C)),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedLocation,
                hint: Text('Choose Location'),
                items: parkingLocations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),

              SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _submitFeedback();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF07244C),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Rating Stars
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _rating = (index + 1).toDouble(); // Ensure rating is a double
            });
          },
        );
      }),
    );
  }

  // Function to handle the feedback submission
  void _submitFeedback() async {
    String comments = _commentsController.text;

    if (_rating == 0.0 || _selectedLocation == null || comments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields and provide a rating.'),
        backgroundColor: Colors.red,
      ));
    } else {
      // Create Feedback object
      customFeedback.Feedback feedback = customFeedback.Feedback(
        rating: _rating, // Use double for rating
        comment: comments, // Use 'comment' instead of 'comments'
        location: _selectedLocation!,
        date: DateTime.now().toIso8601String(), // Current date in ISO format
      );

      // Open feedback box and save to Hive
      var feedbackBox = await Hive.openBox<customFeedback.Feedback>('feedback'); // Open feedback box
      await feedbackBox.add(feedback); // Save feedback

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Colors.green,
      ));

      // If rating is 2 stars or below, send email and SMS
      if (_rating <= 2) {
        _sendEmailToUser();
        _sendSmsToUser();
      }

      // Clear fields after submission
      setState(() {
        _rating = 0.0;
        _selectedLocation = null;
        _commentsController.clear();
      });
    }
  }

  // Function to send email to the user
  void _sendEmailToUser() async {
    final smtpServer = gmail('yourEmail@gmail.com', 'yourEmailPassword'); // Replace with your credentials

    final message = Message()
      ..from = Address('yourEmail@gmail.com', 'Parking System')
      ..recipients.add(userEmail)
      ..subject = 'We Value Your Feedback'
      ..text = 'We noticed you rated us 2 stars or below. What improvements can we make to serve you better?';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error sending email: ' + e.toString());
    }
  }

  // Function to send SMS to the user
  void _sendSmsToUser() async {
    try {
      await twilioFlutter.sendSMS(
          toNumber: userPhoneNumber,
          messageBody: 'Thank you for your feedback! You rated us 2 stars or below. Please let us know how we can improve.');
      print('SMS sent successfully');
    } catch (e) {
      print('Error sending SMS: ' + e.toString());
    }
  }
}
