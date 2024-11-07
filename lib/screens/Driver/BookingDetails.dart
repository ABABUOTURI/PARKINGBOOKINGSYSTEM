import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/parking_location.dart';
import 'package:parking_booking_system/models/payment.dart';
import 'package:parking_booking_system/screens/Driver/PaymentConfirmation.dart';

class BookingDetailsPage extends StatefulWidget {
  final String parkingSpotName;
  final double pricePerHour;

  BookingDetailsPage({
    required this.parkingSpotName,
    required this.pricePerHour,
    required String bookingDate,
    required double price,
    required String parkingSpaceType,
    required String bookingTime,
  });

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  int _selectedHours = 2;
  double _totalPrice = 0.0;
  String _bookingDate = "";
  String _bookingTime = "";

  @override
  void initState() {
    super.initState();
    _fetchPaymentData();
    _calculateTotalPrice();
  }

  void _fetchPaymentData() async {
    final paymentBox = await Hive.openBox<Payment>('paymentBox');
    if (paymentBox.isNotEmpty) {
      Payment? payment = paymentBox.getAt(0);
      if (payment != null) {
        setState(() {
          _bookingDate = payment.bookingDate;
          _bookingTime = payment.bookingTime;
        });
      }
    }
  }

  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = widget.pricePerHour * _selectedHours;
    });
  }

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
            _buildDetailItem("Parking Spot Location", widget.parkingSpotName),
            SizedBox(height: 16),
            _buildDetailItem("Date & Time", "$_bookingDate | $_bookingTime"),
            SizedBox(height: 16),
            _buildHoursSlider(),
            SizedBox(height: 16),
            _buildPriceSection(),
            Spacer(),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

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

  Widget _buildHoursSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Parking Duration (hours)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF07244C),
          ),
        ),
        Slider(
          value: _selectedHours.toDouble(),
          min: 1,
          max: 24,
          divisions: 23,
          label: "${_selectedHours} hours",
          onChanged: (double value) {
            setState(() {
              _selectedHours = value.toInt();
              _calculateTotalPrice();
            });
          },
        ),
        Text(
          "Selected Duration: $_selectedHours hours",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

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
              "Ksh${widget.pricePerHour.toStringAsFixed(2)}",
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
              "Ksh${_totalPrice.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, color: Color(0xFF07244C)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOptionsPage(
                parkingSpotName: widget.parkingSpotName,
                totalPrice: _totalPrice,
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

  Widget _buildPaymentMethod(String method) {
    return RadioListTile(
      title: Text(method),
      value: method,
      groupValue: "paymentMethod",
      onChanged: (value) {
        // Handle payment method selection
      },
    );
  }

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
        Text("Total Price: Ksh${totalPrice.toStringAsFixed(2)}"),
      ],
    );
  }

  Widget _buildSubmitPaymentButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentConfirmationPage(
                transactionId: "TXN123456",
                bookingId: "BOOK123456",
                totalPrice: totalPrice,
                parkingSpotName: parkingSpotName,
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
