import 'dart:io';
import 'dart:math';

import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/ui/home/home_bloc.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_bloc.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_screen.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_bloc.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_screen.dart';
import 'package:blind_clone_flutter/ui/story/story_screen.dart';
import 'package:blind_clone_flutter/ui/widget/post.dart';
import 'package:blind_clone_flutter/ui/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchPosts());
  }

  Future<void> _onRefresh() async {
    context.read<HomeBloc>().add(FetchPosts());
  }

  void _showAddPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.article_outlined,
                  color: Colors.black87,
                ),
                title: const Text(
                  '일반 게시물',
                  style: TextStyle(color: Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            AddPostBloc(postRepository: context.read()),
                        child: const AddPostScreen(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.black87,
                ),
                title: const Text(
                  '사진 게시물',
                  style: TextStyle(color: Colors.black87),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            AddStoryBloc(postRepository: context.read()),
                        child: const AddStoryScreen(),
                      ),
                    ),
                  );

                  if (result == true && context.mounted) {
                    context.read<HomeBloc>().add(FetchPosts());
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return const Center();
          } else if (state is HomeLoading) {
            return Center(child: defaultProgressIndicator());
          } else if (state is HomeResult) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('게시물이 없습니다.'));
            }

            final int splitIndex = min(3, state.posts.length);
            final List<Post> postsBeforeStory = state.posts.sublist(
              0,
              splitIndex,
            );
            final List<Post> postsAfterStory = state.posts.sublist(splitIndex);

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = postsBeforeStory[index];
                      return PostTile(post: post);
                    }, childCount: postsBeforeStory.length),
                  ),

                  if (state.stories.isNotEmpty)
                    SliverToBoxAdapter(child: _storySection(state.stories)),

                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = postsAfterStory[index];
                      return PostTile(post: post);
                    }, childCount: postsAfterStory.length),
                  ),
                ],
              ),
            );
          }
          return const Text('');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostOptions(context),
        backgroundColor: const Color(0xFF2F55D2),
        child: const Icon(Icons.post_add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _storySection(List<Post> stories) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '스토리',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StoryScreen(),
                    ),
                  );
                },
                child: const Text(
                  '모두 보기',
                  style: TextStyle(color: Color(0xFF2F55D2)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '나만의 일상생활을 공유해보세요!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, hIndex) {
                final story = stories[hIndex];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryScreen(initialIndex: hIndex),
                      ),
                    );

                    if (result == true && context.mounted) {
                      context.read<HomeBloc>().add(FetchPosts());
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text('게시글이 삭제되었습니다.')),
                        );
                    }
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          (story.imageUrl != null &&
                                  File(story.imageUrl!).existsSync())
                              ? Image.file(
                                  File(story.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Text(
                              story.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
