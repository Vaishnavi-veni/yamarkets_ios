import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yamarkets_ios/screens/home/e_learining_courses/model.dart';
import 'package:yamarkets_ios/screens/home/educational_videos/video_player.dart';

class SubtopicDetailPage extends StatelessWidget {
  final String topicTitle;
  final List<Subtopic> subtopics;

  const SubtopicDetailPage({
    super.key,
    required this.topicTitle,
    required this.subtopics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$topicTitle ' ??
            'Subtopics'),
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
        itemCount: subtopics.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to VideoPlayerScreen with the video URL
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    videoUrl: subtopics[index].videoUrl,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shadowColor: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtopics[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.amber,
                        size: 30,
                      ),
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
