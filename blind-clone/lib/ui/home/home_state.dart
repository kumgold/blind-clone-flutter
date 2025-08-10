import 'package:blind_clone_flutter/data/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeResult extends HomeState {
  final List<Post> posts;

  const HomeResult({required this.posts});

  @override
  List<Object> get props => [posts];
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
