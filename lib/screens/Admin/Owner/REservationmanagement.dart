import 'package:flutter/material.dart';

class ReservationManagementPage extends StatefulWidget {
  @override
  _ReservationManagementPageState createState() => _ReservationManagementPageState();
}

class _ReservationManagementPageState extends State<ReservationManagementPage> {
  List<Map<String, dynamic>> _reservations = [];
  List<Map<String, dynamic>> _filteredReservations = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialReservations();
  }

  // Load initial mock reservations
  void _loadInitialReservations() {
    _reservations = [
      {'id': '1', 'user': 'John Doe', 'location': 'Location A', 'date': '2024-10-07', 'time': '10:00 AM'},
      {'id': '2', 'user': 'Jane Smith', 'location': 'Location B', 'date': '2024-10-08', 'time': '11:00 AM'},
      // Add more mock reservations as needed
    ];
    _filteredReservations = _reservations; // Initialize filtered list with all reservations
  }

  // Filter reservations by user or location
  void _filterReservations(String query) {
    setState(() {
      _filteredReservations = _reservations.where((reservation) {
        return reservation['user'].toLowerCase().contains(query.toLowerCase()) ||
               reservation['location'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // Show a dialog to modify reservation
  void _showModifyReservationDialog(Map<String, dynamic> reservation) {
    TextEditingController dateController = TextEditingController(text: reservation['date']);
    TextEditingController timeController = TextEditingController(text: reservation['time']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modify Reservation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: "Date"),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: "Time"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _modifyReservation(reservation['id'], dateController.text, timeController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Modify reservation locally
  void _modifyReservation(String id, String newDate, String newTime) {
    setState(() {
      final index = _reservations.indexWhere((reservation) => reservation['id'] == id);
      if (index != -1) {
        _reservations[index]['date'] = newDate;
        _reservations[index]['time'] = newTime;
      }
    });
  }

  // Cancel reservation locally
  void _cancelReservation(String id) {
    setState(() {
      _reservations.removeWhere((reservation) => reservation['id'] == id);
      _filterReservations(_searchController.text); // Update filtered list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation Management"),
      ),
      body: Column(
        children: [
          // Search bar for filtering reservations
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by user or location",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) => _filterReservations(value),
            ),
          ),

          // List of user reservations
          Expanded(
            child: ListView.builder(
              itemCount: _filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = _filteredReservations[index];
                return Card(
                  child: ListTile(
                    title: Text("User: ${reservation['user']}"),
                    subtitle: Text(
                        "Location: ${reservation['location']}\nDate: ${reservation['date']}, Time: ${reservation['time']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showModifyReservationDialog(reservation),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _cancelReservation(reservation['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
