import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/share/channel.dart';
import 'package:blind_clone_flutter/ui/post/edit_post/edit_post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedChannel;

  // initState에서 컨트롤러와 변수의 초기값을 설정
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _contentController.text = widget.post.content;
    _selectedChannel = widget.post.channelName;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // 기존 post의 id를 사용하여 새로운 객체 생성
      final post = Post(
        id: widget.post.id,
        channelName: _selectedChannel!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      context.read<EditPostBloc>().add(SubmitPostChanges(post));
    }
  }

  @override
  Widget build(BuildContext context) {
    final channels = Channel.channels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('글 수정하기'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<EditPostBloc, EditPostState>(
        listener: (context, state) {
          if (state is EditPostSuccess) {
            Navigator.pop(context, state.updatedPost);
          } else if (state is EditPostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('오류: ${state.message}')));
          }
        },
        builder: (context, state) {
          final isLoading = state is EditPostLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '제목을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '제목을 입력하세요'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '채널을 선택하세요',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedChannel,
                    items: channels
                        .map(
                          (channel) => DropdownMenuItem(
                            value: channel,
                            child: Text(channel),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedChannel = value;
                      });
                    },
                    validator: (value) => value == null ? '채널을 선택해주세요' : null,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: '내용을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('수정 완료'),
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
