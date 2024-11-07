import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

import '../../../models/user.dart';
import '../../../models/parking_location.dart';

class SystemManagementPage extends StatefulWidget {
  const SystemManagementPage({super.key});

  @override
  _SystemManagementPageState createState() => _SystemManagementPageState();
}

class _SystemManagementPageState extends State<SystemManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        showFloatingButton = _tabController.index == 1;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF63D1F6),
        title: const Text('System Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Parking Locations'),
            Tab(text: 'Settings'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: _backupData,
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _restoreData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserManagementTab(),
          _buildParkingLocationManagementTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: showFloatingButton
          ? FloatingActionButton(
              onPressed: _addParkingLocation,
              backgroundColor: const Color(0xFF63D1F6),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildUserManagementTab() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<User>('users').listenable(),
      builder: (context, Box<User> userBox, _) {
        if (userBox.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: userBox.length,
          itemBuilder: (context, index) {
            User? user = userBox.getAt(index);
            return Card(
              color: const Color(0xFFDEAF4B),
              elevation: 4,
              shadowColor: Colors.grey[400],
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('User: ${user?.name ?? 'N/A'}'),
                subtitle: Text('Role: ${user?.role ?? 'N/A'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Implement Edit User
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await userBox.deleteAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User deleted')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildParkingLocationManagementTab() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ParkingLocation>('parkingLocations').listenable(),
      builder: (context, Box<ParkingLocation> locationBox, _) {
        if (locationBox.isEmpty) {
          return const Center(child: Text("No parking locations available"));
        }

        List<ParkingLocation> locations = locationBox.values.toList();

        return ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            ParkingLocation location = locations[index];
            return Card(
              color: location.status == 'Occupied' ? Colors.green[300] : const Color(0xFFDEAF4B),
              elevation: 4,
              shadowColor: Colors.grey[400],
              child: ListTile(
                leading: const Icon(Icons.local_parking),
                title: Text('Location: ${location.name}'),
                subtitle: Text('Address: ${location.address}\n'
                               'Price: \$${location.price} ${location.pricePerHour != null ? "(per hour)" : ""}\n'
                               'Status: ${location.status}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implement Edit Parking Location
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: const Color(0xFF63D1F6),
            elevation: 4,
            shadowColor: Colors.grey[400],
            child: ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Role-Based Access Control'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Implement Role-Based Access Control Edit
                },
              ),
            ),
          ),
          Card(
            color: const Color(0xFF63D1F6),
            elevation: 4,
            shadowColor: Colors.grey[400],
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Implement Notification Settings Edit
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addParkingLocation() async {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final priceController = TextEditingController();
    final pricePerHourController = TextEditingController();
    final statusController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Parking Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(hintText: 'Enter Location ID'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Enter Location Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(hintText: 'Enter Address'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter Price'),
            ),
            TextField(
              controller: pricePerHourController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter Price per Hour (Optional)'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(hintText: 'Enter Status (e.g., Occupied, Available)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (idController.text.isNotEmpty && nameController.text.isNotEmpty && addressController.text.isNotEmpty && priceController.text.isNotEmpty) {
                var locationBox = Hive.box<ParkingLocation>('parkingLocations');
                
                await locationBox.add(
                  ParkingLocation(
                    id: idController.text.trim(),
                    name: nameController.text.trim(),
                    address: addressController.text.trim(),
                    price: double.tryParse(priceController.text.trim()) ?? 0.0,
                    pricePerHour: double.tryParse(pricePerHourController.text.trim()),
                    status: statusController.text.trim(),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Parking Location Added Successfully')),
                );

                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _backupData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System data backed up successfully!')),
    );
  }

  void _restoreData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System data restored successfully!')),
    );
  }
}
