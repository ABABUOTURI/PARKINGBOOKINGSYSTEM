import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parking_booking_system/models/feedback.dart' as customFeedback; // Alias the Feedback model import

class FeedbackReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Review"),
        centerTitle: true,
        backgroundColor: Color(0xFF7671FA),
      ),
      body: FutureBuilder<Box<customFeedback.Feedback>>(
        future: Hive.openBox<customFeedback.Feedback>('feedback'), // Open feedback box
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final feedbackBox = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filter Options
                  _buildFilterOptions(context),
                  SizedBox(height: 10),

                  // List of Submitted Feedback
                  Expanded(
                    child: ListView.builder(
                      itemCount: feedbackBox.length,
                      itemBuilder: (context, index) {
                        // Cast the retrieved value to ensure it's not null
                        customFeedback.Feedback? feedback = feedbackBox.getAt(index);
                        if (feedback != null) {
                          return _buildFeedbackCard(feedback);
                        } else {
                          return Text("No feedback available");
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),

                  // Export Report Button
                  ElevatedButton(
                    onPressed: () {
                      // Action to export feedback report
                      _exportFeedbackReport();
                    },
                    child: Text("Export Feedback Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF07244C),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Build filter options
  Widget _buildFilterOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<int>(
          hint: Text("Filter by Rating"),
          items: [1, 2, 3, 4, 5].map((int rating) {
            return DropdownMenuItem<int>(
              value: rating,
              child: Text(rating.toString()),
            );
          }).toList(),
          onChanged: (int? value) {
            // Handle rating filter logic here
          },
        ),
        DropdownButton<String>(
          hint: Text("Filter by Location"),
          items: [
            "All Locations",
            "Downtown Parking",
            "Airport Parking",
            "Mall Parking"
          ].map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (String? value) {
            // Handle location filter logic here
          },
        ),
      ],
    );
  }

  // Build feedback card
  Widget _buildFeedbackCard(customFeedback.Feedback feedback) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text("${feedback.rating} Stars"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedback.comment ?? "No comments"), // Ensure 'comment' property exists in the model
            Text("Location: ${feedback.location ?? 'Unknown'}"),
            Text("Date: ${feedback.date ?? 'Unknown'}"),
            if (!feedback.isResolved)
              TextButton(
                onPressed: () {
                  // Mark as resolved logic
                },
                child: Text("Mark as Resolved", style: TextStyle(color: Colors.blue)),
              ),
          ],
        ),
      ),
    );
  }

  // Export feedback report
  void _exportFeedbackReport() {
    // Logic to export feedback data, e.g., to CSV or PDF
    print("Exporting feedback report...");
  }
}
