import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/user.dart';
import 'package:parking_booking_system/models/parking_location.dart'; // Assuming ParkingLocation is the slot model
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

  int activeReservations = 0;
  int upcomingReservations = 0;
  double todayRevenue = 0.0;
  double weeklyRevenue = 0.0;
  double monthlyRevenue = 0.0;
  int totalSlots = 0;
  int occupiedSlots = 0;
  int availableSlots = 0;
  List<ParkingLocation> parkingSlots = [];

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _fetchUserData();
    _fetchDashboardData();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      _greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      _greeting = 'Good Afternoon';
    } else {
      _greeting = 'Good Evening';
    }
  }

  void _fetchUserData() async {
    final userBox = await Hive.openBox<User>('userBox');
    if (userBox.isNotEmpty) {
      User? user = userBox.getAt(0);
      setState(() {
        _userName = user!.fullName;
        _initials = _getInitials(user.fullName);
      });
    }
  }

  void _fetchDashboardData() async {
    final reservationsBox = await Hive.openBox('reservations');
    final revenueBox = await Hive.openBox('revenue');
    final slotsBox = await Hive.openBox<ParkingLocation>('parking_slots');

    setState(() {
      activeReservations = reservationsBox.get('active', defaultValue: 0);
      upcomingReservations = reservationsBox.get('upcoming', defaultValue: 0);
      todayRevenue = revenueBox.get('today', defaultValue: 0.0);
      weeklyRevenue = revenueBox.get('weekly', defaultValue: 0.0);
      monthlyRevenue = revenueBox.get('monthly', defaultValue: 0.0);
      parkingSlots = slotsBox.values.toList();
      totalSlots = parkingSlots.length;
      occupiedSlots = parkingSlots.where((slot) => slot.status == 'Occupied').length;
      availableSlots = totalSlots - occupiedSlots;
    });
  }

  String _getInitials(String fullName) {
    return fullName.split(' ').map((name) => name[0].toUpperCase()).join();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF7671FA)),
            accountName: Text(
              _userName.isNotEmpty ? _userName : 'Admin',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _initials.isNotEmpty ? _initials : 'A',
                style: TextStyle(color: Color(0xFF7671FA), fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
           
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback Review'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackReviewPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_parking),
            title: Text('Manage Parking Slots'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingSlotManagementPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment Reports'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentReportsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UnifiedLoginPage()));
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _initials.isNotEmpty ? _initials : 'A',
                style: TextStyle(color: Color(0xFF7671FA), fontWeight: FontWeight.bold),
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
              _buildParkingSlotSummary(),
              SizedBox(height: 10),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Color(0xFF07244C), fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Color(0xFF07244C)),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF07244C)),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingSlotSummary() {
    return Column(
      children: [
        _buildInfoCard("Total Slots", "$totalSlots"),
        _buildInfoCard("Occupied Slots", "$occupiedSlots"),
        _buildInfoCard("Available Slots", "$availableSlots"),
      ],
    );
  }

  
}
