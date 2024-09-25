import 'package:flutter/material.dart';

// Payment Confirmation Page
class PaymentConfirmationPage extends StatelessWidget {
  final String transactionId;
  final String bookingId;
  final double totalPrice;
  final String parkingSpotName;

  PaymentConfirmationPage({
    required this.transactionId,
    required this.bookingId,
    required this.totalPrice,
    required this.parkingSpotName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text("Payment Confirmation"),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Confirmation message
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 70,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Payment Successful!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF07244C),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Transaction and Booking ID
              _buildDetailItem("Transaction ID", transactionId),
              _buildDetailItem("Booking ID", bookingId),
              SizedBox(height: 16),

              // Booking Summary
              _buildDetailItem("Parking Spot", parkingSpotName),
              _buildDetailItem("Total Price", "\$${totalPrice.toStringAsFixed(2)}"),
              SizedBox(height: 16),

              // Spacer to push buttons to the bottom
              SizedBox(height: 20), // Adjust height for better spacing

              // Download Receipt Button
              _buildDownloadReceiptButton(context),

              // SizedBox for spacing
              SizedBox(height: 20), // Adjust the height as needed

              // Booking Summary Button
              _buildBookingSummaryButton(context),
              SizedBox(height: 40), // Additional space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build detail items
  Widget _buildDetailItem(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF07244C),
          ),
        ),
        SizedBox(height: 8),
        Text(
          detail,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Download Receipt Button
  Widget _buildDownloadReceiptButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Implement receipt download functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Receipt downloaded!')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF07244C), // Button background color
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Download Receipt",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Booking Summary Button
  Widget _buildBookingSummaryButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the booking summary page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingSummaryPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF07244C), // Button background color
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "View All Bookings Summary",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Dummy BookingSummaryPage class to complete the navigation flow
class BookingSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text("All Bookings Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking Summary Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Add a list or table here to show all bookings and payments
            // For demonstration, we can add some placeholder text
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Booking ID: 12345"),
                    subtitle: Text("Parking Spot: Downtown Lot\nTotal Price: \$20.00"),
                  ),
                  ListTile(
                    title: Text("Booking ID: 67890"),
                    subtitle: Text("Parking Spot: City Center\nTotal Price: \$15.00"),
                  ),
                  // Add more booking summary items as needed
                ],
              ),
            ),
          ElevatedButton(
  onPressed: () {
    // Navigate back to the payment confirmation page
    Navigator.pop(context);
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF07244C), // Set your desired background color
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // Rounded corners
    ),
  ),
  child: Text(
    "Go Back",
    style: TextStyle(
      color: Colors.white, // Text color
    ),
  ),
)

          ],
        ),
      ),
    );
  }
}
