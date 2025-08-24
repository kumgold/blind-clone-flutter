import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostRepository _postRepository;

  PostDetailBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(PostDetailInitial()) {
    on<GetPostDetail>(_onGetPostDetail);
    on<UpdatePostDetail>(_onUpdatePostDetail);
    on<DeletePost>(_onDeletePost);
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

  void _onUpdatePostDetail(
    UpdatePostDetail event,
    Emitter<PostDetailState> emit,
  ) {
    emit(PostDetailLoaded(event.post));
  }

  Future<void> _onDeletePost(
    DeletePost event,
    Emitter<PostDetailState> emit,
  ) async {
    try {
      await _postRepository.deletePost(event.postId);

      emit(PostDeleteSuccess());
    } catch (e) {
      emit(PostDetailError("삭제 중 오류가 발생했습니다: ${e.toString()}"));
    }
  }
}
