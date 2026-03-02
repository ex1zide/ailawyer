import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Доброе утро';
    if (hour < 18) return 'Добрый день';
    return 'Добрый вечер';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 16, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1500), Color(0xFF0A0A0A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_greeting()}, 👋',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.firstName ?? 'Пользователь',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification bell
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.notifications),
                        child: Stack(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(Icons.notifications_outlined,
                                  color: AppColors.textPrimary, size: 22),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Avatar
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.profile),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              (user.firstName?.isNotEmpty == true)
                                  ? user.firstName![0].toUpperCase()
                                  : '🙂',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBackground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search bar
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Задайте вопрос по законам Казахстана...',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  // Quick Actions
                  const SectionHeader(title: 'Быстрые действия'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.smart_toy_outlined,
                        label: 'AI Юрист',
                        color: AppColors.gold,
                        bgColor: AppColors.borderGold,
                        onTap: () => context.go(AppRoutes.aiChat),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.document_scanner_outlined,
                        label: 'Документы',
                        color: AppColors.info,
                        bgColor: const Color(0xFF151F2D),
                        onTap: () => context.push(AppRoutes.documentLibrary),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.people_outline,
                        label: 'Юристы',
                        color: AppColors.success,
                        bgColor: const Color(0xFF152D1A),
                        onTap: () => context.go(AppRoutes.lawyerMarketplace),
                      ),
                      const SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.folder_outlined,
                        label: 'Дела',
                        color: AppColors.warning,
                        bgColor: const Color(0xFF2D2415),
                        onTap: () => context.push(AppRoutes.myBookings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Categories
                  SectionHeader(
                    title: 'Категории',
                    actionText: 'Все',
                    onAction: () => context.go(AppRoutes.search),
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: MockData.categories.length,
                    itemBuilder: (context, i) {
                      final cat = MockData.categories[i];
                      return GestureDetector(
                        onTap: () => context.go(AppRoutes.lawyerMarketplace),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cat.bgColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cat.color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cat.icon,
                                  style: const TextStyle(fontSize: 30)),
                              const SizedBox(height: 8),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  color: cat.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Recent Questions
                  SectionHeader(
                    title: 'Недавние вопросы',
                    actionText: 'Все',
                    onAction: () => context.go(AppRoutes.aiChat),
                  ),
                  const SizedBox(height: 14),
                  ...MockData.recentQuestions.map((q) => _RecentQuestionCard(
                        question: q['question']!,
                        time: q['time']!,
                        category: q['category']!,
                        onTap: () => context.go(AppRoutes.aiChat),
                      )),
                  const SizedBox(height: 28),

                  // Services
                  const SectionHeader(title: 'Сервисы'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _ServiceCard(
                        icon: '📷',
                        label: 'Сканер',
                        onTap: () => context.push(AppRoutes.documentScanner),
                      ),
                      const SizedBox(width: 12),
                      _ServiceCard(
                        icon: '📰',
                        label: 'Новости',
                        onTap: () => context.push(AppRoutes.legalNews),
                      ),
                      const SizedBox(width: 12),
                      _ServiceCard(
                        icon: '🆘',
                        label: 'SOS',
                        onTap: () => context.push(AppRoutes.emergencyContacts),
                        isHighlighted: true,
                      ),
                      const SizedBox(width: 12),
                      _ServiceCard(
                        icon: '📄',
                        label: 'Файлы',
                        onTap: () => context.push(AppRoutes.documentLibrary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentQuestionCard extends StatelessWidget {
  final String question;
  final String time;
  final String category;
  final VoidCallback onTap;

  const _RecentQuestionCard({
    required this.question,
    required this.time,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.borderGold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.chat_bubble_outline,
                    color: AppColors.gold, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      GoldBadge(text: category, small: true),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.textTertiary, size: 14),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _ServiceCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.error.withOpacity(0.15)
                : AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.error.withOpacity(0.4)
                  : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isHighlighted ? AppColors.error : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
