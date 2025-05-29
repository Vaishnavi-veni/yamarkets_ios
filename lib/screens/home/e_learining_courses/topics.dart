import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/model.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/sub_topics.dart';

class TopicDetailPage extends StatelessWidget {
  final String topicTitle;
  final List<Topic> topics;

  const TopicDetailPage({
    super.key,
    required this.topicTitle,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            topicTitle ),
        // title: Text('$topicTitle Topics'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.amber,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the list
        child: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to SubtopicDetailPage with the selected topic
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubtopicDetailPage(
                      topicTitle: topics[index].title,
                      subtopics: topics[index].subtopics,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5, // Add shadow for depth
                margin: const EdgeInsets.symmetric(
                    vertical: 8), // Vertical margin between cards
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Optional: Add an icon or image
                      // Space between icon and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topics[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    4), // Space between title and subtopic count
                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .format_list_bulleted, // Icon for subtopics
                                  size: 16,
                                  color: Color.fromARGB(255, 245, 200, 65),
                                ),
                                const SizedBox(
                                    width: 4), // Space between icon and text
                                Text(
                                  '${topics[index].subtopics.length} ', // Display the number of subtopics
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ), // Arrow icon indicating navigation
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
