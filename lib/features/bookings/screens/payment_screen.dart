import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/providers/providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String lawyerId;
  final int price;
  final String dateIso;
  final String typeStr;

  const PaymentScreen({
    super.key, 
    required this.lawyerId, 
    required this.price,
    required this.dateIso,
    required this.typeStr,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedPayment = 'pm001';
  bool _isProcessing = false;

  Future<void> _pay() async {
    setState(() => _isProcessing = true);
    
    try {
      final user = ref.read(authProvider).user;
      if (user == null) throw Exception('Пользователь не авторизован');

      final date = DateTime.tryParse(widget.dateIso) ?? DateTime.now();
      final type = widget.typeStr == 'phone' ? ConsultationType.phone 
                 : widget.typeStr == 'inPerson' ? ConsultationType.inPerson 
                 : ConsultationType.online;

      await ref.read(bookingServiceProvider).createBooking(
        userId: user.id,
        lawyerId: widget.lawyerId,
        dateTime: date,
        type: type,
        price: widget.price,
      );

      if (mounted) context.go(AppRoutes.paymentSuccess);
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка оплаты: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final methods = MockData.paymentMethods;
    final lawyerAsync = ref.watch(lawyerProfileProvider(widget.lawyerId));

    return lawyerAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Ошибка: $e'))),
      data: (lawyer) {
        if (lawyer == null) return const Scaffold(body: Center(child: Text('Юрист не найден')));

        return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Оплата'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Консультация', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
                      Text(lawyer.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                    ],
                  ),
                  const Spacer(),
                  Text('${widget.price} ₸', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Способ оплаты', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            const SizedBox(height: 14),
            ...methods.map((m) {
              final sel = m.id == _selectedPayment;
              String icon = m.type == 'kaspi' ? '🟡' : m.type == 'halyk' ? '🟢' : '💳';
              return GestureDetector(
                onTap: () => setState(() => _selectedPayment = m.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                            Text(m.maskedNumber, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                      if (m.isDefault) GoldBadge(text: 'По умолч.', small: true),
                      const SizedBox(width: 8),
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sel ? AppColors.gold : Colors.transparent,
                          border: Border.all(color: sel ? AppColors.gold : AppColors.border, width: 2),
                        ),
                        child: sel ? const Icon(Icons.check, color: AppColors.primaryBackground, size: 12) : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            // Total
            Row(
              children: [
                const Text('Итого', style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontFamily: 'Inter')),
                const Spacer(),
                Text('${widget.price} ₸', style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
              ],
            ),
            const SizedBox(height: 16),
            GoldButton(text: 'Оплатить', isLoading: _isProcessing, onTap: _pay),
            const SizedBox(height: 8),
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outlined, color: AppColors.textTertiary, size: 12),
                  SizedBox(width: 4),
                  Text('Защищённое SSL-соединение', style: TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}
