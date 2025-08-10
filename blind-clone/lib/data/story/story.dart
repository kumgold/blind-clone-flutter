class Story {
  final String id;
  final String title;
  final String content;
  final String imageUrl;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content, 'imageUrl': imageUrl};
  }

  factory Story.fromJson(Map<String, dynamic> map, String documentId) {
    return Story(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
