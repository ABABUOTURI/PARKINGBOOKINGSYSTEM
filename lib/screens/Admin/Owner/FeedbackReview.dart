import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:parking_booking_system/models/feedback.dart' as customFeedback;

class FeedbackReviewPage extends StatefulWidget {
  @override
  _FeedbackReviewPageState createState() => _FeedbackReviewPageState();
}

class _FeedbackReviewPageState extends State<FeedbackReviewPage> {
  late Box<customFeedback.Feedback> feedbackBox;
  late Set<String> locations; // Stores unique locations for filtering
  bool isLoading = true;
  int? selectedRating; // Holds the selected rating for filtering

  @override
  void initState() {
    super.initState();
    _openFeedbackBox();
  }

  Future<void> _openFeedbackBox() async {
    feedbackBox = await Hive.openBox<customFeedback.Feedback>('feedback');
    _fetchUniqueLocations();
    setState(() {
      isLoading = false;
    });
  }

  // Fetch unique locations from feedback data
  void _fetchUniqueLocations() {
    locations = feedbackBox.values
        .map((feedback) => feedback.location ?? "Unknown")
        .toSet();
    locations.add("All Locations"); // Add "All Locations" option for filter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Review"),
        centerTitle: true,
        backgroundColor: Color(0xFF7671FA),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFilterOptions(context),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ValueListenableBuilder(
                      valueListenable: feedbackBox.listenable(),
                      builder: (context, Box<customFeedback.Feedback> box, _) {
                        final filteredFeedback = selectedRating == null
                            ? box.values.toList()
                            : box.values.where((feedback) => feedback.rating == selectedRating).toList();

                        if (filteredFeedback.isEmpty) {
                          return Center(child: Text("No feedback available for the selected rating"));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredFeedback.length,
                            itemBuilder: (context, index) {
                              customFeedback.Feedback feedback = filteredFeedback[index];
                              return _buildFeedbackCard(feedback);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _exportFeedbackReport,
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

  // Build filter options with dynamically populated locations
  Widget _buildFilterOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<int>(
          hint: Text("Filter by Rating"),
          value: selectedRating,
          items: [1, 2, 3, 4, 5].map((int rating) {
            return DropdownMenuItem<int>(
              value: rating,
              child: Text(rating.toString()),
            );
          }).toList(),
          onChanged: (int? value) {
            setState(() {
              selectedRating = value; // Update selected rating
            });
          },
        ),
        DropdownButton<String>(
          hint: Text("Filter by Location"),
          items: locations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (String? value) {
            // Apply location filter logic
          },
        ),
      ],
    );
  }

  // Build feedback card with comment section
  Widget _buildFeedbackCard(customFeedback.Feedback feedback) {
    TextEditingController commentController = TextEditingController();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${feedback.rating} Stars", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(feedback.comment ?? "No comments"),
            SizedBox(height: 5),
            Text("Location: ${feedback.location ?? 'Unknown'}"),
            Text("Date: ${feedback.date ?? 'Unknown'}"),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Respond to Driver",
                hintText: "Enter your response here",
              ),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!feedback.isResolved)
                  TextButton(
                    onPressed: () => _markAsResolved(feedback, commentController.text),
                    child: Text("Mark as Resolved", style: TextStyle(color: Colors.blue)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Mark feedback as resolved and save to database, send notification to driver
  void _markAsResolved(customFeedback.Feedback feedback, String ownerComment) {
    setState(() {
      feedback.isResolved = true;
      feedback.ownerComment = ownerComment; // Save owner's comment to feedback
    });
    feedbackBox.put(feedback.key, feedback); // Update feedback in the database
    _sendNotificationToDriver(feedback, ownerComment); // Send notification
  }

  // Send notification to driver and save it in Hive
  void _sendNotificationToDriver(customFeedback.Feedback feedback, String ownerComment) async {
    print("Notification sent to driver:");
    print("Feedback ID: ${feedback.key}");
    print("Message: Your feedback has been reviewed and marked as resolved.");
    print("Owner's Comment: $ownerComment");

    // Open the notifications box asynchronously
    final notificationBox = await Hive.openBox<NotificationModel>('notifications');
    
    // Add a new notification entry in the box
    notificationBox.add(NotificationModel(
      message: "Your feedback has been reviewed and marked as resolved. Owner's comment: $ownerComment",
      timestamp: DateTime.now(),
      type: "Feedback Response",
    ));
  }

  // Export feedback report
  void _exportFeedbackReport() {
    print("Exporting feedback report...");
  }

  @override
  void dispose() {
    feedbackBox.close();
    super.dispose();
  }
}

// NotificationModel class for storing notifications in Hive
class NotificationModel {
  final String message;
  final DateTime timestamp;
  final String type;

  NotificationModel({required this.message, required this.timestamp, required this.type});
}
