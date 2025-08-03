import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/home/home_bloc.dart';
import 'package:blind_clone_flutter/ui/home/home_state.dart';
import 'package:blind_clone_flutter/ui/add_post/add_post_bloc.dart';
import 'package:blind_clone_flutter/ui/add_post/add_post_screen.dart';
import 'package:blind_clone_flutter/ui/post_detail/post_detail_screen.dart';
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
              return Center(child: CircularProgressIndicator());
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
                    final post = state.posts[index];
                    return ListTile(
                      title: Text(post.title),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AddPostBloc(postRepository: PostRepository()),
                child: const AddPostScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }
}
