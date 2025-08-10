class Post {
  final String id;
  final String channelName;
  final String title;
  final String content;

  const Post({
    required this.id,
    required this.channelName,
    required this.title,
    required this.content,
  });

  factory Post.fromJson(String id, Map<String, dynamic> json) {
    return Post(
      id: id,
      channelName: json['channelName'] ?? '',
      title: json['title'] ?? '제목 없음',
      content: json['content'] ?? '내용 없음',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelName': channelName,
      'title': title,
      'content': content,
    };
  }

  List<Object?> get props => [id, channelName, title, content];
}
