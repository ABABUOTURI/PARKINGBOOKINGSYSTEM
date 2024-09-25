import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:parking_booking_system/screens/Driver/BookingDetails.dart';
import 'package:parking_booking_system/screens/Driver/ReservationManagement.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final String userName = "Ababu Oturi"; // Dynamically fetch based on the logged-in user
  RangeValues _priceRange = RangeValues(10, 100); // Price range filter
  String _parkingType = "Covered"; // Parking type filter
  String _parkingDuration = "Hourly"; // Parking duration filter

  String getInitials(String name) {
    List<String> nameParts = name.split(" ");
    return nameParts.length > 1
        ? "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase()
        : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF7671FA),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Greetings, $userName!"),
            CircleAvatar(
              backgroundColor: Color(0xFF07244C),
              child: Text(
                getInitials(userName),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar for Parking
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for Parking",
                  prefixIcon: Icon(Icons.search, color: Color(0xFF07244C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Color(0xFF07244C)),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Filter Options: Distance, Price Range, Parking Type, Duration
              _buildFilters(),

              SizedBox(height: 20),

              // ListView of Available Parking Slots
              _buildParkingList(context),

              SizedBox(height: 20),

              // Quick Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.directions_car,
                    label: "Book Parking",
                    onTap: () {
                      // Navigate to Booking Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingDetailsPage(
                          parkingSpotName: "XYZ Parking Lot", // Example data
                          bookingDate: "Jan 12, 2024", // Example data
                          bookingTime: "3:00 PM - 5:00 PM", // Example data
                          parkingSpaceType: "Covered", // Example data
                          price: 20.00, // Example data
                        )),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.receipt,
                    label: "View Booking",
                    onTap: () {
                      // Navigate to Reservation Management Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReservationManagementPage()),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.history,
                    label: "Payment History",
                    onTap: () {
                      // Handle Payment History tap
                      print("Payment History clicked");
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.person,
                    label: "Profile",
                    onTap: () {
                      // Handle Profile tap
                      print("Profile clicked");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFFE5EAF3),
        color: Color(0xFF7671FA),
        height: 60,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Color(0xFF07244C)),
          Icon(Icons.search, size: 30, color: Color(0xFF07244C)),
          Icon(Icons.settings, size: 30, color: Color(0xFF07244C)),
          Icon(Icons.notifications, size: 30, color: Color(0xFF07244C)),
          Icon(Icons.person, size: 30, color: Color(0xFF07244C)),
        ],
        onTap: (index) {
          // Handle bottom navigation bar item tap
          print("Nav bar item $index clicked");
        },
      ),
    );
  }

  // Helper method to build Quick Action Buttons
  Widget _buildQuickActionButton({required IconData icon, required String label, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF07244C),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Color(0xFF07244C))),
        ],
      ),
    );
  }

  // Helper method to build Filters section
  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Filters", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // Price Range Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Price Range (Ksh)"),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 200,
              divisions: 10,
              labels: RangeLabels(
                "Ksh${_priceRange.start.round()}",
                "Ksh${_priceRange.end.round()}",
              ),
              onChanged: (RangeValues newRange) {
                setState(() {
                  _priceRange = newRange;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),

        // Parking Type Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Parking Type"),
            DropdownButton<String>(
              value: _parkingType,
              onChanged: (String? newType) {
                setState(() {
                  _parkingType = newType!;
                });
              },
              items: <String>['Covered', 'Uncovered', 'Valet']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Parking Duration Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Parking Duration"),
            DropdownButton<String>(
              value: _parkingDuration,
              onChanged: (String? newDuration) {
                setState(() {
                  _parkingDuration = newDuration!;
                });
              },
              items: <String>['Hourly', 'Daily', 'Weekly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build Parking List
  Widget _buildParkingList(BuildContext context) {
    return Container(
      height: 300, // Adjust height as necessary
      child: ListView.builder(
        itemCount: 10, // Sample parking list length
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Icon(Icons.local_parking, color: Color(0xFF07244C)),
              title: Text('Parking Slot #$index'),
              subtitle: Text('Available - Location XYZ'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigate to BookingDetails page when "Book Now" is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(
                        parkingSpotName: 'Parking Slot #$index', // Pass parking slot info
                        bookingDate: "Jan 12, 2024", // Example data
                        bookingTime: "3:00 PM - 5:00 PM", // Example data
                        parkingSpaceType: "Covered", // Example data
                        price: 20.00, // Example data
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF07244C),
                ),
                child: Text("Book Now", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}
