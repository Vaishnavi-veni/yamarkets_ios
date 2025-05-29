class Category {
  final String title;
  final List<Topic> topics;

  Category({
    required this.title,
    required this.topics,
  });
}

class Topic {
  final String title;
  final List<Subtopic> subtopics;

  Topic({
    required this.title,
    required this.subtopics,
  });
}

class Subtopic {
  final String title;
  final String videoUrl;

  Subtopic({
    required this.title,
    required this.videoUrl,
  });
}
