import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ReservationManagementPage extends StatefulWidget {
  @override
  _ReservationManagementPageState createState() => _ReservationManagementPageState();
}

class _ReservationManagementPageState extends State<ReservationManagementPage> {
  late Box bookingBox; // Hive box for storing bookings

  @override
  void initState() {
    super.initState();
    _openBox(); // Open Hive box for bookings
  }

  // Open Hive box for bookings
  void _openBox() async {
    bookingBox = await Hive.openBox('bookings');
    setState(() {}); // Trigger a rebuild after opening the box
  }

  @override
  Widget build(BuildContext context) {
    if (bookingBox == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              _buildBookingList(context, isUpcoming: true), // Display upcoming bookings
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
              _buildBookingList(context, isUpcoming: false), // Display past bookings
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build booking list from Hive
  Widget _buildBookingList(BuildContext context, {required bool isUpcoming}) {
    List<dynamic> bookings = bookingBox.values.toList();
    // Filter bookings by upcoming or past
    List<dynamic> filteredBookings = bookings.where((booking) {
      DateTime bookingDate = DateTime.parse(booking['dateTime']);
      if (isUpcoming) {
        return bookingDate.isAfter(DateTime.now());
      } else {
        return bookingDate.isBefore(DateTime.now());
      }
    }).toList();

    if (filteredBookings.isEmpty) {
      return Text("No bookings available.");
    }

    return Column(
      children: filteredBookings.map((booking) {
        return _buildBookingCard(
          context,
          booking['title'],
          booking['dateTime'],
          booking['location'],
          isUpcoming: isUpcoming,
        );
      }).toList(),
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
                      _showModifyPopup(context, title, dateTime, location, bookingBox);
                    },
                  ),
                if (isUpcoming) SizedBox(width: 8),
                if (isUpcoming)
                  _buildActionButton(
                    context,
                    icon: Icons.cancel,
                    label: "Cancel",
                    onPressed: () {
                      _cancelBooking(context, title);
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
                      _showRebookPopup(context, title, dateTime, location, bookingBox);
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

  // Show Modify Popup for rescheduling booking
  void _showModifyPopup(BuildContext context, String title, String dateTime, String location, Box bookingBox) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Select Date"),
                subtitle: Text(selectedDate != null ? DateFormat('MMM dd, yyyy').format(selectedDate!) : "No date selected"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text("Select Time"),
                subtitle: Text(selectedTime != null ? selectedTime!.format(context) : "No time selected"),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  // Update the booking in Hive with the new date/time
                  DateTime newDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  bookingBox.put(title, {
                    'title': title,
                    'dateTime': newDateTime.toIso8601String(),
                    'location': location,
                  });
                  setState(() {}); // Trigger UI update
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Show Rebook Popup for rescheduling past booking
  void _showRebookPopup(BuildContext context, String title, String dateTime, String location, Box bookingBox) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rebook Parking Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Select Date"),
                subtitle: Text(selectedDate != null ? DateFormat('MMM dd, yyyy').format(selectedDate!) : "No date selected"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text("Select Time"),
                subtitle: Text(selectedTime != null ? selectedTime!.format(context) : "No time selected"),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Rebook'),
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  DateTime newDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  bookingBox.put(title, {
                    'title': title,
                    'dateTime': newDateTime.toIso8601String(),
                    'location': location,
                  });
                  setState(() {}); // Trigger UI update
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Cancel the booking and delete it from Hive
  void _cancelBooking(BuildContext context, String title) {
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
                bookingBox.delete(title); // Delete booking from Hive
                setState(() {}); // Trigger UI update
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
