import 'package:blind_clone_flutter/data/post.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');

  // 'posts' 경로의 데이터를 실시간 Stream으로 반환
  Stream<List<Post>> getPostsStream() {
    return _postsRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return []; // 데이터가 없으면 빈 리스트 반환
      }

      final posts = data.entries.map((entry) {
        // entry.key는 Firebase에서 생성된 고유 키
        // entry.value는 title, content를 담고 있는 Map
        return Post.fromJson(entry.key, Map<String, dynamic>.from(entry.value));
      }).toList();

      return posts;
    });
  }
}
