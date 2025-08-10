import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/post/post_channel/post_channel_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PostChannelEvent extends Equatable {
  const PostChannelEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostChannelEvent {
  final String channelName;

  const FetchPosts(this.channelName);

  @override
  List<Object> get props => [channelName];
}

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

  @override
  Future<void> close() {
    return super.close();
  }
}
