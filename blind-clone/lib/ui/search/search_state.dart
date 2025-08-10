import 'package:blind_clone_flutter/data/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResult extends SearchState {
  final List<Post> posts;

  const SearchResult({required this.posts});

  @override
  List<Object> get props => [posts];
}

class SearchError extends SearchState {
  final String errorMessage;

  const SearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
