import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String title;
  final String content;

  const Post({required this.id, required this.title, required this.content});

  // JSON(Map)에서 Post 객체로 변환하는 factory 생성자
  factory Post.fromJson(String id, Map<String, dynamic> json) {
    return Post(
      id: id,
      title: json['title'] ?? '제목 없음',
      content: json['content'] ?? '내용 없음',
    );
  }

  @override
  List<Object?> get props => [id, title, content];
}
