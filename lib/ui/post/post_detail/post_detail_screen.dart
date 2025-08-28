import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/ui/post/edit_post/edit_post_bloc.dart';
import 'package:blind_clone_flutter/ui/post/edit_post/edit_post_screen.dart';
import 'package:blind_clone_flutter/ui/post/post_detail/post_detail_bloc.dart';
import 'package:blind_clone_flutter/ui/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),

        actions: [
          BlocBuilder<PostDetailBloc, PostDetailState>(
            builder: (context, state) {
              if (state is PostDetailLoaded) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black87),
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
                      // 삭제 확인 다이얼로그
                      final bool? confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('게시물 삭제'),
                            content: const Text('정말로 이 게시물을 삭제하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(false),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(true),
                                child: const Text('삭제'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        context.read<PostDetailBloc>().add(
                          DeletePost(state.post.id),
                        );
                      }
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
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<PostDetailBloc, PostDetailState>(
        listener: (context, state) {
          if (state is PostDeleteSuccess) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('게시물이 성공적으로 삭제되었습니다.')),
              );
            Navigator.of(context).pop(true);
          } else if (state is PostDetailError) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('오류가 발생했습니다: ${state.message}')),
              );
          }
        },
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return Center(child: defaultProgressIndicator());
          } else if (state is PostDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 게시물 제목
                  Text(
                    state.post.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 16),
                  // 게시물 내용
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 100.0),
                    child: Text(
                      state.post.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 좋아요 및 댓글 수
                  Row(
                    children: [
                      const Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "0",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.comment_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "0",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        timeago.format(state.post.createdAt, locale: 'ko'),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    '댓글',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '댓글을 입력해주세요.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCommentTile(
                    '익명',
                    '저도 같은 고민을 하고 있었어요! 좋은 정보 감사합니다.',
                    DateTime.now().subtract(const Duration(minutes: 5)),
                  ),
                  _buildCommentTile(
                    '블라인드 컴퍼니',
                    '이 문제에 대한 해결책은 아직 논의 중입니다. 조금만 기다려주세요.',
                    DateTime.now().subtract(const Duration(hours: 1)),
                  ),
                ],
              ),
            );
          } else if (state is PostDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('오류가 발생했습니다: ${state.message}'),
              ),
            );
          }
          return const Center(child: Text('게시물을 불러오는 중...'));
        },
      ),
    );
  }

  Widget _buildCommentTile(String author, String content, DateTime time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  author.isNotEmpty ? author[0] : '?',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                author,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeago.format(time, locale: 'ko'),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 4.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
