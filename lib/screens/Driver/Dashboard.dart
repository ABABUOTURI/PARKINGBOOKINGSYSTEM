import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/parking_location.dart';
import 'package:parking_booking_system/models/user.dart';
import 'package:parking_booking_system/screens/Driver/BookingDetails.dart';
import 'package:parking_booking_system/screens/Driver/ReservationManagement.dart';
import 'package:parking_booking_system/screens/Driver/SubmitFeedback.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = ''; // Default user name
  String _userInitials = ''; // Default user initials
  RangeValues _priceRange = RangeValues(10, 100); // Price range filter
  String _statusFilter = "All"; // Status filter
  String _searchQuery = ""; // Search query state
  List<ParkingLocation> _parkingSlots = []; // List to store parking slots from Hive
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key for the scaffold

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data from Hive upon initialization
    _fetchParkingSlots(); // Fetch parking slots from Hive upon initialization
  }

  // Fetch user data from Hive (local storage)
  void _fetchUserData() async {
    final userBox = await Hive.openBox<User>('userBox'); // Open Hive box
    if (userBox.isNotEmpty) {
      User? user = userBox.getAt(0); // Get the first user (assuming only one logged-in user)
      if (user != null) {
        setState(() {
          _userName = user.fullName; // Set the user's full name
          _userInitials = _getInitials(user.fullName); // Set the initials based on full name
        });
      }
    }
  }

  // Fetch parking slots from Hive (local storage)
  void _fetchParkingSlots() async {
    final parkingBox = await Hive.openBox<ParkingLocation>('parking_slots'); // Open Hive box
    setState(() {
      _parkingSlots = parkingBox.values.toList(); // Load parking slots into the list
    });
  }

  // Method to extract initials from the full name
  String _getInitials(String fullName) {
    List<String> nameParts = fullName.split(" ");
    return nameParts.length > 1
        ? "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase()
        : fullName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF7671FA),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Greetings, $_userName!"),
            CircleAvatar(
              backgroundColor: Color(0xFF07244C),
              child: Text(
                _userInitials, // Display initials
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer(); // Open the drawer when menu icon is tapped
            },
          ),
        ],
      ),
      drawer: _buildDrawer(), // Build the sidebar drawer
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
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              SizedBox(height: 20),

              // Map View
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(-1.286389, 36.817223), // Example coordinates for Nairobi
                    zoom: 10,
                  ),
                  markers: _buildMarkers(), // Add markers based on parking slots
                ),
              ),

              SizedBox(height: 20),

              // Filter Options: Price Range, Status
              _buildFilters(),

              SizedBox(height: 20),

              // ListView of Available Parking Slots
              _buildParkingList(context),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the sidebar (drawer)
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName.isNotEmpty ? _userName : 'User', // Display user's name or default
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _userInitials.isNotEmpty ? _userInitials : 'U', // Display initials or default
                    style: TextStyle(
                      color: Color(0xFF7671FA),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF7671FA),
            ),
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('View Booking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationManagementPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Payment History'),
            onTap: () {
              //Navigator.push(
              // context,
              // MaterialPageRoute(builder: (context) => PaymentHistoryPage()), // Add this page
              //);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              //Navigator.push(
              // context,
              // MaterialPageRoute(builder: (context) => ProfilePage()), // Add this page
              //);
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Submit Feedback'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriversSubmitFeedbackPage()), // Navigate to SubmitFeedbackPage
              );
            },
          ),
          // Add Notification ListTile with Icon
          ListTile(
            leading: Stack(
              children: [
                Icon(Icons.notifications), // Notification icon
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '3', // Display number of notifications
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to NotificationPage (make sure to create this page)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()), // Create and navigate to NotificationPage
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper method to build Filters section
  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 10),

        // Price Range Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Price Range (Ksh)"),
            Expanded(
              child: RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200,
                divisions: 20,
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
            ),
          ],
        ),
        SizedBox(height: 10),

        // Status Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Status"),
            DropdownButton<String>(
              value: _statusFilter,
              onChanged: (String? newStatus) {
                setState(() {
                  _statusFilter = newStatus!;
                });
              },
              items: <String>['All', 'Available', 'Occupied', 'Under Maintenance']
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

  // Helper method to build Parking List from Hive
  Widget _buildParkingList(BuildContext context) {
    // Filter parking slots based on search query and selected filters
    final filteredSlots = _parkingSlots.where((slot) {
      final matchesSearchQuery = slot.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPrice = slot.price >= _priceRange.start && slot.price <= _priceRange.end;
      final matchesStatus = _statusFilter == "All" || slot.status == _statusFilter;

      return matchesSearchQuery && matchesPrice && matchesStatus;
    }).toList();

    if (filteredSlots.isEmpty) {
      return Text("No parking slots match your search criteria.");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredSlots.length,
      itemBuilder: (context, index) {
        final parkingSlot = filteredSlots[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the booking page with the parking slot details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailsPage(
                  parkingSpotName: parkingSlot.name,
                  bookingDate: "Select Date", // Update this to be dynamic
                  bookingTime: "Select Time", // Update this to be dynamic
                  parkingSpaceType: parkingSlot.status, // Use the status as space type
                  price: parkingSlot.price,
                  pricePerHour: parkingSlot.price,
                ),
              ),
            );
          },
          
          child: Card(
            elevation: 2,
            child: ListTile(
              title: Text(parkingSlot.name),
              subtitle: Text("${parkingSlot.address} | ${parkingSlot.status}"),
              trailing: Text(
                "Ksh${parkingSlot.price}", // Display price
                style: TextStyle(
                  color: parkingSlot.status == 'Available'
                      ? Colors.green
                      : parkingSlot.status == 'Occupied'
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to build markers for Google Map
  Set<Marker> _buildMarkers() {
    return _parkingSlots.map((parkingSlot) {
      return Marker(
        markerId: MarkerId(parkingSlot.id.toString()), // Unique ID for the marker
        position: LatLng(parkingSlot.latitude, parkingSlot.longitude), // Corrected usage
        infoWindow: InfoWindow(
          title: parkingSlot.name,
          snippet: '${parkingSlot.address} | Ksh${parkingSlot.price}',
        ),
      );
    }).toSet();
  }
}

// Create the NotificationPage
class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF7671FA),
      ),
      body: Center(
        child: Text(
          'You have 3 new notifications!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
