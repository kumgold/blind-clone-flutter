import 'package:flutter/material.dart';

// 실시간 인기글 데이터 모델
class PopularPost {
  final int rank;
  final String title;
  final String channelName;

  PopularPost({
    required this.rank,
    required this.title,
    required this.channelName,
  });
}

// 채널 정보 데이터 모델
class Channel {
  final IconData icon;
  final String name;
  final String description;

  Channel({required this.icon, required this.name, required this.description});
}

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  int _selectedTabIndex = 0;

  // '탐색' - 실시간 인기글 데이터
  final List<PopularPost> _popularPosts = [
    PopularPost(rank: 1, title: '이번 신입들 역대급이네요', channelName: '블라블라'),
    PopularPost(rank: 2, title: '성과급 협상 다들 어떻게 하셨나요?', channelName: '이직/커리어'),
    PopularPost(rank: 3, title: '미국 주식 지금 들어가도 될까요?', channelName: '주식/투자'),
    PopularPost(rank: 4, title: '개발자 신입 로드맵 질문', channelName: 'IT 라운지'),
  ];

  // '탐색' - 채널 추천 데이터
  final List<Channel> _recommendedChannels = [
    Channel(
      icon: Icons.local_fire_department,
      name: '블라블라',
      description: '자유롭게 얘기하는 익명 소통 공간',
    ),
    Channel(
      icon: Icons.developer_mode,
      name: 'IT 라운지',
      description: 'IT 업계 사람들의 자유로운 소통 공간',
    ),
    Channel(
      icon: Icons.work_outline,
      name: '이직/커리어',
      description: '더 나은 커리어를 위한 이직 준비',
    ),
  ];

  // '내 채널' 데이터
  final List<Channel> _myCompanyChannels = [
    Channel(
      icon: Icons.business_center,
      name: '삼성전자',
      description: '삼성전자 재직자들의 익명 커뮤니티',
    ),
  ];

  // '팔로우 채널' 데이터
  final List<Channel> _followedChannels = [
    Channel(
      icon: Icons.bar_chart,
      name: '주식/투자',
      description: '성공적인 투자를 위한 정보 공유',
    ),
    Channel(icon: Icons.memory, name: '반도체', description: '반도체 업계 종사자들의 소통 공간'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [_buildExplorePage(), _buildMyChannelsPage()],
            ),
          ),
        ],
      ),
    );
  }

  // 커스텀 탭 바 위젯
  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 50,
      child: Row(
        children: [
          _buildTabItem('탐색', 0),
          const SizedBox(width: 20),
          _buildTabItem('내 채널', 1),
        ],
      ),
    );
  }

  // 탭 바의 각 아이템
  Widget _buildTabItem(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent, // 탭 영역 확장을 위해
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (isSelected)
              Container(height: 2, width: 40, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // '탐색' 페이지 위젯
  Widget _buildExplorePage() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPopularPostsSection(),
            const SizedBox(height: 8),
            _buildRecommendedChannelsSection(),
          ],
        ),
      ),
    );
  }

  // '탐색' - 실시간 인기글 섹션
  Widget _buildPopularPostsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '실시간 인기글',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _popularPosts
                  .map((post) => _buildPopularPostTile(post))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // '탐색' - 실시간 인기글 타일
  Widget _buildPopularPostTile(PopularPost post) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${post.rank}. ${post.title}',
            style: const TextStyle(fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            post.channelName,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // '탐색' - 채널 추천 섹션
  Widget _buildRecommendedChannelsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '채널 추천',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _recommendedChannels.length,
            itemBuilder: (context, index) {
              return _buildRecommendedChannelTile(_recommendedChannels[index]);
            },
          ),
        ],
      ),
    );
  }

  // '탐색' - 채널 추천 타일
  Widget _buildRecommendedChannelTile(Channel channel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(channel.icon, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  channel.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('팔로우'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  // '내 채널' 페이지 위젯
  Widget _buildMyChannelsPage() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            _buildChannelSection('내 채널', _myCompanyChannels),
            const SizedBox(height: 8),
            _buildChannelSection('팔로우 채널', _followedChannels),
          ],
        ),
      ),
    );
  }

  // '내 채널' 페이지의 공통 섹션 (내 채널, 팔로우 채널)
  Widget _buildChannelSection(String title, List<Channel> channels) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: channels.length,
            itemBuilder: (context, index) {
              return _buildMyChannelTile(channels[index]);
            },
          ),
        ],
      ),
    );
  }

  // '내 채널' 페이지의 채널 타일
  Widget _buildMyChannelTile(Channel channel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(channel.icon, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  channel.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
