part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends StoryEvent {
  const FetchPosts();

  @override
  List<Object> get props => [];
}
