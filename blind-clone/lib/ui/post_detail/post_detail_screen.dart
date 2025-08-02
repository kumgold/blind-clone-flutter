import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/post_detail/post_detail_bloc.dart';
import 'package:blind_clone_flutter/ui/post_detail/post_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostDetailBloc(postRepository: PostRepository())
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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          // 로딩 상태일 때
          if (state is PostDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // 데이터 로드 완료 상태일 때
          else if (state is PostDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.post.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),
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
