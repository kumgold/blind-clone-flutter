part of 'add_story_bloc.dart';

abstract class AddStoryState extends Equatable {
  const AddStoryState();

  @override
  List<Object?> get props => [];
}

class AddStoryInitial extends AddStoryState {}

class AddStoryLoading extends AddStoryState {}

class AddStoryResult extends AddStoryState {}

class AddStoryError extends AddStoryState {
  final String errorMessage;

  const AddStoryError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
