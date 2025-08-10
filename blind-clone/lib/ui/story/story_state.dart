import 'package:equatable/equatable.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryResult extends StoryState {}

class StoryError extends StoryState {
  final String errorMessage;

  const StoryError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
