import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

import 'package:legalhelp_kz/providers/providers.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.upcoming: return AppColors.gold;
      case BookingStatus.completed: return AppColors.success;
      case BookingStatus.cancelled: return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'Мои бронирования',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              indicatorColor: AppColors.gold,
              labelColor: AppColors.gold,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              tabs: const [Tab(text: 'Предстоящие'), Tab(text: 'Прошедшие')],
            ),
          ),
        ],
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (err, _) => Center(child: Text('Ошибка загрузки: $err', style: const TextStyle(color: AppColors.error))),
        data: (bookings) {
          final upcoming = bookings.where((b) => b.status == BookingStatus.upcoming).toList();
          final past = bookings.where((b) => b.status != BookingStatus.upcoming).toList();

          return TabBarView(
            controller: _tab,
            children: [
              _BookingList(bookings: upcoming, statusColor: _statusColor),
              _BookingList(bookings: past, statusColor: _statusColor),
            ],
          );
        },
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final Color Function(BookingStatus) statusColor;
  const _BookingList({required this.bookings, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final monthNames = ['', 'янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];

    if (bookings.isEmpty) {
      return const EmptyState(icon: '📅', title: 'Нет бронирований', subtitle: 'Запишитесь к юристу прямо сейчас');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (_, i) {
        final b = bookings[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
                    child: Center(child: Text(b.lawyer.name.split(' ').map((w) => w[0]).take(2).join(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryBackground, fontFamily: 'Inter'))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.lawyer.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        Text(b.lawyer.specialization, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter'), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: statusColor(b.status).withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(b.statusLabel, style: TextStyle(color: statusColor(b.status), fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _BookingInfo(icon: Icons.calendar_today_outlined, text: '${b.dateTime.day} ${monthNames[b.dateTime.month]} ${b.dateTime.year}'),
                  const SizedBox(width: 16),
                  _BookingInfo(icon: Icons.access_time_outlined, text: '${b.dateTime.hour.toString().padLeft(2,'0')}:${b.dateTime.minute.toString().padLeft(2,'0')}'),
                  const SizedBox(width: 16),
                  _BookingInfo(icon: Icons.videocam_outlined, text: b.typeLabel),
                  const Spacer(),
                  Text('${b.price} ₸', style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BookingInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BookingInfo({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: AppColors.textTertiary, size: 13),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
    ],
  );
}

