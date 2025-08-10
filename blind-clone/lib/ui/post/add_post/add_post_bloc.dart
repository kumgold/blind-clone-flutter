import 'package:blind_clone_flutter/data/post/post.dart';
import 'package:blind_clone_flutter/data/post/post_repository.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddPostEvent extends Equatable {
  const AddPostEvent();

  @override
  List<Object> get props => [];
}

class UpdatePost extends AddPostEvent {
  final Post post;

  const UpdatePost(this.post);

  @override
  List<Object> get props => [post];
}

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
