import 'package:flutter/material.dart';

class DriversSubmitFeedbackPage extends StatefulWidget {
  @override
  _DriversSubmitFeedbackPageState createState() => _DriversSubmitFeedbackPageState();
}

class _DriversSubmitFeedbackPageState extends State<DriversSubmitFeedbackPage> {
  double _rating = 0; // Variable for rating
  String? _selectedLocation; // Variable for selected parking location
  TextEditingController _commentsController = TextEditingController(); // Controller for comments

  // List of parking locations
  List<String> parkingLocations = ['Downtown Lot', 'City Center', 'Mall Parking', 'Airport Parking'];

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
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }

  // Function to handle the feedback submission
  void _submitFeedback() {
    String comments = _commentsController.text;
    //String location = _selectedLocation ?? 'Not selected';

    if (_rating == 0 || _selectedLocation == null || comments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields and provide a rating.'),
        backgroundColor: Colors.red,
      ));
    } else {
      // Implement submission logic here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Colors.green,
      ));

      // Clear fields after submission
      setState(() {
        _rating = 0;
        _selectedLocation = null;
        _commentsController.clear();
      });
    }
  }
}
