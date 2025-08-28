import 'package:blind_clone_flutter/share/channel.dart';
import 'package:blind_clone_flutter/ui/post/post_channel/post_channel_screen.dart';
import 'package:blind_clone_flutter/ui/story/story_screen.dart';
import 'package:flutter/material.dart';

class DrawerScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const DrawerScaffold({
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final channels = Channel.channels;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.search, color: Colors.black87),
          ),
          IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Colors.black87,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(color: Color(0xFF2F55D2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF2F55D2),
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '익명',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '블라인드 컴퍼니',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '내 정보 관리',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  '내 채널',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (channel != '스토리') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostChannelScreen(channelName: channel),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StoryScreen(),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(
                                channel == '스토리'
                                    ? Icons.camera_alt_outlined
                                    : Icons.people_alt_outlined,
                                color: Colors.black54,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              channel,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Colors.black54,
                  size: 24,
                ),
                title: const Text(
                  '설정',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline_outlined,
                  color: Colors.black54,
                  size: 24,
                ),
                title: const Text(
                  '도움말',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
