import 'package:blind_clone_flutter/ui/home/home_event.dart';
import 'package:blind_clone_flutter/ui/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(HomeLoading());

      try {
        await Future.delayed(const Duration(seconds: 2));

        emit(const HomeResult(message: 'fetch data successed'));
      } catch (e) {
        emit(const HomeError(errorMessage: 'fetch data failed'));
      }
    });
  }
}
