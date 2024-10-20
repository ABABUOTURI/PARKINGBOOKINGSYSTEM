import 'package:flutter/material.dart';

class ParkingAvailabilityControlPage extends StatefulWidget {
  @override
  _ParkingAvailabilityControlPageState createState() =>
      _ParkingAvailabilityControlPageState();
}

class _ParkingAvailabilityControlPageState
    extends State<ParkingAvailabilityControlPage> {
  Map<String, int> _parkingLocations = {};
  TextEditingController _slotsController = TextEditingController();
  String _selectedLocation = "";

  // Add or Edit Parking Slots
  void _addOrEditSlots(String location, int newSlots) {
    setState(() {
      _parkingLocations[location] = newSlots;
    });
  }

  // UI for Add/Edit Dialog
  void _showAddEditDialog({String? location, int? currentSlots}) {
    _slotsController.text = currentSlots != null ? currentSlots.toString() : "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(location != null ? "Edit Slots" : "Add Location"),
          content: TextField(
            controller: _slotsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter slot count"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newSlots = int.tryParse(_slotsController.text);
                if (newSlots != null) {
                  if (location != null) {
                    // Edit existing location
                    _addOrEditSlots(location, newSlots);
                  } else {
                    // Add new location
                    _addOrEditSlots(_selectedLocation, newSlots);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"),
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
        title: Text("Parking Availability Control"),
      ),
      body: Column(
        children: [
          // Dropdown for selecting location
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedLocation.isNotEmpty ? _selectedLocation : null,
              hint: Text("Select Parking Location"),
              items: _parkingLocations.keys.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (String? newLocation) {
                setState(() {
                  _selectedLocation = newLocation!;
                });
              },
            ),
          ),

          // List of parking locations and slots
          Expanded(
            child: ListView.builder(
              itemCount: _parkingLocations.length,
              itemBuilder: (context, index) {
                String location =
                    _parkingLocations.keys.elementAt(index).toString();
                int slots = _parkingLocations[location] ?? 0;
                return ListTile(
                  title: Text(location),
                  subtitle: Text("Slots Available: $slots"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Show edit dialog
                      _showAddEditDialog(location: location, currentSlots: slots);
                    },
                  ),
                );
              },
            ),
          ),

          // Button to add new location and slots
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddEditDialog();
              },
              icon: Icon(Icons.add),
              label: Text("Add New Parking Location"),
            ),
          ),
        ],
      ),
    );
  }
}
