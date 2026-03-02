import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class SavedLawyersScreen extends ConsumerWidget {
  const SavedLawyersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedIds = ref.watch(savedLawyersProvider);
    final saved = MockData.lawyers.where((l) => savedIds.contains(l.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Сохранённые юристы'),
      body: saved.isEmpty
          ? const EmptyState(
              icon: '🔖',
              title: 'Нет сохранённых юристов',
              subtitle: 'Сохраняйте юристов для быстрого доступа',
              actionText: 'Найти юристов',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: saved.length,
              itemBuilder: (_, i) {
                final lawyer = saved[i];
                return GestureDetector(
                  onTap: () => context.push('/lawyers/${lawyer.id}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
                          child: Center(child: Text(
                            lawyer.name.split(' ').map((w) => w[0]).take(2).join(),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryBackground, fontFamily: 'Inter'),
                          )),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lawyer.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                              const SizedBox(height: 2),
                              Text(lawyer.specialization, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter'), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Row(children: [StarRating(rating: lawyer.rating, size: 13), const SizedBox(width: 4), Text('от ${lawyer.price} ₸', style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter'))]),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ref.read(savedLawyersProvider.notifier).toggle(lawyer.id),
                          child: const Icon(Icons.bookmark, color: AppColors.gold, size: 22),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
