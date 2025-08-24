part of 'add_story_bloc.dart';

abstract class AddStoryEvent extends Equatable {
  const AddStoryEvent();

  @override
  List<Object?> get props => [];
}

class UpdateStory extends AddStoryEvent {
  final String title;
  final String content;
  final File imageFile;

  const UpdateStory(this.title, this.content, this.imageFile);

  @override
  List<Object?> get props => [title, content, imageFile];
}
