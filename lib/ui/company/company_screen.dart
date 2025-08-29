import 'package:blind_clone_flutter/data/post.dart';
import 'package:blind_clone_flutter/ui/widget/post.dart';
import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  // '내 회사' 탭을 위한 더미 데이터
  final List<Post> _myCompanyPosts = [
    Post(
      id: '0',
      channelName: 'IT 엔지니어',
      title: '이번 성과급 다들 만족하시나요?',
      content: '작년보다 확실히 줄어든 것 같은데, 다른 분들은 어떠신지 궁금합니다. 협상 여지가 있을까요?',
      company: '삼성전자',
      createdAt: DateTime.now(),
      likes: 32,
      comments: 18,
    ),
    Post(
      id: '1',
      channelName: 'IT 엔지니어',
      title: '신규 프로젝트 팀원 모집합니다 (AI/ML)',
      content: '사내 신규 AI 모델 개발 프로젝트에 합류하실 분들을 찾습니다. 경력 무관하며 열정만 있다면 환영합니다!',
      company: '삼성전자',
      createdAt: DateTime.now(),
      likes: 55,
      comments: 29,
    ),
  ];

  // '팔로잉 회사' 탭을 위한 더미 데이터
  final List<Post> _followingCompanyPosts = [
    Post(
      id: '0',
      channelName: '커리어',
      title: '네이버 웹툰 작가들 연봉이 궁금해요',
      content: '최근에 웹툰 산업이 엄청나게 성장했다고 들었는데, 최상위권 작가들은 어느 정도 받는지 아시는 분 있나요?',
      company: '네이버',
      createdAt: DateTime.now(),
      likes: 88,
      comments: 41,
    ),
    Post(
      id: '1',
      channelName: '커리어',
      title: '카카오뱅크 경력직 면접 후기',
      content: '오늘 경력직 면접 보고 왔습니다. 기술 질문보다는 컬쳐핏 위주로 많이 물어보시네요. 준비하시는 분들 참고하세요.',
      company: '카카오',
      createdAt: DateTime.now(),
      likes: 120,
      comments: 64,
    ),
    Post(
      id: '2',
      channelName: 'IT 엔지니어',
      title: 'SK하이닉스도 재택근무 확대하나요?',
      content: '최근 다른 대기업들이 재택근무를 확대하는 추세인데, 저희도 관련 계획이 있는지 아시는 분 계신가요?',
      company: 'SK하이닉스',
      createdAt: DateTime.now(),
      likes: 40,
      comments: 22,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [Tab(text: '내 회사'), Tab(text: '팔로잉 회사')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPostList(_myCompanyPosts),
                  _buildPostList(_followingCompanyPosts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 게시글 리스트를 만드는 위젯
  Widget _buildPostList(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text('표시할 게시글이 없습니다.'));
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostTile(post: posts[index]);
      },
    );
  }
}
