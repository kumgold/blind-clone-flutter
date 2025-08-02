import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/post_add/post_add_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PostAddEvent extends Equatable {
  const PostAddEvent();

  @override
  List<Object> get props => [];
}

class UpdatePost extends PostAddEvent {
  final Post post;

  const UpdatePost(this.post);

  @override
  List<Object> get props => [post];
}

class PostAddBloc extends Bloc<PostAddEvent, PostAddState> {
  final PostRepository _postRepository;

  PostAddBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(PostAddInitial()) {
    on<UpdatePost>(_updatePost);
  }

  Future<void> _updatePost(UpdatePost event, Emitter<PostAddState> emit) async {
    emit(PostAddInitial());

    try {
      await _postRepository.addPost(event.post);

      emit(PostAddSuccess());
    } catch (e) {
      emit(PostAddError(e.toString()));
    }
  }
}
