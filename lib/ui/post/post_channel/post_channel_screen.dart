import 'package:blind_clone_flutter/ui/post/post_channel/post_channel_bloc.dart';
import 'package:blind_clone_flutter/ui/widget/post.dart';
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
    context.read<PostChannelBloc>().add(FetchPosts(widget.channelName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PostChannelBloc(postRepository: context.read())
            ..add(FetchPosts(widget.channelName)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            widget.channelName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Center(
          child: BlocBuilder<PostChannelBloc, PostChannelState>(
            builder: (context, state) {
              if (state is PostChannelInitial) {
                return const Center();
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
                      return PostTile(post: post);
                    },
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
    );
  }
}
