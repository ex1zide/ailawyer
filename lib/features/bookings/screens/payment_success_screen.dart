import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});
  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _c.forward();
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _scale,
                builder: (_, __) => Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.5), blurRadius: 30, spreadRadius: 5)],
                    ),
                    child: const Icon(Icons.check_rounded, color: AppColors.primaryBackground, size: 64),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Оплата прошла успешно!', style: TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.w700, fontFamily: 'Inter'), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text('Юрист получил уведомление\nи свяжется с вами скоро', style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontFamily: 'Inter', height: 1.5), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              // Confirmation details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    const Row(children: [
                      Text('🎉', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Консультация забронирована', style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                    ]),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 12),
                    const Row(children: [
                      Icon(Icons.calendar_today_outlined, color: AppColors.textTertiary, size: 14),
                      SizedBox(width: 8),
                      Text('Подтверждение придёт на телефон', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                    ]),
                    const SizedBox(height: 6),
                    const Row(children: [
                      Icon(Icons.notifications_outlined, color: AppColors.textTertiary, size: 14),
                      SizedBox(width: 8),
                      Text('Напоминание за 1 час до встречи', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter')),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GoldButton(text: 'Мои бронирования', onTap: () => context.go(AppRoutes.myBookings)),
              const SizedBox(height: 12),
              GoldButton(text: 'На главную', isOutlined: true, onTap: () => context.go(AppRoutes.home)),
            ],
          ),
        ),
      ),
    );
  }
}
