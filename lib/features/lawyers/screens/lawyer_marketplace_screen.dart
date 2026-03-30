import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';
import 'package:legalhelp_kz/widgets/common/shimmer_loading.dart';
import 'package:legalhelp_kz/widgets/common/error_widget.dart';

class LawyerMarketplaceScreen extends ConsumerWidget {
  const LawyerMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(lawyersFilterProvider);
    final filterNotifier = ref.read(lawyersFilterProvider.notifier);

    final categories = ['Все', 'ДТП', 'Трудовое', 'Семейное', 'Недвижимость', 'Бизнес'];
    final sortOptions = [
      ('Рейтинг', 'rating'),
      ('Цена ↑', 'price_asc'),
      ('Цена ↓', 'price_desc'),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Юристы', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Inter')),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.savedLawyers),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      child: const Icon(Icons.bookmark_outline, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Sort menu
                  PopupMenuButton<String>(
                    color: AppColors.secondaryBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                    itemBuilder: (_) => sortOptions.map((o) => PopupMenuItem(
                      value: o.$2,
                      child: Text(o.$1, style: TextStyle(
                        color: filter.sortBy == o.$2 ? AppColors.gold : AppColors.textPrimary,
                        fontFamily: 'Inter', fontSize: 14,
                      )),
                    )).toList(),
                    onSelected: filterNotifier.setSortBy,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      child: const Icon(Icons.tune_outlined, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Category filters
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final sel = categories[i] == filter.category;
                  return GestureDetector(
                    onTap: () => filterNotifier.setCategory(categories[i]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                      ),
                      child: Center(
                        child: Text(categories[i], style: TextStyle(
                          color: sel ? AppColors.gold : AppColors.textSecondary,
                          fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontFamily: 'Inter',
                        )),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            // Results count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ref.watch(lawyersProvider).when(
                data: (lawyers) => Text('${lawyers.length} юристов найдено', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                loading: () => const SizedBox.shrink(),
                error: (err, _) => const Text('Ошибка загрузки', style: TextStyle(color: AppColors.error, fontSize: 13, fontFamily: 'Inter')),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ref.watch(lawyersProvider).when(
                data: (lawyers) => lawyers.isEmpty
                    ? const EmptyState(icon: '🔍', title: 'Юристы не найдены', subtitle: 'Попробуйте другую категорию')
                    : RefreshIndicator(
                        color: AppColors.gold,
                        backgroundColor: AppColors.secondaryBackground,
                        onRefresh: () async => ref.invalidate(lawyersProvider),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: lawyers.length,
                          itemBuilder: (_, i) => _LawyerCard(lawyer: lawyers[i]),
                        ),
                      ),
                loading: () => const LawyerListSkeleton(),
                error: (err, _) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(lawyersProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LawyerCard extends ConsumerWidget {
  final Lawyer lawyer;
  const _LawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedIds = ref.watch(savedLawyersProvider);
    final isSaved = savedIds.contains(lawyer.id);
    final savedNotifier = ref.read(savedLawyersProvider.notifier);

    return GestureDetector(
      onTap: () => context.push('/lawyers/${lawyer.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Stack(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(
                    lawyer.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primaryBackground, fontFamily: 'Inter'),
                  )),
                ),
                if (lawyer.isOnline)
                  Positioned(
                    bottom: 2, right: 2,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success, shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondaryBackground, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(lawyer.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                      ),
                      if (lawyer.isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(6)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: AppColors.gold, size: 10),
                              SizedBox(width: 2),
                              Text('Верифицирован', style: TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(lawyer.specialization, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter'), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StarRating(rating: lawyer.rating),
                      const SizedBox(width: 4),
                      Text('(${lawyer.reviewCount})', style: const TextStyle(color: AppColors.textTertiary, fontSize: 12, fontFamily: 'Inter')),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, color: AppColors.textTertiary, size: 12),
                      const SizedBox(width: 2),
                      Text('${lawyer.distance} км', style: const TextStyle(color: AppColors.textTertiary, fontSize: 12, fontFamily: 'Inter')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'от ${lawyer.price} ₸',
                          style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                        ),
                      ),
                      // Save button
                      GestureDetector(
                        onTap: () => savedNotifier.toggle(lawyer.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSaved ? AppColors.borderGold : AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSaved ? AppColors.gold.withOpacity(0.4) : AppColors.border),
                          ),
                          child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline,
                              color: isSaved ? AppColors.gold : AppColors.textTertiary, size: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Book button
                      GestureDetector(
                        onTap: () => context.push('/booking/${lawyer.id}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(10)),
                          child: const Text('Записаться', style: TextStyle(color: AppColors.primaryBackground, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

