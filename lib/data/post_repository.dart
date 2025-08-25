import 'dart:io';

import 'package:blind_clone_flutter/data/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PostRepository {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');

  Future<List<Post>> getPosts({String? channelName}) async {
    try {
      final snapshot = await _postsRef.orderByChild('createdAt').get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (!snapshot.exists) {
        return [];
      }

      final posts = snapshot.children.map((dataSnapshot) {
        final postData = Map<String, dynamic>.from(dataSnapshot.value as Map);
        return Post.fromJson(dataSnapshot.key!, postData);
      }).toList();

      final sortedPosts = posts.reversed.toList();

      if (channelName != null && channelName.isNotEmpty) {
        final filteredPosts = sortedPosts.where((post) {
          return post.channelName == channelName;
        }).toList();

        return filteredPosts;
      }

      return sortedPosts;
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

  Future<void> deletePost(String postId) async {
    try {
      await _postsRef.child(postId).remove();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<String> _saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();

    // 2. 파일 이름이 중복되지 않도록 타임스탬프로 고유한 이름 생성
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    // 3. 디렉터리 경로와 파일 이름을 합쳐 새 파일의 전체 경로를 만듭니다.
    final newPath = p.join(directory.path, fileName);

    // 4. image_picker가 제공한 임시 파일을 영구적인 새 경로로 복사합니다.
    final newImage = await imageFile.copy(newPath);

    return newImage.path;
  }

  Future<void> addStory({
    required String title,
    required String content,
    required File imageFile,
  }) async {
    try {
      final imageUrl = await _saveImage(imageFile);
      final storyId = DateTime.now().millisecondsSinceEpoch.toString();

      final newStoryData = {
        'id': storyId,
        'title': title,
        'content': content,
        'channelName': '스토리',
        'imageUrl': imageUrl,
      };

      await _postsRef.child(storyId).set(newStoryData);
    } catch (e) {
      debugPrint("스토리 추가 오류: $e");
      // UI에 에러를 전파하려면 rethrow 사용
      rethrow;
    }
  }
}
