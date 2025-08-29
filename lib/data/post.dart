class Post {
  final String id;
  final String channelName;
  final String title;
  final String content;
  final String company;
  final int likes;
  final int comments;
  final String? imageUrl;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.channelName,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.company,
    required this.likes,
    required this.comments,
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
      company: json['company'] ?? '팀블라인드마케팅코리아',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
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
      'company': company,
      'likes': likes,
      'comments': comments,
    };
  }

  List<Object?> get props => [
    id,
    channelName,
    title,
    content,
    imageUrl,
    createdAt,
    company,
    likes,
    comments,
  ];
}
