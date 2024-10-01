import 'package:flutter/material.dart';
import 'package:parking_booking_system/screens/Driver/PaymentConfirmation.dart';

// Booking Details Page
class BookingDetailsPage extends StatelessWidget {
  final String parkingSpotName;
  final String bookingDate;
  final String bookingTime;
  final String parkingSpaceType;
  final double price;

  BookingDetailsPage({
    required this.parkingSpotName,
    required this.bookingDate,
    required this.bookingTime,
    required this.parkingSpaceType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text("Booking Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking Spot Location Name
            _buildDetailItem("Parking Spot Location", parkingSpotName),
            SizedBox(height: 16),

            // Date and Time of Booking
            _buildDetailItem("Date & Time", "$bookingDate | $bookingTime"),
            SizedBox(height: 16),

            // Parking Space Type
            _buildDetailItem("Parking Space Type", parkingSpaceType),
            SizedBox(height: 16),

            // Price Calculation
            _buildPriceSection(),
            Spacer(), // Push Confirm Button to the bottom

            // Confirm Booking Button
            _buildConfirmButton(context),
          ],
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
      ],
    );
  }

  // Helper to build the price section
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price Calculation",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF07244C),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Price per Hour",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Price",
              style: TextStyle(fontSize: 16, color: Color(0xFF07244C)),
            ),
            Text(
              "\$${(price * 2).toStringAsFixed(2)}", // Assume 2 hours
              style: TextStyle(fontSize: 16, color: Color(0xFF07244C)),
            ),
          ],
        ),
      ],
    );
  }

  // Helper to build the Confirm Booking button
  Widget _buildConfirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the Payment Options Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOptionsPage(
                parkingSpotName: parkingSpotName,
                totalPrice: price * 2, // Assuming 2 hours for total price
              ),
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
          "Confirm Booking",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Payment Options Page
class PaymentOptionsPage extends StatelessWidget {
  final String parkingSpotName;
  final double totalPrice;

  PaymentOptionsPage({
    required this.parkingSpotName,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EAF3),
      appBar: AppBar(
        backgroundColor: Color(0xFF7671FA),
        title: Text("Payment Options"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPaymentMethod("Mobile Payment"),
            SizedBox(height: 20),
            _buildPhoneNumberField(),
            SizedBox(height: 20),
            _buildReviewDetails(),
            Spacer(),
            _buildSubmitPaymentButton(context),
          ],
        ),
      ),
    );
  }

  // Helper to build payment method options
  Widget _buildPaymentMethod(String method) {
    return RadioListTile(
      title: Text(method),
      value: method,
      groupValue: "paymentMethod", // Change this to a state variable if needed
      onChanged: (value) {
        // Handle payment method selection
      },
    );
  }

  // Helper to build phone number input field
  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter your phone number",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  // Helper to build review payment details section
  Widget _buildReviewDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Review Payment Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("Parking Spot: $parkingSpotName"),
        Text("Total Price: \$${totalPrice.toStringAsFixed(2)}"),
      ],
    );
  }

  // Helper to build the Submit Payment button
  Widget _buildSubmitPaymentButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Assuming payment logic here (e.g., API call or payment gateway)

          // After successful payment, navigate to PaymentConfirmationPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentConfirmationPage(
                transactionId: "TXN123456",  // Pass the real transaction ID
                bookingId: "BOOK123456",      // Pass the real booking ID
                totalPrice: totalPrice,       // Pass the total price from payment
                parkingSpotName: parkingSpotName,  // Pass parking spot name
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF07244C),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          "Submit Payment",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

