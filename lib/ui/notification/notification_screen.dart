import 'package:flutter/material.dart';

// 알림 유형을 구분하기 위한 Enum
enum NotificationType { comment, popular, announcement }

// 알림 정보를 담을 데이터 클래스
class AppNotification {
  final NotificationType type;
  final String content;
  final String postTitle;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.type,
    required this.content,
    required this.postTitle,
    required this.createdAt,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 알림 더미 데이터
  final List<AppNotification> _notifications = [
    AppNotification(
      type: NotificationType.comment,
      content: "'선배님들 질문있습니다' 글에 새로운 댓글이 달렸습니다.",
      postTitle: "성과급 다들 만족하시나요?",
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    AppNotification(
      type: NotificationType.popular,
      content: "회원님의 글이 인기 게시물로 선정되었습니다!",
      postTitle: "신규 프로젝트 팀원 모집합니다 (AI/ML)",
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      type: NotificationType.announcement,
      content: "[공지] 서버 점검 안내 (오전 2시~4시)",
      postTitle: "서비스 개선을 위한 정기 점검이 진행될 예정입니다.",
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      type: NotificationType.comment,
      content: "'블라인드 개발팀' 님이 댓글을 좋아합니다.",
      postTitle: "카카오뱅크 경력직 면접 후기",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppNotification(
      type: NotificationType.comment,
      content: "'Flutter고수' 님이 회원님을 언급했습니다.",
      postTitle: "네이버 웹툰 작가들 연봉이 궁금해요",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  // 알림 아이콘을 반환하는 함수
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.comment:
        return Icons.chat_bubble_outline_rounded;
      case NotificationType.popular:
        return Icons.star_border_rounded;
      case NotificationType.announcement:
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  // 시간 경과를 계산하여 문자열로 반환하는 함수
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ListView.separated(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationTile(_notifications[index]);
        },
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ),
    );
  }

  // 각 알림 타일을 만드는 위젯
  Widget _buildNotificationTile(AppNotification notification) {
    return Container(
      color: notification.isRead ? Colors.white : Colors.blue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getNotificationIcon(notification.type),
            color: Colors.black54,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.content,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.postTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _formatTimestamp(notification.createdAt),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
