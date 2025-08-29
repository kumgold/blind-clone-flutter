import 'package:flutter/material.dart';

// 채용 공고 정보를 담을 데이터 클래스
class JobPosting {
  final String companyLogoUrl;
  final String title;
  final String companyName;
  final String responseRate;
  final String location;
  final String compensation;
  final bool isBookmarked;

  JobPosting({
    required this.companyLogoUrl,
    required this.title,
    required this.companyName,
    required this.responseRate,
    required this.location,
    required this.compensation,
    this.isBookmarked = false,
  });
}

class RecruitScreen extends StatefulWidget {
  const RecruitScreen({super.key});

  @override
  State<RecruitScreen> createState() => _RecruitScreenState();
}

class _RecruitScreenState extends State<RecruitScreen> {
  // 채용 공고 더미 데이터
  final List<JobPosting> _jobPostings = [
    JobPosting(
      companyLogoUrl: 'https://picsum.photos/seed/samsung/200',
      title: 'AI/ML 백엔드 엔지니어',
      companyName: '삼성전자',
      responseRate: '응답률 매우 높음',
      location: '서울 · 한국',
      compensation: '채용보상금 1,000,000원',
      isBookmarked: true,
    ),
    JobPosting(
      companyLogoUrl: 'https://picsum.photos/seed/kakao/200',
      title: '클라우드 플랫폼 개발자 (경력)',
      companyName: '카카오',
      responseRate: '응답률 보통',
      location: '성남 · 한국',
      compensation: '채용보상금 1,500,000원',
    ),
    JobPosting(
      companyLogoUrl: 'https://picsum.photos/seed/naver/200',
      title: 'FE 개발자 (웹툰 서비스)',
      companyName: '네이버',
      responseRate: '응답률 높음',
      location: '성남 · 한국',
      compensation: '채용보상금 1,000,000원',
    ),
    JobPosting(
      companyLogoUrl: 'https://picsum.photos/seed/sk/200',
      title: '데이터 사이언티스트 (신입/경력)',
      companyName: 'SK하이닉스',
      responseRate: '응답률 매우 높음',
      location: '이천 · 한국',
      compensation: '채용보상금 2,000,000원',
      isBookmarked: true,
    ),
    JobPosting(
      companyLogoUrl: 'https://picsum.photos/seed/coupang/200',
      title: '안드로이드 개발자',
      companyName: '쿠팡',
      responseRate: '응답률 보통',
      location: '서울 · 한국',
      compensation: '채용보상금 1,000,000원',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildFilterBar(),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(child: _buildJobPostingList()),
        ],
      ),
    );
  }

  // 필터 바 위젯
  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildFilterChip('전체'),
          _buildFilterChip('지역', hasDropdown: true),
          _buildFilterChip('경력', hasDropdown: true),
          _buildFilterChip('기술스택', hasDropdown: true),
          _buildFilterChip('응답률순', hasDropdown: true),
        ],
      ),
    );
  }

  // 각 필터 버튼 위젯
  Widget _buildFilterChip(String label, {bool hasDropdown = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (hasDropdown) const Icon(Icons.arrow_drop_down, size: 20.0),
        ],
      ),
    );
  }

  // 채용 공고 리스트 위젯
  Widget _buildJobPostingList() {
    return ListView.separated(
      itemCount: _jobPostings.length,
      itemBuilder: (context, index) {
        return _buildJobPostingTile(_jobPostings[index]);
      },
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
    );
  }

  // 각 채용 공고 타일 위젯
  Widget _buildJobPostingTile(JobPosting post) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              post.companyLogoUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      post.companyName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.responseRate,
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  post.location,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  post.compensation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2F55D2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: post.isBookmarked ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              // 북마크 기능 구현
            },
          ),
        ],
      ),
    );
  }
}
