import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/channel_post/channel_post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelPostScreen extends StatelessWidget {
  final String channelName;

  const ChannelPostScreen({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChannelPostBloc(postRepository: PostRepository())
            ..add(FetchPosts(channelName)),
      child: Center(),
    );
  }
}
