import 'dart:io';

import 'package:blind_clone_flutter/ui/home/home_bloc.dart';
import 'package:blind_clone_flutter/ui/home/home_state.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_bloc.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_screen.dart';
import 'package:blind_clone_flutter/ui/post/post_detail/post_detail_screen.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_bloc.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_screen.dart';
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
    // initState에서 FetchPost 이벤트를 호출
    context.read<HomeBloc>().add(FetchPosts());
  }

  Future<void> _onRefresh() async {
    // 새로고침 시 FetchPost 이벤트를 다시 호출
    context.read<HomeBloc>().add(FetchPosts());
  }

  void _showAddPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text('일반 게시물'),
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
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('사진 게시물'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            AddStoryBloc(postRepository: context.read()),
                        child: const AddStoryScreen(),
                      ),
                    ),
                  );
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
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              return Center();
            }

            if (state is HomeLoading) {
              return Center(child: defaultProgressIndicator());
            }

            if (state is HomeResult) {
              if (state.posts.isEmpty) {
                return const Center(child: Text('게시물이 없습니다.'));
              }
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    if (index == 3) {
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.stories.length,
                          itemBuilder: (context, hIndex) {
                            final story = state.stories[hIndex];
                            return Container(
                              margin: const EdgeInsets.all(8),
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
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
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      final post = state.posts[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              post.channelName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(post.content),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailScreen(postId: post.id),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            }
            return Text('');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostOptions(context);
        },
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }
}
