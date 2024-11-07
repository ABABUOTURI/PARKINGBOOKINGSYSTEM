import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parking_booking_system/models/parking_location.dart';

class ParkingSlotManagementPage extends StatefulWidget {
  @override
  _ParkingSlotManagementPageState createState() => _ParkingSlotManagementPageState();
}

class _ParkingSlotManagementPageState extends State<ParkingSlotManagementPage> {
  late Box<ParkingLocation> parkingBox;

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    parkingBox = await Hive.openBox<ParkingLocation>('parking_slots');
    setState(() {}); // Trigger a rebuild to initialize the box
  }

  void _addParkingSlot(String name, String address, double price) async {
    final newSlot = ParkingLocation(
      id: DateTime.now().toString(),
      name: name,
      address: address,
      status: "Available",  // Default status is "Available"
      price: price,
    );
    await parkingBox.add(newSlot);
    _showSnackBar("Parking slot added successfully.");
  }

  void _toggleSlotStatus(ParkingLocation slot, int index) async {
    final updatedSlot = ParkingLocation(
      id: slot.id,
      name: slot.name,
      address: slot.address,
      price: slot.price,
      status: slot.status == "Available" ? "Occupied" : "Available",
    );
    await parkingBox.putAt(index, updatedSlot); // Update the slot at its index
    _showSnackBar("Parking slot '${slot.name}' status updated.");
  }

  void _showAddSlotDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Parking Slot"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Slot Name"),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Price (Ksh)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    addressController.text.trim().isEmpty ||
                    priceController.text.trim().isEmpty) {
                  _showSnackBar("Please fill all fields.");
                  return;
                }
                _addParkingSlot(
                  nameController.text.trim(),
                  addressController.text.trim(),
                  double.parse(priceController.text.trim()),
                );
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParkingLocationCard(ParkingLocation location, int index) {
    Color cardColor = location.status == "Available" ? Colors.yellow : Colors.green;
    String statusText = location.status == "Available" ? "Available" : "Occupied";

    return Card(
      color: cardColor, // Set the card color based on status
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(location.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location.address),
            Text("Price: Ksh ${location.price.toStringAsFixed(2)}"),
            Text("Status: $statusText"),
          ],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {
          _toggleSlotStatus(location, index); // Toggle status on tap
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text("Parking Slot Management"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: parkingBox.listenable(),
          builder: (context, Box<ParkingLocation> box, _) {
            final parkingLocations = box.values.toList().cast<ParkingLocation>();
            if (parkingLocations.isEmpty) {
              return Center(child: Text("No parking slots available."));
            }
            return ListView.builder(
              itemCount: parkingLocations.length,
              itemBuilder: (context, index) {
                return _buildParkingLocationCard(parkingLocations[index], index);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSlotDialog,
        backgroundColor: Color(0xFF7671FA),
        child: Icon(Icons.add),
      ),
    );
  }
}
