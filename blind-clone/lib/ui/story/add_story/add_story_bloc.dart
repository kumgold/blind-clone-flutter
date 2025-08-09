import 'package:blind_clone_flutter/ui/story/add_story/add_story_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddStoryEvent extends Equatable {
  const AddStoryEvent();

  @override
  List<Object?> get props => [];
}

class AddStoryBloc extends Bloc<AddStoryEvent, AddStoryState> {
  AddStoryBloc() : super(AddStoryInitial());
}
