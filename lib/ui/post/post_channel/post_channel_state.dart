part of 'post_channel_bloc.dart';

abstract class PostChannelState extends Equatable {
  const PostChannelState();

  @override
  List<Object> get props => [];
}

class PostChannelInitial extends PostChannelState {}

class PostChannelLoading extends PostChannelState {}

class PostChannelResult extends PostChannelState {
  final List<Post> posts;

  const PostChannelResult({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostChannelError extends PostChannelState {
  final String errorMessage;

  const PostChannelError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
