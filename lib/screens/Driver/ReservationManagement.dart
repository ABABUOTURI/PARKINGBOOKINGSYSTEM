import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        automaticallyImplyLeading: true, // Show the back button
        backgroundColor: Color(0xFF7671FA),
        title: Text("Reservation Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upcoming Bookings Section
              Text(
                "Upcoming Bookings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF07244C),
                ),
              ),
              SizedBox(height: 10),
              _buildBookingCard(
                context,
                "Parking Slot A12",
                "Jan 12, 2024 - 3:00 PM",
                "Location: XYZ Street",
                isUpcoming: true,
              ),
              SizedBox(height: 20),

              // Past Bookings Section
              Text(
                "Past Bookings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF07244C),
                ),
              ),
              SizedBox(height: 10),
              _buildBookingCard(
                context,
                "Parking Slot B23",
                "Dec 18, 2023 - 10:00 AM",
                "Location: ABC Avenue",
                isUpcoming: false,
              ),
              _buildBookingCard(
                context,
                "Parking Slot C34",
                "Nov 24, 2023 - 6:00 PM",
                "Location: DEF Street",
                isUpcoming: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build Booking Card
  Widget _buildBookingCard(BuildContext context, String title, String dateTime, String location, {required bool isUpcoming}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07244C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              dateTime,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              location,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),

            // Modify, Cancel, and Rebook buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUpcoming)
                  _buildActionButton(
                    context,
                    icon: Icons.edit,
                    label: "Modify",
                    onPressed: () {
                      // Navigate to Modify Booking Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifyBookingPage(
                            title: title,
                            dateTime: dateTime,
                            location: location,
                          ),
                        ),
                      );
                    },
                  ),
                if (isUpcoming) SizedBox(width: 8),
                if (isUpcoming)
                  _buildActionButton(
                    context,
                    icon: Icons.cancel,
                    label: "Cancel",
                    onPressed: () {
                      // Show confirmation dialog for canceling the booking
                      _showCancelConfirmationDialog(context);
                    },
                  ),
                // Add Rebook button for past bookings
                if (!isUpcoming) SizedBox(width: 8),
                if (!isUpcoming)
                  _buildActionButton(
                    context,
                    icon: Icons.repeat,
                    label: "Rebook",
                    onPressed: () {
                      // Navigate to Modify Booking Page for rebooking
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifyBookingPage(
                            title: title,
                            dateTime: dateTime,
                            location: location,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build Action Buttons (Modify, Cancel, Rebook)
  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF07244C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Helper method to show cancellation confirmation dialog
  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cancel Booking"),
          content: Text("Are you sure you want to cancel this booking?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                // Handle cancellation logic here
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking Canceled')));
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

// New Page for Modifying Booking
class ModifyBookingPage extends StatefulWidget {
  final String title;
  final String dateTime;
  final String location;

  ModifyBookingPage({required this.title, required this.dateTime, required this.location});

  @override
  _ModifyBookingPageState createState() => _ModifyBookingPageState();
}

class _ModifyBookingPageState extends State<ModifyBookingPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Parse initial date and time from the string
    _parseDateTime(widget.dateTime);
  }

  void _parseDateTime(String dateTime) {
    try {
      final dateParts = dateTime.split(" - ");
      if (dateParts.length == 2) {
        // Attempt to parse date (assuming format is "MMM dd, yyyy")
        _selectedDate = _parseDate(dateParts[0].trim());
        
        // Attempt to parse time
        final timeParts = dateParts[1].split(":");
        if (timeParts.length >= 2) {
          int hour = int.parse(timeParts[0].trim());
          int minute = int.parse(timeParts[1].trim().split(" ")[0]);

          // Handle AM/PM
          if (timeParts[1].trim().contains("PM") && hour < 12) {
            hour += 12; // Convert PM hour to 24-hour format
          } else if (timeParts[1].trim().contains("AM") && hour == 12) {
            hour = 0; // Midnight case
          }

          _selectedTime = TimeOfDay(hour: hour, minute: minute);
        } else {
          throw FormatException("Invalid time format.");
        }
      } else {
        throw FormatException("Invalid date/time format.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error parsing date/time: $e')));
    }
  }

  DateTime _parseDate(String date) {
    // Parse the date from "MMM dd, yyyy" format
    return DateFormat('MMM dd, yyyy').parse(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text("Modify Booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Title: ${widget.title}"),
            Text("Current Date/Time: ${widget.dateTime}"),
            Text("Location: ${widget.location}"),
            SizedBox(height: 20),

            // Date and Time Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("Select Date"),
                    subtitle: Text(_selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                        : "No date selected"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ListTile(
                    title: Text("Select Time"),
                    subtitle: Text(_selectedTime != null
                        ? _selectedTime!.format(context)
                        : "No time selected"),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),


            // Modify Booking Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle modification logic
                  // Optionally, navigate back or show confirmation
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking Modified Successfully')));
                },
                child: Text("Modify Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Select Date method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Select Time method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
