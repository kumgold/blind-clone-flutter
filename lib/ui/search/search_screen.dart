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

  // 인기 채널 더미 데이터
  final List<Map<String, dynamic>> _popularChannels = [
    {'name': '자유게시판', 'icon': Icons.chat_bubble_outline},
    {'name': 'IT라운지', 'icon': Icons.computer},
    {'name': '부동산', 'icon': Icons.real_estate_agent},
    {'name': '주식/코인', 'icon': Icons.candlestick_chart},
    {'name': '여행/맛집', 'icon': Icons.card_travel},
  ];

  // 인기 회사 더미 데이터
  final List<Map<String, dynamic>> _popularCompanies = [
    {'name': '삼성전자', 'icon': Icons.business},
    {'name': 'SK하이닉스', 'icon': Icons.business},
    {'name': '네이버', 'icon': Icons.business},
    {'name': '카카오', 'icon': Icons.business},
    {'name': '현대자동차', 'icon': Icons.business},
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
          decoration: InputDecoration(
            hintText: '관심 있는 내용을 검색해보세요.',
            border: InputBorder.none,
            // 검색창 클리어 버튼
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                    : null,
          ),
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) {},
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
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    _recentSearches.map((term) {
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

            // 인기 채널 섹션
            _buildSectionHeader('인기 채널', ''),
            _buildPopularList(_popularChannels, true),

            const Divider(height: 8, thickness: 8, color: Color(0xFFF7F7F7)),

            // 인기 회사 섹션
            _buildSectionHeader('인기 회사', ''),
            _buildPopularList(_popularCompanies, false),
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
            GestureDetector(
              onTap: () {
                if (title == '최근 검색어') {
                  setState(() {
                    _recentSearches.clear();
                  });
                }
              },
              child: Text(
                actionText,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  // 인기 채널 및 회사 리스트를 만드는 위젯
  Widget _buildPopularList(List<Map<String, dynamic>> items, bool isChannel) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: index < 3 ? const Color(0xFF2F55D2) : Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              Icon(item['icon'], color: Colors.black54, size: 22),
            ],
          ),
          title: Text(item['name']),
          onTap: () {
            _searchController.text = item['name'];
          },
        );
      },
    );
  }
}
