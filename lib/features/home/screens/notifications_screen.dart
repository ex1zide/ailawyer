import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    IconData _icon(NotificationType t) {
      switch (t) {
        case NotificationType.booking: return Icons.calendar_today_outlined;
        case NotificationType.chat: return Icons.chat_bubble_outline;
        case NotificationType.promo: return Icons.local_offer_outlined;
        default: return Icons.notifications_outlined;
      }
    }

    Color _iconColor(NotificationType t) {
      switch (t) {
        case NotificationType.booking: return AppColors.info;
        case NotificationType.chat: return AppColors.gold;
        case NotificationType.promo: return AppColors.success;
        default: return AppColors.textSecondary;
      }
    }

    String _timeAgo(DateTime dt) {
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} мин. назад';
      if (diff.inHours < 24) return '${diff.inHours} ч. назад';
      return '${diff.inDays} дн. назад';
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'Уведомления',
        actions: [
          TextButton(
            onPressed: notifier.markAllRead,
            child: const Text('Прочитать всё', style: TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 13)),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyState(
              icon: '🔔',
              title: 'Нет уведомлений',
              subtitle: 'Здесь будут появляться важные обновления',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                final n = notifications[i];
                return Dismissible(
                  key: Key(n.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppColors.error.withOpacity(0.15),
                    child: const Icon(Icons.delete_outline, color: AppColors.error),
                  ),
                  onDismissed: (_) => notifier.remove(n.id),
                  child: GestureDetector(
                    onTap: () => notifier.markAsRead(n.id),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: n.isRead ? AppColors.secondaryBackground : AppColors.borderGold,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: n.isRead ? AppColors.border : AppColors.gold.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _iconColor(n.type).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_icon(n.type), color: _iconColor(n.type), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(n.title, style: const TextStyle(
                                        color: AppColors.textPrimary, fontSize: 14,
                                        fontWeight: FontWeight.w600, fontFamily: 'Inter',
                                      )),
                                    ),
                                    if (!n.isRead)
                                      Container(
                                        width: 8, height: 8,
                                        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(n.body, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter', height: 1.4)),
                                const SizedBox(height: 6),
                                Text(_timeAgo(n.timestamp), style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
