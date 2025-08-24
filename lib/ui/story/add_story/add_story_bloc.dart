import 'dart:io';

import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_story_event.dart';
part 'add_story_state.dart';

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
