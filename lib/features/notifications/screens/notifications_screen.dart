import 'package:flutter/material.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/shell_scaffold.dart';
import '../../../data/mock_data.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;

    return ShellScaffold(
      appBar: LandscapeShellScope.of(context) ? null : AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + kFloatingNavHeight + kFloatingNavGap,
              ),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) => NotificationCard(
                key: ValueKey('notification-$index'),
                notification: notifications[index],
              ),
            ),
    );
  }
}
