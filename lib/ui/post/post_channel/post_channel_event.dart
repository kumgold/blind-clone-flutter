part of 'post_channel_bloc.dart';

abstract class PostChannelEvent extends Equatable {
  const PostChannelEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostChannelEvent {
  final String channelName;

  const FetchPosts(this.channelName);

  @override
  List<Object> get props => [channelName];
}
