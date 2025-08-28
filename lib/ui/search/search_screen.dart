import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  // 더미 데이터
  final List<String> _recentSearches = ['Flutter', '채용', '이직', '연봉'];
  final List<String> _popularSearches = [
    '삼성전자',
    'SK하이닉스',
    '성과급',
    '네이버',
    '카카오',
    '현대자동차',
    '재택근무',
    '주식',
    '육아휴직',
    '쿠팡',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        // 뒤로가기 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // 검색창
        title: TextField(
          controller: _searchController,
          autofocus: true, // 페이지 진입 시 자동으로 포커스
          decoration: InputDecoration(
            hintText: '관심 있는 내용을 검색해보세요.',
            border: InputBorder.none,
            // 검색창 클리어 버튼
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
              onPressed: () => _searchController.clear(),
            ),
          ),
          onSubmitted: (value) {
            // 엔터 키를 눌렀을 때의 검색 로직
            print('검색어: $value');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 최근 검색어 섹션
            _buildSectionHeader('최근 검색어', '전체삭제'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0, // 태그 간의 가로 간격
                runSpacing: 8.0, // 태그 간의 세로 간격
                children: _recentSearches.map((term) {
                  return Chip(
                    label: Text(term),
                    onDeleted: () {
                      setState(() {
                        _recentSearches.remove(term);
                      });
                    },
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF7F7F7)),

            // 인기 검색어 섹션
            _buildSectionHeader('인기 검색어', ''),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _popularSearches.length,
              itemBuilder: (context, index) {
                final term = _popularSearches[index];
                return ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: index < 3
                          ? const Color(0xFF2F55D2)
                          : Colors.black87,
                    ),
                  ),
                  title: Text(term),
                  onTap: () {
                    // 인기 검색어 클릭 시 검색 로직
                    _searchController.text = term;
                    print('검색어: $term');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 섹션 헤더를 만드는 위젯
  Widget _buildSectionHeader(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (actionText.isNotEmpty)
            Text(
              actionText,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
