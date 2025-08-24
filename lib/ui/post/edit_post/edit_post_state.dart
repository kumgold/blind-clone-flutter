part of 'edit_post_bloc.dart';

abstract class EditPostState extends Equatable {
  const EditPostState();

  @override
  List<Object> get props => [];
}

/// 초기 상태
class EditPostInitial extends EditPostState {}

/// 수정이 진행 중인 상태
class EditPostLoading extends EditPostState {}

/// 수정에 성공한 상태
class EditPostSuccess extends EditPostState {
  final Post updatedPost;

  const EditPostSuccess(this.updatedPost);

  @override
  List<Object> get props => [updatedPost];
}

/// 수정에 실패한 상태
class EditPostError extends EditPostState {
  final String message;

  const EditPostError(this.message);

  @override
  List<Object> get props => [message];
}
