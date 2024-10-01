import 'package:flutter/material.dart';

class ParkingSlotManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parking Slot Management"),
        centerTitle: true,
        backgroundColor: Color(0xFF7671FA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of Parking Locations
            Expanded(
              child: ListView.builder(
                itemCount: parkingLocations.length,
                itemBuilder: (context, index) {
                  return _buildParkingLocationCard(parkingLocations[index], context);
                },
              ),
            ),
            SizedBox(height: 20),

            // Add/Edit Slots Button
            ElevatedButton(
              onPressed: () {
                // Action to add or edit slots
                _showAddEditSlotDialog(context);
              },
              child: Text("Add/Edit Slots"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF07244C),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock data for parking locations
  final List<ParkingLocation> parkingLocations = [
    ParkingLocation(name: "Downtown Parking", address: "123 Main St", status: "available"),
    ParkingLocation(name: "Airport Parking", address: "456 Airport Rd", status: "occupied"),
    ParkingLocation(name: "Mall Parking", address: "789 Shopping Ave", status: "reserved"),
  ];

  // Method to build each parking location card
  Widget _buildParkingLocationCard(ParkingLocation location, BuildContext context) {
    Color statusColor;
    switch (location.status) {
      case "available":
        statusColor = Colors.green;
        break;
      case "occupied":
        statusColor = Colors.red;
        break;
      case "reserved":
        statusColor = Colors.yellow;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(location.name),
        subtitle: Text(location.address),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {
          // Action to edit parking details
          _showEditDetailsDialog(location, context);
        },
      ),
    );
  }

  // Show dialog for adding or editing slots
  void _showAddEditSlotDialog(BuildContext context) {
    final TextEditingController slotNumberController = TextEditingController();
    final TextEditingController sizeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add/Edit Parking Slots"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: slotNumberController,
                  decoration: InputDecoration(labelText: "Slot Number"),
                ),
                TextField(
                  controller: sizeController,
                  decoration: InputDecoration(labelText: "Size (Compact/Standard/Oversized)"),
                ),
                // Add more fields as necessary
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement save logic
                // For now, just close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Show dialog for editing parking details
  void _showEditDetailsDialog(ParkingLocation location, BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: location.name);
    final TextEditingController addressController = TextEditingController(text: location.address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Parking Details"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                // Add more fields as necessary
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement update logic
                // For now, just close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

// Model class for Parking Location
class ParkingLocation {
  final String name;
  final String address;
  final String status;

  ParkingLocation({required this.name, required this.address, required this.status});
}
