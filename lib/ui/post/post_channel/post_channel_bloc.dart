import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_channel_state.dart';
part 'post_channel_event.dart';

class PostChannelBloc extends Bloc<PostChannelEvent, PostChannelState> {
  final PostRepository _postRepository;

  PostChannelBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(PostChannelInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  void _onFetchPosts(FetchPosts event, Emitter<PostChannelState> emit) async {
    emit(PostChannelLoading());

    try {
      final channelName = event.channelName;

      final result = await _postRepository.getPosts(channelName: channelName);

      emit(PostChannelResult(posts: result));
    } catch (e) {
      emit(PostChannelError(errorMessage: e.toString()));
    }
  }
}
