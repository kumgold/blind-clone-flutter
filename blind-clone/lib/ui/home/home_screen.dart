import 'package:blind_clone_flutter/ui/home/home_bloc.dart';
import 'package:blind_clone_flutter/ui/home/home_state.dart';
import 'package:blind_clone_flutter/ui/post_detail/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              return Text('home initial');
            }
            if (state is HomeLoading) {
              return Text('home loading');
            }

            if (state is HomeResult) {
              if (state.posts.isEmpty) {
                return const Center(child: Text('게시물이 없습니다.'));
              }
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.content),
                    onTap: () {
                      // Navigator.push를 사용하여 새 화면으로 이동합니다.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // 이동할 화면의 인스턴스를 생성합니다.
                          // PostDetailScreen에 선택된 post 객체를 전달합니다.
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return Text('error state');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeBloc>().add(FetchPosts());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
