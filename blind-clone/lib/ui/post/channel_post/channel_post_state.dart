import 'package:blind_clone_flutter/data/post.dart';
import 'package:equatable/equatable.dart';

abstract class ChannelPostState extends Equatable {
  const ChannelPostState();

  @override
  List<Object> get props => [];
}

class ChannelPostInitial extends ChannelPostState {}

class ChannelPostLoading extends ChannelPostState {}

class ChannelPostResult extends ChannelPostState {
  final List<Post> posts;

  const ChannelPostResult({required this.posts});

  @override
  List<Object> get props => [posts];
}

class ChannelPostError extends ChannelPostState {
  final String errorMessage;

  const ChannelPostError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
