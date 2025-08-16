import 'dart:async';
import 'dart:io';

import 'package:blind_clone_flutter/ui/story/story_bloc.dart';
import 'package:blind_clone_flutter/ui/story/story_state.dart';
import 'package:blind_clone_flutter/ui/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int length) {
    _timer?.cancel(); // 기존 타이머 취소
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % length; // 다음 인덱스로 이동
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StoryBloc(postRepository: context.read())..add(const FetchPosts()),
      child: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryResult) {
            // 게시글이 있을 때만 타이머 시작
            if (state.posts.isNotEmpty) {
              _startTimer(state.posts.length);
            }
          }
        },
        builder: (context, state) {
          if (state is StoryLoading) {
            return defaultProgressIndicator();
          }

          if (state is StoryError) {
            return Center(child: Text('에러 발생: ${state.errorMessage}'));
          }

          if (state is StoryResult) {
            final posts = state.posts;

            if (posts.isEmpty) {
              return const Center(child: Text('게시글이 없습니다.'));
            }

            final post = posts[_currentIndex];

            return Stack(
              fit: StackFit.expand,
              children: [
                // 배경 이미지
                if (post.imageUrl != null && File(post.imageUrl!).existsSync())
                  Image.file(File(post.imageUrl!), fit: BoxFit.cover)
                else
                  Container(color: Colors.black87),

                // 아래쪽 제목/내용 Overlay
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
