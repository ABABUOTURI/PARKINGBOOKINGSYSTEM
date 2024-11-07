import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/parking_location.dart';
import 'package:parking_booking_system/models/user.dart';
import 'package:parking_booking_system/screens/Driver/BookingDetails.dart';
import 'package:parking_booking_system/screens/Driver/ReservationManagement.dart';
import 'SubmitFeedback.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = '';
  String _userInitials = '';
  List<ParkingLocation> _parkingSlots = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchParkingSlots();
  }

  void _fetchUserData() async {
    final userBox = await Hive.openBox<User>('userBox');
    if (userBox.isNotEmpty) {
      User? user = userBox.getAt(0);
      if (user != null) {
        setState(() {
          _userName = user.fullName;
          _userInitials = _getInitials(user.fullName);
        });
      }
    }
  }

  void _fetchParkingSlots() async {
    final parkingBox = await Hive.openBox<ParkingLocation>('parking_slots');
    setState(() {
      _parkingSlots = parkingBox.values.toList();
    });
  }

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
                _userInitials,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildParkingGrid(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF7671FA),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName.isNotEmpty ? _userName : 'User',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _userInitials.isNotEmpty ? _userInitials : 'U',
                    style: TextStyle(
                      color: Color(0xFF7671FA),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
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
              // Add navigation for Payment History
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Add navigation for Profile Page
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Submit Feedback'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriversSubmitFeedbackPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Add navigation for Notifications Page
            },
          ),
        ],
      ),
    );
  }

  // Build grid view of parking slots using the same structure as ParkingSlotsPage
  Widget _buildParkingGrid() {
    int totalSlots = _parkingSlots.length;
    int bookedSlots = _parkingSlots.where((slot) => slot.status == 'Occupied').length;
    int availableSlots = totalSlots - bookedSlots;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Display total available and booked slots
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Total Available: $availableSlots',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total Booked: $bookedSlots',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _parkingSlots.length,
            itemBuilder: (context, index) {
              final parkingSlot = _parkingSlots[index];
              return GestureDetector(
                onTap: () {
                  if (parkingSlot.status != 'Occupied') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsPage(
                          parkingSpotName: parkingSlot.name,
                          bookingDate: "Select Date",
                          bookingTime: "Select Time",
                          parkingSpaceType: parkingSlot.status,
                          price: parkingSlot.price,
                          pricePerHour: parkingSlot.price,
                        ),
                      ),
                    );
                  } else {
                    _showSlotOccupiedMessage();
                  }
                },
                child: ParkingSlotWidget(parkingSlot: parkingSlot),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSlotOccupiedMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Slot Unavailable'),
        content: const Text('This slot is already booked. Please choose another slot.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Reusable widget to display individual parking slot details
class ParkingSlotWidget extends StatelessWidget {
  final ParkingLocation parkingSlot;

  const ParkingSlotWidget({Key? key, required this.parkingSlot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOccupied = parkingSlot.status == 'Occupied';

    return Card(
      color: isOccupied ? Colors.red : Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isOccupied)
              const Text(
                'Occupied',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            else
              const Icon(Icons.directions_car, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              parkingSlot.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
