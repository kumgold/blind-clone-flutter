import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/post/post_detail/post_detail_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class GetPostDetail extends PostDetailEvent {
  final String postId;

  const GetPostDetail(this.postId);

  @override
  List<Object> get props => [postId];
}

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostRepository _postRepository;

  PostDetailBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(PostDetailInitial()) {
    on<GetPostDetail>(_onGetPostDetail);
  }

  Future<void> _onGetPostDetail(
    GetPostDetail event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(PostDetailLoading());

    try {
      final post = await _postRepository.getPost(event.postId);

      emit(PostDetailLoaded(post));
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }
}
