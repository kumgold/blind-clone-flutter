import 'package:blind_clone_flutter/data/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostRepository {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');

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
      final snapshot = await _postsRef.orderByChild('id').equalTo(postId).get();

      debugPrint('Snapshot value: ${snapshot.value}');

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final postJson = Map<String, dynamic>.from(data.values.first);

        return Post.fromJson(postId, postJson);
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
