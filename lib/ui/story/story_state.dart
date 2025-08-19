import 'package:blind_clone_flutter/data/post.dart';
import 'package:equatable/equatable.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryResult extends StoryState {
  final List<Post> posts;

  const StoryResult({required this.posts});

  @override
  List<Object> get props => [posts];
}

class StoryError extends StoryState {
  final String errorMessage;

  const StoryError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
