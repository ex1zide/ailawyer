import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class LawyerProfileScreen extends ConsumerWidget {
  final String lawyerId;
  const LawyerProfileScreen({super.key, required this.lawyerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawyerAsync = ref.watch(lawyerProfileProvider(lawyerId));
    final reviewsAsync = ref.watch(reviewsProvider(lawyerId));
    final savedIds = ref.watch(savedLawyersProvider);
    final savedNotifier = ref.read(savedLawyersProvider.notifier);

    return lawyerAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: EmptyState(icon: '⚠️', title: 'Ошибка загрузки', subtitle: err.toString()),
      ),
      data: (lawyer) {
        final isSaved = savedIds.contains(lawyer.id);
        
        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          body: CustomScrollView(
            slivers: [
              // Hero header
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 28),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1500), Color(0xFF0A0A0A)],
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 16),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => savedNotifier.toggle(lawyer.id),
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                              child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline,
                                  color: isSaved ? AppColors.gold : AppColors.textPrimary, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Stack(
                        children: [
                          Container(
                            width: 96, height: 96,
                            decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 20)]),
                            child: Center(child: Text(
                              lawyer.name.split(' ').map((w) => w[0]).take(2).join(),
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primaryBackground, fontFamily: 'Inter'),
                            )),
                          ),
                          if (lawyer.isOnline)
                            Positioned(
                              bottom: 2, right: 2,
                              child: Container(
                                width: 18, height: 18,
                                decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryBackground, width: 2)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lawyer.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                          if (lawyer.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, color: AppColors.gold, size: 20),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(lawyer.specialization, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter'), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StarRating(rating: lawyer.rating, size: 16),
                          const SizedBox(width: 8),
                          Text('${lawyer.reviewCount} отзывов', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                          const SizedBox(width: 12),
                          Container(width: 1, height: 14, color: AppColors.border),
                          const SizedBox(width: 12),
                          Text(lawyer.isOnline ? '🟢 Онлайн' : '⚫ Офлайн',
                              style: TextStyle(color: lawyer.isOnline ? AppColors.success : AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Stats row
                      Row(
                        children: [
                          _StatItem(value: '${lawyer.experience}+', label: 'Лет опыта'),
                          _StatItem(value: '${lawyer.casesWon}+', label: 'Дел выиграно'),
                          _StatItem(value: '${(lawyer.rating * 20).round()}%', label: 'Успех'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // About
                      const Text('О юристе', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                      const SizedBox(height: 8),
                      Text(lawyer.about ?? 'Опытный юрист с многолетним стажем.', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter', height: 1.6)),
                      const SizedBox(height: 20),
                      // Categories
                      const Text('Специализации', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: lawyer.categories.map((c) => GoldBadge(text: c)).toList(),
                      ),
                      const SizedBox(height: 20),
                      // Price
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withValues(alpha: 0.3))),
                        child: Row(
                          children: [
                            const Text('💰 Стоимость консультации', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                            const Spacer(),
                            Text('от ${lawyer.price} ₸', style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Reviews
                      reviewsAsync.when(
                        loading: () => const Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: AppColors.gold),
                        )),
                        error: (err, _) => Text('Ошибка загрузки отзывов: $err', style: const TextStyle(color: AppColors.error)),
                        data: (reviews) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(title: 'Отзывы (${reviews.length})'),
                            const SizedBox(height: 12),
                            ...reviews.map((r) => _ReviewCard(review: r)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            decoration: const BoxDecoration(
              color: AppColors.secondaryBackground,
              border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: GoldButton(text: '📅  Записаться на консультацию', onTap: () => context.push('/booking/${lawyer.id}')),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppColors.goldGradient.createShader(b),
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter'), textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.surfaceColor, shape: BoxShape.circle),
              child: Center(child: Text(review.authorName[0], style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter'))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(review.authorName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter'))),
            StarRating(rating: review.rating, size: 13),
          ],
        ),
        const SizedBox(height: 8),
        Text(review.comment, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter', height: 1.5)),
        const SizedBox(height: 4),
        Text(
          '${review.createdAt.day}.${review.createdAt.month.toString().padLeft(2,'0')}.${review.createdAt.year}',
          style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter'),
        ),
      ],
    ),
  );
}
