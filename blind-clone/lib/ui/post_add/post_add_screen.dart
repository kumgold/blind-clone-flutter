import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/ui/post_add/post_add_bloc.dart';
import 'package:blind_clone_flutter/ui/post_add/post_add_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({super.key});

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      context.read<PostAddBloc>().add(UpdatePost(post));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글 작성')),
      body: BlocConsumer<PostAddBloc, PostAddState>(
        listener: (context, state) {
          if (state is PostAddSuccess) {
            Navigator.pop(context); // 저장 성공 후 이전 화면으로 이동
          } else if (state is PostAddError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('오류: ${state.message}')));
          }
        },
        builder: (context, state) {
          final isLoading = state is PostAddLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '제목',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '제목을 입력하세요'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: '내용',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? '내용을 입력하세요'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('작성 완료'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
