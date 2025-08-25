import 'package:blind_clone_flutter/share/channel.dart';
import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/ui/post/add_post/add_post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedChannel;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        channelName: _selectedChannel!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: DateTime.now(),
      );

      context.read<AddPostBloc>().add(UpdatePost(post));
    }
  }

  @override
  Widget build(BuildContext context) {
    final channels = Channel.channels;

    return Scaffold(
      appBar: AppBar(title: const Text('게시글 작성')),
      body: BlocConsumer<AddPostBloc, AddPostState>(
        listener: (context, state) {
          if (state is AddPostSuccess) {
            Navigator.of(context).pop(true);
          } else if (state is AddPostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('오류: ${state.message}')));
          }
        },
        builder: (context, state) {
          final isLoading = state is AddPostLoading;

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
