import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1500), Color(0xFF0A0A0A)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 88, height: 88,
                        decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)]),
                        child: Center(child: Text(
                          user.firstName?.isNotEmpty == true ? user.firstName![0].toUpperCase() : '👤',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.primaryBackground, fontFamily: 'Inter'),
                        )),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.userProfile),
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(color: AppColors.secondaryBackground, shape: BoxShape.circle, border: Border.all(color: AppColors.border, width: 2)),
                            child: const Icon(Icons.edit, color: AppColors.gold, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(user.fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                  const SizedBox(height: 4),
                  Text(user.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter')),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.textTertiary, size: 14),
                      const SizedBox(width: 4),
                      Text(user.city, style: const TextStyle(color: AppColors.textTertiary, fontSize: 13, fontFamily: 'Inter')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Plan badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: user.plan == SubscriptionPlan.pro ? AppColors.borderGold : AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: user.plan == SubscriptionPlan.pro ? AppColors.gold : AppColors.border),
                    ),
                    child: Text(
                      user.plan == SubscriptionPlan.pro ? '⭐ Pro подписка' : '🆓 Бесплатный план',
                      style: TextStyle(
                        color: user.plan == SubscriptionPlan.pro ? AppColors.gold : AppColors.textSecondary,
                        fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Stats
                  Row(
                    children: [
                      _StatCard(value: '${user.questionsAsked}', label: 'Вопросов'),
                      const SizedBox(width: 12),
                      _StatCard(value: '${user.documentsScanned}', label: 'Документов'),
                      const SizedBox(width: 12),
                      _StatCard(value: '${user.lawyersContacted}', label: 'Юристов'),
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
                children: [
                  // Menu
                  _MenuSection(
                    title: 'Аккаунт',
                    items: [
                      _MenuItem(icon: Icons.person_outline, label: 'Редактировать профиль', onTap: () => context.push(AppRoutes.userProfile)),
                      _MenuItem(icon: Icons.bookmark_outline, label: 'Сохранённые юристы', onTap: () => context.push(AppRoutes.savedLawyers)),
                      _MenuItem(icon: Icons.calendar_today_outlined, label: 'Мои бронирования', onTap: () => context.push(AppRoutes.myBookings)),
                      _MenuItem(icon: Icons.folder_outlined, label: 'Мои документы', onTap: () => context.push(AppRoutes.documentLibrary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Подписка',
                    items: [
                      _MenuItem(icon: Icons.diamond_outlined, label: 'Тарифные планы', onTap: () => context.push(AppRoutes.subscriptionPlans), hasGold: true),
                      _MenuItem(icon: Icons.credit_card_outlined, label: 'Способы оплаты', onTap: () => context.push(AppRoutes.paymentMethods)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Настройки',
                    items: [
                      _MenuItem(icon: Icons.settings_outlined, label: 'Настройки', onTap: () => context.push(AppRoutes.settings)),
                      _MenuItem(icon: Icons.help_outline, label: 'Помощь и поддержка', onTap: () => context.push(AppRoutes.helpSupport)),
                      _MenuItem(icon: Icons.phone_in_talk_outlined, label: 'Экстренные контакты', onTap: () => context.push(AppRoutes.emergencyContacts)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sign out
                  GestureDetector(
                    onTap: () {
                      ref.read(authProvider.notifier).signOut();
                      context.go(AppRoutes.phoneAuth);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_outlined, color: AppColors.error, size: 18),
                          SizedBox(width: 8),
                          Text('Выйти из аккаунта', style: TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                        ],
                      ),
                    ),
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (b) => AppColors.goldGradient.createShader(b),
              child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter', letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(
            children: List.generate(items.length, (i) {
              final item = items[i];
              return Column(
                children: [
                  item,
                  if (i < items.length - 1) const Divider(height: 1, color: AppColors.border, indent: 52),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasGold;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.hasGold = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: hasGold ? AppColors.gold : AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(color: hasGold ? AppColors.gold : AppColors.textPrimary, fontSize: 14, fontFamily: 'Inter'))),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 13),
          ],
        ),
      ),
    );
  }
}
