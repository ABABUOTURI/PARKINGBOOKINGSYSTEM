import 'package:flutter/material.dart';

class PaymentReportsPage extends StatefulWidget {
  @override
  _PaymentReportsPageState createState() => _PaymentReportsPageState();
}

class _PaymentReportsPageState extends State<PaymentReportsPage> {
  String selectedReportType = "Daily"; // Default report type
  List<Map<String, dynamic>> filteredTransactionDetails = []; // To hold filtered transactions

  // Sample data for transaction details
  final List<Map<String, dynamic>> transactionDetails = [
    {
      'id': 'TX12345',
      'date': '2024-09-25 14:30',
      'amount': 150,
      'method': 'Credit Card',
    },
    {
      'id': 'TX12346',
      'date': '2024-09-25 15:00',
      'amount': 200,
      'method': 'Mobile Payment',
    },
    {
      'id': 'TX12347',
      'date': '2024-09-26 10:15',
      'amount': 250,
      'method': 'Debit Card',
    },
    // Add more mock data as needed
  ];

  @override
  void initState() {
    super.initState();
    _filterTransactions(); // Initial filter to show daily reports
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Reports"),
        centerTitle: true,
        backgroundColor: Color(0xFF7671FA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily/Weekly/Monthly Reports Section
            _buildReportSelection(),
            SizedBox(height: 20),

            // Container to hold Transaction Details
            _buildTransactionDetailsContainer(),
            SizedBox(height: 20),

            // Export Report Button
            _buildExportReportButton(context),
          ],
        ),
      ),
    );
  }

  // Method to build the report selection (Daily/Weekly/Monthly)
  Widget _buildReportSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Report Type:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildReportButton("Daily"),
            _buildReportButton("Weekly"),
            _buildReportButton("Monthly"),
          ],
        ),
      ],
    );
  }

  // Helper method to create report buttons
  Widget _buildReportButton(String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedReportType = title;
          _filterTransactions(); // Filter transactions based on selection
        });
      },
      child: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF07244C), // Button background color
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }

  // Method to filter transaction details based on selected report type
  void _filterTransactions() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedReportType) {
      case "Daily":
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case "Weekly":
        startDate = now.subtract(Duration(days: 7));
        break;
      case "Monthly":
        // Handle January month correctly
        int lastMonth = now.month == 1 ? 12 : now.month - 1;
        int lastYear = now.month == 1 ? now.year - 1 : now.year;
        startDate = DateTime(lastYear, lastMonth, now.day);
        break;
      default:
        startDate = now; // Fallback
    }

    // Filtering the transactions based on the start date
    filteredTransactionDetails = transactionDetails.where((transaction) {
      DateTime transactionDate = DateTime.parse(transaction['date']);
      return transactionDate.isAfter(startDate) || transactionDate.isAtSameMomentAs(startDate);
    }).toList();
  }

  // Method to build the transaction details display in a container
  Widget _buildTransactionDetailsContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF07244C)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaction Details:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: filteredTransactionDetails.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredTransactionDetails.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactionDetails[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          title: Text("Transaction ID: ${transaction['id']}"),
                          subtitle: Text(
                            "Date: ${transaction['date']}\nAmount: Ksh.${transaction['amount']}\nMethod: ${transaction['method']}",
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text("No transactions available for the selected report type.")),
          ),
        ],
      ),
    );
  }

  // Method to build the export report button
  Widget _buildExportReportButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Action to export the payment report
        _exportPaymentReport();
      },
      child: Text("Export Report"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF07244C),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
      ),
    );
  }

  // Method to export the payment report (implement export logic here)
  void _exportPaymentReport() {
    // Your logic to export the report goes here
    // You can use libraries like csv or pdf to generate the report
    print("Exporting payment report for $selectedReportType...");
  }
}
