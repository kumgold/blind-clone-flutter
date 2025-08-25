class Post {
  final String id;
  final String channelName;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.channelName,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageUrl,
  });

  factory Post.fromJson(String id, Map<String, dynamic> json) {
    return Post(
      id: id,
      channelName: json['channelName'] ?? '',
      title: json['title'] ?? '제목 없음',
      content: json['content'] ?? '내용 없음',
      imageUrl: json['imageUrl'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelName': channelName,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  List<Object?> get props => [
    id,
    channelName,
    title,
    content,
    imageUrl,
    createdAt,
  ];
}
