import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_post_state.dart';
part 'add_post_event.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final PostRepository _postRepository;

  AddPostBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(AddPostInitial()) {
    on<UpdatePost>(_updatePost);
  }

  Future<void> _updatePost(UpdatePost event, Emitter<AddPostState> emit) async {
    emit(AddPostInitial());

    try {
      await _postRepository.addPost(event.post);

      emit(AddPostSuccess());
    } catch (e) {
      emit(AddPostError(e.toString()));
    }
  }
}
