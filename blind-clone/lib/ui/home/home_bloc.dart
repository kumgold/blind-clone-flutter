import 'dart:async';

import 'package:blind_clone_flutter/data/post.dart';
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

// 내부적으로 스트림에서 새로운 데이터가 왔을 때 사용할 이벤트
class _HomeUpdated extends HomeEvent {
  final List<Post> posts;

  const _HomeUpdated(this.posts);

  @override
  List<Object> get props => [posts];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostRepository _postRepository;

  HomeBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(HomeLoading()) {
    // 초기 상태는 로딩
    on<FetchPosts>(_onFetchPosts);
    on<_HomeUpdated>(_onPostsUpdated);
  }

  void _onFetchPosts(FetchPosts event, Emitter<HomeState> emit) async {
    try {
      final result = await _postRepository.getPosts();
      add(_HomeUpdated(result));
    } catch (e) {
      add(_HomeUpdated([]));
    }
  }

  void _onPostsUpdated(_HomeUpdated event, Emitter<HomeState> emit) {
    emit(HomeResult(posts: event.posts));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
