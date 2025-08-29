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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _contentController.text = widget.post.content;
    _selectedChannel = widget.post.channelName;
  }

  void _submit(bool isLoading) {
    if (isLoading) return;

    if (_formKey.currentState?.validate() ?? false) {
      final post = Post(
        id: widget.post.id,
        channelName: _selectedChannel!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: DateTime.now(),
        company: '네이버',
        likes: 3,
        comments: 3,
      );

      context.read<EditPostBloc>().add(SubmitPostChanges(post));
    }
  }

  @override
  Widget build(BuildContext context) {
    final channels = Channel.channels;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          '글 수정',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<EditPostBloc, EditPostState>(
            builder: (context, state) {
              final isLoading = state is EditPostLoading;
              return TextButton(
                onPressed: () => _submit(isLoading),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Text(
                        '수정',
                        style: TextStyle(
                          color: Color(0xFF2F55D2),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<EditPostBloc, EditPostState>(
        listener: (context, state) {
          if (state is EditPostSuccess) {
            Navigator.pop(context, state.updatedPost);
          } else if (state is EditPostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('오류: ${state.message}')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: '채널 선택',
                    border: InputBorder.none,
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
                const Divider(height: 1, color: Colors.grey),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: '제목',
                    border: InputBorder.none,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? '제목을 입력하세요'
                      : null,
                ),
                const Divider(height: 1, color: Colors.grey),
                Expanded(
                  child: TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: '내용을 입력하세요',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '내용을 입력하세요'
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
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
