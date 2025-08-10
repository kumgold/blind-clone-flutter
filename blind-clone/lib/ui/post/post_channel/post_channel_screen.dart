import 'package:blind_clone_flutter/data/post/post_repository.dart';
import 'package:blind_clone_flutter/ui/post/post_channel/post_channel_bloc.dart';
import 'package:blind_clone_flutter/ui/post/post_channel/post_channel_state.dart';
import 'package:blind_clone_flutter/ui/post/post_detail/post_detail_screen.dart';
import 'package:blind_clone_flutter/ui/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostChannelScreen extends StatefulWidget {
  final String channelName;

  const PostChannelScreen({super.key, required this.channelName});

  @override
  State<PostChannelScreen> createState() => _PostChannelScreenState();
}

class _PostChannelScreenState extends State<PostChannelScreen> {
  Future<void> _onRefresh() async {
    // 새로고침 시 FetchPost 이벤트를 다시 호출
    context.read<PostChannelBloc>().add(FetchPosts(widget.channelName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostChannelBloc(postRepository: PostRepository())
            ..add(FetchPosts(widget.channelName)),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.channelName)),
        body: Center(
          child: BlocBuilder<PostChannelBloc, PostChannelState>(
            builder: (context, state) {
              if (state is PostChannelInitial) {
                return Center();
              }

              if (state is PostChannelLoading) {
                return Center(child: defaultProgressIndicator());
              }

              if (state is PostChannelResult) {
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
                    },
                  ),
                );
              }
              return Text('');
            },
          ),
        ),
      ),
    );
  }
}
