import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeResult extends HomeState {
  final String message;

  const HomeResult({required this.message});

  @override
  List<Object> get props => [message];
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
