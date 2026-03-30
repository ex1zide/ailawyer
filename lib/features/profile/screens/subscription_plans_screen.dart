import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class SubscriptionPlansScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansScreen({super.key});
  @override
  ConsumerState<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends ConsumerState<SubscriptionPlansScreen> {
  int _billingIdx = 0; // 0=monthly, 1=yearly

  final _plans = [
    _Plan('Бесплатный', 0, 0, 'free', ['5 AI запросов в день', '3 документа', 'Базовый поиск юристов'], false),
    _Plan('Pro', 2990, 24900, 'pro', ['Неограниченные AI запросы', '∞ документов', 'Приоритетный поиск', 'Скидка 20% на юристов', 'Шаблоны документов'], true),
    _Plan('Business', 7990, 69900, 'business', ['Всё из Pro', 'До 5 пользователей', 'Выделенный юрист', 'API доступ', 'Белая этикетка'], false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Тарифные планы'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          const Center(
            child: Column(children: [
              Text('Выберите план', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
              SizedBox(height: 6),
              Text('Отмените в любое время', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
            ]),
          ),
          const SizedBox(height: 20),
          // Billing toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              _BillingTab(label: 'Ежемесячно', isSelected: _billingIdx == 0, onTap: () => setState(() => _billingIdx = 0)),
              _BillingTab(label: 'Ежегодно  −30%', isSelected: _billingIdx == 1, onTap: () => setState(() => _billingIdx = 1)),
            ]),
          ),
          const SizedBox(height: 20),
          ..._plans.map((plan) => _PlanCard(plan: plan, isYearly: _billingIdx == 1,
            onSelect: () => context.push(AppRoutes.paymentMethods))),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _Plan {
  final String name;
  final int monthlyPrice;
  final int yearlyPrice;
  final String key;
  final List<String> features;
  final bool isPopular;
  const _Plan(this.name, this.monthlyPrice, this.yearlyPrice, this.key, this.features, this.isPopular);
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool isYearly;
  final VoidCallback onSelect;
  const _PlanCard({required this.plan, required this.isYearly, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final price = isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: plan.isPopular ? AppColors.goldGradient : null,
        color: plan.isPopular ? null : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: plan.isPopular ? Colors.transparent : AppColors.border),
      ),
      child: Container(
        margin: plan.isPopular ? const EdgeInsets.all(2) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(plan.isPopular ? 16 : 18),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Row(children: [
                Text(plan.name, style: TextStyle(
                  color: plan.isPopular ? AppColors.gold : AppColors.textPrimary,
                  fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Inter',
                )),
                if (plan.isPopular) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(6)),
                    child: const Text('Популярный', style: TextStyle(color: AppColors.primaryBackground, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                  ),
                ],
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(price == 0 ? 'Бесплатно' : '$price ₸', style: TextStyle(
                  color: plan.isPopular ? AppColors.gold : AppColors.textPrimary,
                  fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter',
                )),
                if (price > 0) Text(isYearly ? 'в год' : 'в мес.', style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
              ]),
            ]),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            ...plan.features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Icon(Icons.check_circle, color: plan.isPopular ? AppColors.gold : AppColors.success, size: 16),
                const SizedBox(width: 8),
                Text(f, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
              ]),
            )),
            const SizedBox(height: 14),
            GoldButton(text: price == 0 ? 'Текущий план' : 'Выбрать ${plan.name}', isOutlined: price == 0, onTap: price == 0 ? () {} : onSelect),
          ],
        ),
      ),
    );
  }
}

class _BillingTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _BillingTab({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.goldGradient : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(label, style: TextStyle(
          color: isSelected ? AppColors.primaryBackground : AppColors.textSecondary,
          fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, fontFamily: 'Inter',
        ))),
      ),
    ),
  );
}

