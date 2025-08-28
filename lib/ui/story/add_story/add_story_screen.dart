import 'dart:io';

import 'package:blind_clone_flutter/ui/story/add_story/add_story_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 갤러리에서 이미지를 가져오는 함수
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submit(bool isLoading) {
    if (isLoading) return;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사진을 추가해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddStoryBloc>().add(
        UpdateStory(
          _titleController.text.trim(),
          _contentController.text.trim(),
          _image!,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          '스토리 만들기',
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
          BlocBuilder<AddStoryBloc, AddStoryState>(
            builder: (context, state) {
              final isLoading = state is AddStoryLoading;
              return TextButton(
                onPressed: () => _submit(isLoading),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Text(
                        '등록',
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
      body: BlocListener<AddStoryBloc, AddStoryState>(
        listener: (context, state) {
          if (state is AddStoryResult) {
            // 성공 시 true를 반환하여 홈 화면에서 새로고침 하도록 유도
            Navigator.pop(context, true);
          } else if (state is AddStoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('오류: ${state.errorMessage}')),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 이미지 선택 영역
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 60,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '탭하여 사진 추가',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(height: 1, color: Colors.grey),

                  // 제목 입력 필드
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: '제목',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '제목을 입력하세요'
                        : null,
                  ),
                  const Divider(height: 1, color: Colors.grey),

                  // 내용 입력 필드
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: '내용을 입력하세요',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
