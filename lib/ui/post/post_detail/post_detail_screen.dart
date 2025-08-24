import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/post/edit_post/edit_post_bloc.dart';
import 'package:blind_clone_flutter/ui/post/edit_post/edit_post_screen.dart';
import 'package:blind_clone_flutter/ui/post/post_detail/post_detail_bloc.dart';
import 'package:blind_clone_flutter/ui/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostDetailBloc(postRepository: context.read())
            ..add(GetPostDetail(postId)),
      child: const PostDetailView(),
    );
  }
}

class PostDetailView extends StatelessWidget {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<PostDetailBloc, PostDetailState>(
            builder: (context, state) {
              if (state is PostDetailLoaded) {
                return PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      // 수정하기 버튼 클릭 시
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider<EditPostBloc>(
                            create: (context) => EditPostBloc(
                              postRepository: context.read<PostRepository>(),
                            ),
                            child: EditPostScreen(post: state.post),
                          ),
                        ),
                      );

                      if (result != null && result is Post && context.mounted) {
                        context.read<PostDetailBloc>().add(
                          UpdatePostDetail(result),
                        );
                      }
                    } else if (value == 'delete') {
                      context.read<PostDetailBloc>().add(
                        DeletePost(state.post.id),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('수정하기'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('삭제하기'),
                        ),
                      ],
                );
              }
              // 로딩 중이거나 에러일 때는 더보기 버튼을 숨깁니다.
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          // 로딩 상태일 때
          if (state is PostDetailLoading) {
            return Center(child: defaultProgressIndicator());
          }
          // 데이터 로드 완료 상태일 때
          else if (state is PostDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.post.channelName),
                  Text(
                    state.post.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    state.post.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          // 에러 상태일 때
          else if (state is PostDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('오류가 발생했습니다: ${state.message}'),
              ),
            );
          }
          // 초기 상태 또는 기타 상태일 때
          return const Center(child: Text('게시물을 불러오는 중...'));
        },
      ),
    );
  }
}
