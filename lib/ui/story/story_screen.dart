import 'dart:async';
import 'dart:io';

import 'package:blind_clone_flutter/ui/story/story_bloc.dart';
import 'package:blind_clone_flutter/ui/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryScreen extends StatefulWidget {
  final int? initialIndex;

  const StoryScreen({super.key, this.initialIndex});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  AnimationController? _animController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;

    _pageController = PageController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animController?.dispose();
    super.dispose();
  }

  void _startTimer(int length) {
    _timer?.cancel();
    _animController?.forward(from: 0);

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted) return;

      int nextIndex = (_currentIndex + 1) % length;
      await _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex = nextIndex;
      });

      _animController?.forward(from: 0); // progress bar 다시 시작
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              StoryBloc(postRepository: context.read())
                ..add(const FetchPosts()),
      child: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryResult) {
            if (state.posts.isNotEmpty) {
              _startTimer(state.posts.length);
            }
          }
        },
        builder: (context, state) {
          if (state is StoryLoading) {
            return Center(child: defaultProgressIndicator());
          }

          if (state is StoryError) {
            return Center(child: Text('에러 발생: ${state.errorMessage}'));
          }

          if (state is StoryResult) {
            final posts = state.posts;

            if (posts.isEmpty) {
              return const Center(child: Text('게시글이 없습니다.'));
            }

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: SizedBox(
                  height: 4,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _animController!,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _animController!.value,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              body: SafeArea(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    _startTimer(state.posts.length);
                  },
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[_currentIndex];

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (post.imageUrl != null &&
                            File(post.imageUrl!).existsSync())
                          Image.file(File(post.imageUrl!), fit: BoxFit.cover)
                        else
                          Container(color: Colors.black87),

                        // 하단 텍스트 영역
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
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
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
