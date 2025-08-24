part of 'add_post_bloc.dart';

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
