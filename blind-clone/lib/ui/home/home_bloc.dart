import 'dart:async';

import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/home/home_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostRepository _postRepository;
  StreamSubscription? _postsSubscription;

  HomeBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(HomeLoading()) {
    // 초기 상태는 로딩
    on<FetchPosts>(_onFetchPosts);
    on<_HomeUpdated>(_onPostsUpdated);
  }

  void _onFetchPosts(FetchPosts event, Emitter<HomeState> emit) {
    // 기존 구독이 있다면 취소
    _postsSubscription?.cancel();

    // 리포지토리의 스트림을 구독
    _postsSubscription = _postRepository.getPostsStream().listen(
      (posts) {
        // 스트림에서 새로운 데이터가 오면 _PostsUpdated 이벤트를 발생시킴
        add(_HomeUpdated(posts));
      },
      onError: (error) {
        // 스트림에서 에러 발생 시 PostsError 상태로 변경
        emit(HomeError(errorMessage: '데이터를 불러오는 데 실패했습니다: $error'));
      },
    );
  }

  void _onPostsUpdated(_HomeUpdated event, Emitter<HomeState> emit) {
    // 새로운 게시물 리스트와 함께 PostsLoaded 상태로 변경
    emit(HomeResult(posts: event.posts));
  }

  @override
  Future<void> close() {
    // BLoC이 소멸될 때 스트림 구독을 반드시 취소
    _postsSubscription?.cancel();
    return super.close();
  }
}

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
