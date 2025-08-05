import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/channel_post/channel_post_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChannelPostEvent extends Equatable {
  const ChannelPostEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends ChannelPostEvent {
  final String channelName;

  const FetchPosts(this.channelName);

  @override
  List<Object> get props => [channelName];
}

class ChannelPostBloc extends Bloc<ChannelPostEvent, ChannelPostState> {
  final PostRepository _postRepository;

  ChannelPostBloc({required PostRepository postRepository})
    : _postRepository = postRepository,
      super(ChannelPostInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  void _onFetchPosts(FetchPosts event, Emitter<ChannelPostState> emit) async {
    try {
      final result = await _postRepository.getPosts();

      emit(ChannelPostResult(posts: result));
    } catch (e) {
      emit(ChannelPostError(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
