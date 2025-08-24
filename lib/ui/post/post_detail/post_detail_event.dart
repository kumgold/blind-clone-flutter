part of 'post_detail_bloc.dart';

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

class UpdatePostDetail extends PostDetailEvent {
  final Post post;

  const UpdatePostDetail(this.post);

  @override
  List<Object> get props => [post];
}

class DeletePost extends PostDetailEvent {
  final String postId;

  const DeletePost(this.postId);

  @override
  List<Object> get props => [postId];
}
