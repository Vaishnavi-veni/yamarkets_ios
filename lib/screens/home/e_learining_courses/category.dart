import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/model.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/topics.dart';

class CategoryPage extends StatelessWidget {
  final List<Category> categories;

  const CategoryPage({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
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
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          // Function to return the icon based on category title
          IconData getCategoryIcon(String title) {
            switch (title.toLowerCase()) {
              case 'beginner':
              case 'ผู้เริ่มต้น':
              case 'مبتدئ':
              case 'शुरुआती':
                return Icons.lightbulb; // Example for beginner
              case 'intermediate':
              case 'ระดับกลาง':
              case 'متوسط':
              case 'मध्यम':
                return Icons.leaderboard; // Example for intermediate
              case 'advanced':
              case 'ขั้นสูง':
              case 'متقدم':
              case 'उन्नत':
                return Icons.emoji_events; // Example for advanced
              default:
                return Icons.category; // Default icon for other categories
            }
          }

          return GestureDetector(
            onTap: () {
              // Navigate to TopicDetailPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicDetailPage(
                    topicTitle: categories[index].title,
                    topics: categories[index].topics,
                  ),
                ),
              );
            },
            child: Card(
              elevation:
                  10, // Slightly increase elevation for a deeper shadow effect
              margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12), // Adjust margin for better spacing
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // More rounded corners
              ),
              child: Container(
                decoration: BoxDecoration(
                  //  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.white, // Add background color for the image
                      ),
                      child: Icon(
                        getCategoryIcon(categories[index]
                            .title), // Set icon based on category title
                        size: 40,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 20), // Space between icon and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categories[index].title,
                            style: const TextStyle(
                              fontSize: 22, // Slightly larger text
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
