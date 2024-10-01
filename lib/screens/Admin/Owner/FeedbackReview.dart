import 'package:flutter/material.dart';

class FeedbackReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Review"),
        centerTitle: true,
        backgroundColor: Color(0xFF7671FA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Options
            _buildFilterOptions(context),
            SizedBox(height: 10),

            // List of Submitted Feedback
            Expanded(
              child: ListView.builder(
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  return _buildFeedbackCard(feedbackList[index]);
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
      ),
    );
  }

  // Mock data for feedback
  final List<Feedback> feedbackList = [
    Feedback(
      rating: 5,
      comment: "Great parking experience!",
      location: "Downtown Parking",
      date: "2024-09-01",
      isResolved: false,
    ),
    Feedback(
      rating: 3,
      comment: "There were no available slots.",
      location: "Airport Parking",
      date: "2024-09-02",
      isResolved: true,
    ),
    Feedback(
      rating: 4,
      comment: "Good service but a bit pricey.",
      location: "Mall Parking",
      date: "2024-09-03",
      isResolved: false,
    ),
  ];

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
            // Handle rating filter
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
            // Handle location filter
          },
        ),
      ],
    );
  }

  // Build feedback card
  Widget _buildFeedbackCard(Feedback feedback) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text("${feedback.rating} Stars"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedback.comment),
            Text("Location: ${feedback.location}"),
            Text("Date: ${feedback.date}"),
            if (!feedback.isResolved)
              TextButton(
                onPressed: () {
                  // Mark as resolved
                  // You may want to add logic to update the feedback list
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

// Model class for Feedback
class Feedback {
  final int rating;
  final String comment;
  final String location;
  final String date;
  final bool isResolved;

  Feedback({
    required this.rating,
    required this.comment,
    required this.location,
    required this.date,
    required this.isResolved,
  });
}
