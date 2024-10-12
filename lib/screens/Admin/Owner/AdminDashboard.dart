import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/user.dart'; // Ensure you have the User model defined
import 'package:parking_booking_system/screens/Admin/Owner/FeedbackReview.dart';
import 'package:parking_booking_system/screens/Admin/Owner/Parkingslot.dart';
import 'package:parking_booking_system/screens/Admin/Owner/PaymentReport.dart';
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _userName = ''; // To hold the user's name
  String _greeting = '';
  String _initials = ''; // To hold the user's initials
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  // Placeholder data
  int activeReservations = 0; // Active reservations count
  int upcomingReservations = 0; // Upcoming reservations count
  double todayRevenue = 0.0; // Today's revenue
  double weeklyRevenue = 0.0; // Weekly revenue
  double monthlyRevenue = 0.0; // Monthly revenue
  int totalSlots = 0; // Total parking slots
  int occupiedSlots = 0; // Occupied slots
  int availableSlots = 0; // Available slots

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _fetchUserData(); // Fetch user data on initialization
    _fetchDashboardData(); // Fetch dashboard data
  }

  // Determine the greeting based on the current time
  void _setGreeting() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour >= 5 && hour < 12) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    setState(() {
      _greeting = greeting;
    });
  }

  // Fetch user data from Hive
  void _fetchUserData() async {
    final userBox = await Hive.openBox<User>('userBox'); // Open the box to retrieve user data
    if (userBox.isNotEmpty) {
      User? user = userBox.getAt(0); // Get the first user (assuming single admin)
      setState(() {
        _userName = user!.fullName; // Set the user's full name
        _initials = _getInitials(user.fullName); // Set initials based on full name
      });
    }
  }

  // Fetch dashboard data
  void _fetchDashboardData() async {
    // Simulated data fetch, replace this with actual fetching from your data store
    // Example: Fetch reservations, revenue, and parking slot data from Hive or your backend

    // Placeholder data for demonstration
    setState(() {
      activeReservations = 0; // Fetch active reservations count
      upcomingReservations = 0; // Fetch upcoming reservations count
      todayRevenue = 0.0; // Fetch today's revenue
      weeklyRevenue = 0.0; // Fetch weekly revenue
      monthlyRevenue = 0.0; // Fetch monthly revenue
      totalSlots = 50; // Fetch total parking slots
      occupiedSlots = 35; // Fetch occupied slots
      availableSlots = totalSlots - occupiedSlots; // Calculate available slots
    });
  }

  // Method to get initials from the full name
  String _getInitials(String fullName) {
    List<String> names = fullName.split(' ');
    String initials = '';
    for (String name in names) {
      if (name.isNotEmpty) {
        initials += name[0].toUpperCase(); // Get the first character and capitalize
      }
    }
    return initials;
  }

  // Implement a Navigation Drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Customized DrawerHeader to include user's name and initials
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF7671FA),
            ),
            accountName: Text(
              _userName.isNotEmpty ? _userName : 'Admin', // Default name
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _initials.isNotEmpty ? _initials : 'A', // Default initials
                style: TextStyle(
                  color: Color(0xFF7671FA),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
           ListTile(
          leading: Icon(Icons.people), // Updated to user management icon
          title: Text('User Management'),
          //onTap: () {
            //Navigator.pop(context); // Close the drawer
            //Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => UserManagementPage()), // Ensure you have UserManagementPage created
            //);
          //},
        ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback Review'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackReviewPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_parking),
            title: Text('Manage Parking Slots'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParkingSlotManagementPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment Reports'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentReportsPage()),
              );
            },
          ),
          Divider(), // A divider before logout
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Logout action if needed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UnifiedLoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '$_greeting $_userName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _initials.isNotEmpty ? _initials : 'A', // Default initials
                style: TextStyle(
                  color: Color(0xFF7671FA),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Overview of Current Reservations"),
              _buildInfoCard("Active Reservations", activeReservations > 0 ? "$activeReservations" : "No Reservations"),
              _buildInfoCard("Upcoming Reservations", upcomingReservations > 0 ? "$upcomingReservations" : "No Reservations"),
              SizedBox(height: 20),
              _buildSectionTitle("Revenue Overview"),
              _buildInfoCard("Today's Revenue", todayRevenue > 0 ? "Ksh.$todayRevenue" : "No Revenue"),
              _buildInfoCard("Weekly Revenue", weeklyRevenue > 0 ? "Ksh.$weeklyRevenue" : "No Revenue"),
              _buildInfoCard("Monthly Revenue", monthlyRevenue > 0 ? "Ksh.$monthlyRevenue" : "No Revenue"),
              SizedBox(height: 20),
              _buildSectionTitle("Parking Slot Utilization"),
              _buildInfoCard("Total Slots", totalSlots > 0 ? "$totalSlots" : "No Slots"),
              _buildInfoCard("Occupied Slots", occupiedSlots > 0 ? "$occupiedSlots" : "No Slots"),
              _buildInfoCard("Available Slots", availableSlots > 0 ? "$availableSlots" : "No Slots"),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Color(0xFF07244C),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF7E7F9C),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF07244C),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF07244C),
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildActionButton(BuildContext context, String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF07244C),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF7E7F9C),
        ),
      ),
    );
  }
}
