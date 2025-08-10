import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 수정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 게시글 업데이트 로직 구현
              final title = _titleController.text;
              final content = _contentController.text;
              // 여기서 _image, title, content를 사용하여 서버에 전송하는 등의 작업을 수행할 수 있습니다.
              if (_image != null && title.isNotEmpty && content.isNotEmpty) {
                // 성공적으로 업데이트되었다는 메시지 표시 또는 이전 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('게시글이 성공적으로 업데이트되었습니다.')),
                );
              } else {
                // 사용자에게 모든 필드를 채워달라는 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('사진, 제목, 내용을 모두 입력해주세요.')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 이미지 선택 영역
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11.0),
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
                              Icons.add_a_photo_outlined,
                              size: 60,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '탭하여 사진 추가',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24.0),

              // 제목 입력 필드
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              // 내용 입력 필드
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
