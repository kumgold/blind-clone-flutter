import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_post_state.dart';
part 'edit_post_event.dart';

class EditPostBloc extends Bloc<EditPostEvent, EditPostState> {
  final PostRepository _postRepository;

  EditPostBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(EditPostInitial()) {
    on<SubmitPostChanges>(_onSubmitPostChanges);
  }

  Future<void> _onSubmitPostChanges(
    SubmitPostChanges event,
    Emitter<EditPostState> emit,
  ) async {
    emit(EditPostLoading());

    try {
      await _postRepository.addPost(event.post);

      emit(EditPostSuccess(event.post));
    } catch (e) {
      emit(EditPostError(e.toString()));
    }
  }
}
