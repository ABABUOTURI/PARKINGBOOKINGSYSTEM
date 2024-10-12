import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/parking_location.dart'; // Import the ParkingLocation model

class ParkingSlotManagementPage extends StatefulWidget {
  @override
  _ParkingSlotManagementPageState createState() => _ParkingSlotManagementPageState();
}

class _ParkingSlotManagementPageState extends State<ParkingSlotManagementPage> {
  List<ParkingLocation> _parkingLocations = []; // List to hold parking slots

  @override
  void initState() {
    super.initState();
    _loadInitialParkingSlots(); // Load parking slots when the page initializes
  }

  // Load parking slots from Hive
  void _loadInitialParkingSlots() async {
    final box = await Hive.openBox<ParkingLocation>('parking_slots'); // Open the box
    setState(() {
      _parkingLocations = box.values.toList(); // Load parking slots from Hive
    });
  }

  // Add a parking slot
  void _addParkingSlot(String name, String address, String status, double price, double latitude, double longitude) async {
    final box = await Hive.openBox<ParkingLocation>('parking_slots'); // Open the box
    ParkingLocation newSlot = ParkingLocation(
      id: DateTime.now().toString(), // Unique ID using timestamp
      name: name,
      address: address,
      status: status,
      price: price,
      latitude: latitude,
      longitude: longitude,
    );

    await box.add(newSlot); // Add to Hive storage
    setState(() {
      _parkingLocations.add(newSlot); // Update local list
    });
    _showSnackBar("Parking slot added successfully.");
  }

  // Update an existing parking slot
  void _updateParkingSlot(String id, String name, String address, String status, double price, double latitude, double longitude) async {
    final box = await Hive.openBox<ParkingLocation>('parking_slots'); // Open the box
    int index = _parkingLocations.indexWhere((slot) => slot.id == id);
    if (index != -1) {
      ParkingLocation updatedSlot = ParkingLocation(
        id: id,
        name: name,
        address: address,
        status: status,
        price: price,
        latitude: latitude,
        longitude: longitude,
      );
      await box.putAt(index, updatedSlot); // Update Hive storage
      setState(() {
        _parkingLocations[index] = updatedSlot; // Update local list
      });
      _showSnackBar("Parking slot updated successfully.");
    }
  }

  // Delete a parking slot
  void _deleteParkingSlot(String id) async {
    final box = await Hive.openBox<ParkingLocation>('parking_slots'); // Open the box
    int index = _parkingLocations.indexWhere((slot) => slot.id == id);
    if (index != -1) {
      await box.deleteAt(index); // Remove from Hive storage
      setState(() {
        _parkingLocations.removeAt(index); // Update local list
      });
      _showSnackBar("Parking slot deleted successfully.");
    }
  }

  // Show SnackBar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Show dialog to add a new parking slot
  void _showAddSlotDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();
    String selectedStatus = 'available';

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
                TextField(
                  controller: latitudeController,
                  decoration: InputDecoration(labelText: "Latitude"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: longitudeController,
                  decoration: InputDecoration(labelText: "Longitude"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: <String>['available', 'occupied', 'reserved'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value[0].toUpperCase() + value.substring(1)),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: "Status"),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedStatus = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    addressController.text.trim().isEmpty ||
                    priceController.text.trim().isEmpty ||
                    latitudeController.text.trim().isEmpty ||
                    longitudeController.text.trim().isEmpty) {
                  _showSnackBar("Please fill all fields.");
                  return;
                }
                _addParkingSlot(
                  nameController.text.trim(),
                  addressController.text.trim(),
                  selectedStatus,
                  double.parse(priceController.text.trim()), // Parse price to double
                  double.parse(latitudeController.text.trim()), // Parse latitude to double
                  double.parse(longitudeController.text.trim()), // Parse longitude to double
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

  // Show dialog to edit an existing parking slot
  void _showEditSlotDialog(ParkingLocation slot) {
    final TextEditingController nameController = TextEditingController(text: slot.name);
    final TextEditingController addressController = TextEditingController(text: slot.address);
    final TextEditingController priceController = TextEditingController(text: slot.price.toString());
    final TextEditingController latitudeController = TextEditingController(text: slot.latitude.toString());
    final TextEditingController longitudeController = TextEditingController(text: slot.longitude.toString());
    String selectedStatus = slot.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Parking Slot"),
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
                TextField(
                  controller: latitudeController,
                  decoration: InputDecoration(labelText: "Latitude"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: longitudeController,
                  decoration: InputDecoration(labelText: "Longitude"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: <String>['available', 'occupied', 'reserved'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value[0].toUpperCase() + value.substring(1)),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: "Status"),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedStatus = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    addressController.text.trim().isEmpty ||
                    priceController.text.trim().isEmpty ||
                    latitudeController.text.trim().isEmpty ||
                    longitudeController.text.trim().isEmpty) {
                  _showSnackBar("Please fill all fields.");
                  return;
                }
                _updateParkingSlot(
                  slot.id,
                  nameController.text.trim(),
                  addressController.text.trim(),
                  selectedStatus,
                  double.parse(priceController.text.trim()), // Parse price to double
                  double.parse(latitudeController.text.trim()), // Parse latitude to double
                  double.parse(longitudeController.text.trim()), // Parse longitude to double
                );
                Navigator.of(context).pop();
              },
              child: Text("Update"),
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

  // Method to build each parking location card
  Widget _buildParkingLocationCard(ParkingLocation location) {
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Indicator
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10),
            // Edit Button
            IconButton(
              icon: Icon(Icons.edit, color: Color(0xFF7671FA)),
              onPressed: () {
                _showEditSlotDialog(location);
              },
            ),
            // Delete Button
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDelete(slot: location);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Confirm deletion of a parking slot
  void _confirmDelete({required ParkingLocation slot}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Parking Slot"),
          content: Text("Are you sure you want to delete '${slot.name}'?"),
          actions: [
            TextButton(
              onPressed: () {
                _deleteParkingSlot(slot.id);
                Navigator.of(context).pop();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA), // AppBar color
        title: Text("Parking Slot Management"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddSlotDialog,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _parkingLocations.length,
                itemBuilder: (context, index) {
                  return _buildParkingLocationCard(_parkingLocations[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
