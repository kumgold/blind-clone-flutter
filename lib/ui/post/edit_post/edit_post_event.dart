part of 'edit_post_bloc.dart';

abstract class EditPostEvent extends Equatable {
  const EditPostEvent();

  @override
  List<Object> get props => [];
}

class SubmitPostChanges extends EditPostEvent {
  final Post post;

  const SubmitPostChanges(this.post);

  @override
  List<Object> get props => [post];
}
