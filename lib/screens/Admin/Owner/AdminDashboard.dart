// AdminDashboardPage.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parking_booking_system/screens/Admin/Owner/FeedbackReview.dart';
import 'package:parking_booking_system/screens/Admin/Owner/Parkingslot.dart';
import 'package:parking_booking_system/screens/Admin/Owner/PaymentReport.dart';
import 'package:parking_booking_system/screens/Auth/Driverlogin.dart';


class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _userName = '';
  String _greeting = '';
  String _initials = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  // Initialize dashboard by fetching user data and setting greeting
  Future<void> _initializeDashboard() async {
    await _fetchUserName();
    _setGreeting();
    setState(() {
      _isLoading = false;
    });
  }

  // Fetch the user's name from Firebase Realtime Database
  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference dbRef =
            FirebaseDatabase.instance.ref().child('users').child(user.uid);
        DatabaseEvent event = await dbRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<dynamic, dynamic> userData =
              snapshot.value as Map<dynamic, dynamic>;
          String name = userData['name'] ?? 'User'; // Default to 'User' if name not found

          setState(() {
            _userName = name;
            _initials = _getInitials(name);
          });
        } else {
          setState(() {
            _userName = 'User';
            _initials = 'U';
          });
          _showSnackBar("User data not found in the database.");
        }
      } else {
        _showSnackBar("No authenticated user found.");
        // Redirect to login page
        _redirectToLogin();
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _showSnackBar("An error occurred while fetching user data.");
      // Optionally, redirect to login or show an error screen
    }
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

  // Extract initials from the user's name
  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (var part in names) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
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
              _userName,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            accountEmail: null, // You can add email if needed
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _initials,
                style: TextStyle(
                  color: Color(0xFF7671FA),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
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
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              // Navigate to login page
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

  // Show a SnackBar with a message
  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  // Redirect to the login page
  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UnifiedLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to Scaffold
      backgroundColor: Color(0xFFE5EAF3), // Page background color
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA), // AppBar background color
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
                _initials,
                style: TextStyle(
                  color: Color(0xFF7671FA),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // Remove the default back arrow
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(), // Add the navigation drawer
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7671FA)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview of Current Reservations
                    _buildSectionTitle("Overview of Current Reservations"),
                    _buildInfoCard("Active Reservations", "10"),
                    _buildInfoCard("Upcoming Reservations", "5"),

                    SizedBox(height: 20),

                    // Revenue Overview
                    _buildSectionTitle("Revenue Overview"),
                    _buildInfoCard("Today's Revenue", "Ksh.150"),
                    _buildInfoCard("Weekly Revenue", "Ksh.1050"),
                    _buildInfoCard("Monthly Revenue", "Ksh.4500"),

                    SizedBox(height: 20),

                    // Parking Slot Utilization
                    _buildSectionTitle("Parking Slot Utilization"),
                    _buildInfoCard("Total Slots", "50"),
                    _buildInfoCard("Occupied Slots", "35"),
                    _buildInfoCard("Available Slots", "15"),

                    SizedBox(height: 20),

                    // Quick Links Section (Buttons arranged in 2x2 grid)
                    _buildSectionTitle("Quick Links"),
                    _buildQuickLinksGrid(context),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Color(0xFF07244C), // Text color
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper method to build info cards
  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF7E7F9C), // Card background color
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF07244C), // Text color
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF07244C), // Text color
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build Quick Action buttons in a grid layout with reduced size
  Widget _buildQuickLinksGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2, // 2 columns
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.0, // Adjust aspect ratio to make buttons smaller
      children: [
        _buildActionButton(context, "Manage Parking Slots", () {
          // Navigate to Parking Slot Management Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ParkingSlotManagementPage()),
          );
        }),
        _buildActionButton(context, "View Feedback", () {
          // Action to View Feedback
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedbackReviewPage()),
          );
        }),
        _buildActionButton(context, "User Management", () {
          // Action to Manage Users
          // Implement navigation or functionality here
        }),
        _buildActionButton(context, "Payment Report", () {
          // Action to View Payment Report
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentReportsPage()),
          );
        }),
      ],
    );
  }

  // Helper method to build action buttons with consistent styling
  Widget _buildActionButton(BuildContext context, String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF07244C), // Button background color
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Adjusted padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14, // Font size
          color: Color(0xFF7E7F9C), // Button text color
        ),
      ),
    );
  }
}
