import 'package:blind_clone_flutter/data/post.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');

  Future<List<Post>> getPosts({String? channelName}) async {
    try {
      final snapshot = await _postsRef.get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        return [];
      }

      final posts = data.entries.map((entry) {
        return Post.fromJson(entry.key, Map<String, dynamic>.from(entry.value));
      }).toList();

      if (channelName != null && channelName.isNotEmpty) {
        final filteredPosts = posts.where((post) {
          return post.channelName == channelName;
        }).toList();

        return filteredPosts;
      }

      return posts;
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
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

  Future<void> addPost(Post post) async {
    try {
      await _postsRef.child(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }
}
