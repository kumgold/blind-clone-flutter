import 'dart:io';

import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/story/add_story/add_story_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddStoryEvent extends Equatable {
  const AddStoryEvent();

  @override
  List<Object?> get props => [];
}

class UpdateStory extends AddStoryEvent {
  final String title;
  final String content;
  final File imageFile;

  const UpdateStory(this.title, this.content, this.imageFile);

  @override
  List<Object?> get props => [title, content, imageFile];
}

class AddStoryBloc extends Bloc<AddStoryEvent, AddStoryState> {
  final PostRepository _postRepository;

  AddStoryBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(AddStoryInitial()) {
    on<UpdateStory>(_updateStory);
  }

  Future<void> _updateStory(
    UpdateStory event,
    Emitter<AddStoryState> emit,
  ) async {
    emit(AddStoryLoading());

    try {
      await _postRepository.addStory(
        title: event.title,
        content: event.content,
        imageFile: event.imageFile,
      );

      emit(AddStoryResult());
    } catch (e) {
      emit(AddStoryError(errorMessage: e.toString()));
    }
  }
}
