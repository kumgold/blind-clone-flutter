import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final PostRepository _postRepository;

  StoryBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(StoryInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  void _onFetchPosts(FetchPosts event, Emitter<StoryState> emit) async {
    emit(StoryLoading());

    try {
      final channelName = '스토리';

      final result = await _postRepository.getPosts(channelName: channelName);

      emit(StoryResult(posts: result));
    } catch (e) {
      emit(StoryError(errorMessage: e.toString()));
    }
  }
}
