import 'package:blind_clone_flutter/data/post.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');

  // 'posts' 경로의 데이터를 실시간 Stream으로 반환
  Stream<List<Post>> getPostsStream() {
    return _postsRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return [];
      }

      final posts = data.entries.map((entry) {
        // entry.key는 Firebase에서 생성된 고유 키
        // entry.value는 title, content를 담고 있는 Map
        return Post.fromJson(entry.key, Map<String, dynamic>.from(entry.value));
      }).toList();

      return posts;
    });
  }

  Future<Post> getPost(String postId) async {
    try {
      final snapshot = await _postsRef.child(postId).get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return Post.fromJson(postId, data);
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
