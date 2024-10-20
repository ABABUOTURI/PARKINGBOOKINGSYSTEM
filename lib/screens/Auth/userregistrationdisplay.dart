import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserRegistrationDisplay extends StatefulWidget {
  @override
  _UserRegistrationDisplayState createState() => _UserRegistrationDisplayState();
}

class _UserRegistrationDisplayState extends State<UserRegistrationDisplay> {
  Box<dynamic>? userBox;

  @override
  void initState() {
    super.initState();
    openUserBox();
  }

  void openUserBox() async {
    userBox = await Hive.openBox('users'); // Open the Hive box for users
    setState(() {}); // Refresh the UI after opening the box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registered Users"),
      ),
      body: userBox == null
          ? Center(child: CircularProgressIndicator())
          : userBox!.isEmpty
              ? Center(child: Text("No users registered."))
              : ListView.builder(
                  itemCount: userBox!.length,
                  itemBuilder: (context, index) {
                    var user = userBox!.getAt(index);
                    return ListTile(
                      title: Text(user['role']), // Display user role
                      subtitle: Text(
                        user['role'] == 'Driver'
                            ? "Phone: ${user['phone']}" // Display phone for Driver
                            : "Email: ${user['email']}", // Display email for Owner/Admin
                      ),
                    );
                  },
                ),
    );
  }
}


