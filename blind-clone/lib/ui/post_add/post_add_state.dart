import 'package:equatable/equatable.dart';

abstract class PostAddState extends Equatable {
  const PostAddState();

  @override
  List<Object> get props => [];
}

class PostAddInitial extends PostAddState {}

class PostAddLoading extends PostAddState {}

class PostAddSuccess extends PostAddState {}

class PostAddError extends PostAddState {
  final String message;

  const PostAddError(this.message);

  @override
  List<Object> get props => [message];
}
