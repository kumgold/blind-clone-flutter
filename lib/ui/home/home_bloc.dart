import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/home/home_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends HomeEvent {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostRepository _postRepository;

  HomeBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(HomeLoading()) {
    on<FetchPosts>(_onFetchPosts);
  }

  void _onFetchPosts(FetchPosts event, Emitter<HomeState> emit) async {
    try {
      final result = await _postRepository.getPosts();
      final posts = result.where((e) => e.channelName != '스토리').toList();
      final stories = result.where((e) => e.channelName == '스토리').toList();

      emit(HomeResult(posts: posts, stories: stories));
    } catch (e) {
      emit(HomeResult(posts: [], stories: []));
    }
  }
}
