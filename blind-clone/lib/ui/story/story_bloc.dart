import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/story/story_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc({required PostRepository postRepository}) : super(StoryInitial());
}
