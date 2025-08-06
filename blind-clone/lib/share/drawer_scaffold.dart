import 'package:blind_clone_flutter/data/channel.dart';
import 'package:blind_clone_flutter/ui/channel_post/channel_post_screen.dart';
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
        title: Text(title),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () => {}, icon: Icon(Icons.chat_rounded)),
          IconButton(onPressed: () => {}, icon: Icon(Icons.person)),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('내 채널'),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      final channel = channels[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChannelPostScreen(channelName: channel),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(
                                  Icons.ac_unit_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(channel),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
