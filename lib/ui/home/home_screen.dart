import 'dart:io';
import 'dart:math';

import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/ui/home/home_bloc.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_bloc.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_screen.dart';
import 'package:blind_clone_flutter/ui/post/post_detail/post_detail_screen.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_bloc.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_screen.dart';
import 'package:blind_clone_flutter/ui/story/story_screen.dart';
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
                      builder:
                          (_) => BlocProvider(
                            create:
                                (_) =>
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
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (_) => AddStoryBloc(
                                  postRepository: context.read(),
                                ),
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
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              return Center();
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
              final List<Post> postsAfterStory = state.posts.sublist(
                splitIndex,
              );

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  slivers: [
                    // 2. 스토리 섹션 이전에 보여줄 게시물 목록 (최대 3개)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = postsBeforeStory[index];
                        return _postTile(post);
                      }, childCount: postsBeforeStory.length),
                    ),

                    // 3. 스토리가 있을 경우, 중간에 스토리 섹션을 삽입
                    if (state.stories.isNotEmpty)
                      SliverToBoxAdapter(child: _storySection(state.stories)),

                    // 4. 스토리 섹션 이후에 보여줄 나머지 게시물 목록
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = postsAfterStory[index];
                        return _postTile(post);
                      }, childCount: postsAfterStory.length),
                    ),
                  ],
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

  Widget _storySection(List<Post> stories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('스토리 화면으로 이동', style: TextStyle(fontSize: 20)),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoryScreen()),
            );
          },
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('나만의 일상생활을 공유해보세요!', style: TextStyle(fontSize: 16)),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, hIndex) {
              final story = stories[hIndex];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
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
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(story.title),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final result = Navigator.push(
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _postTile(Post post) {
    return ListTile(
      title: Row(
        children: [
          Text(post.title, style: TextStyle(fontSize: 14, color: Colors.black)),
          Text(
            post.channelName,
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
      subtitle: Text(post.content),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: post.id),
          ),
        );
      },
    );
  }
}
