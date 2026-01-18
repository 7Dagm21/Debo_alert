import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'design_system.dart';
import 'widgets.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: FBColors.white,
        appBar: AppBar(
          backgroundColor: FBColors.white,
          elevation: 0,
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: FBColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            CircleIconButton(icon: Icons.settings),
            const SizedBox(width: 12),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: FBColors.blue,
                unselectedLabelColor: FBColors.grey,
                indicatorColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: [
                  _Tab(text: 'All'),
                  _Tab(text: 'Unread'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [AllNotificationsTab(), UnreadNotificationsTab()],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String text;
  const _Tab({required this.text});
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(text),
      ),
    );
  }
}

class AllNotificationsTab extends StatelessWidget {
  const AllNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        final now = DateTime.now();
        final time = now.subtract(Duration(hours: index * 2));
        final timeText = DateFormat('h:mm a').format(time);
        final isUnread = index < 5;

        return Container(
          color: isUnread ? FBColors.blue.withOpacity(0.05) : FBColors.white,
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/${index % 2 == 0 ? 'men' : 'women'}/${index + 5}.jpg',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _getNotificationColor(index),
                      shape: BoxShape.circle,
                      border: Border.all(color: FBColors.white, width: 2),
                    ),
                    child: Icon(
                      _getNotificationIcon(index),
                      color: FBColors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: FBColors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: 'User ${index + 1} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: _getNotificationText(index)),
                ],
              ),
            ),
            subtitle: Text(
              timeText,
              style: TextStyle(color: isUnread ? FBColors.blue : FBColors.grey),
            ),
            trailing: const Icon(Icons.more_horiz, color: FBColors.grey),
            onTap: () {},
          ),
        );
      },
    );
  }

  IconData _getNotificationIcon(int index) {
    final icons = [
      Icons.thumb_up,
      Icons.comment,
      Icons.share,
      Icons.person_add,
      Icons.event,
    ];
    return icons[index % icons.length];
  }

  Color _getNotificationColor(int index) {
    final colors = [
      FBColors.blue,
      Colors.green,
      Colors.orange,
      FBColors.blue,
      Colors.red,
    ];
    return colors[index % colors.length];
  }

  String _getNotificationText(int index) {
    final types = [
      'liked your post.',
      'commented on your photo.',
      'shared your post.',
      'sent you a friend request.',
      'is going to an event.',
    ];
    return types[index % types.length];
  }
}

class UnreadNotificationsTab extends StatelessWidget {
  const UnreadNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AllNotificationsTab();
  }
}
