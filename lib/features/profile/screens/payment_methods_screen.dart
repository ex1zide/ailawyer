import 'package:flutter/material.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});
  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    final methods = MockData.paymentMethods;

    String _icon(String type) {
      switch (type) {
        case 'kaspi': return '🟡';
        case 'halyk': return '🟢';
        case 'visa': return '💳';
        default: return '💳';
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'Способы оплаты',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _showAddCard(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
                child: const Icon(Icons.add, color: AppColors.gold, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...methods.map((m) => Dismissible(
              key: Key(m.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: m.isDefault ? AppColors.gold.withOpacity(0.4) : AppColors.border),
                ),
                child: Row(children: [
                  Text(_icon(m.type), style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                      Text(m.maskedNumber, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
                    ]),
                  ),
                  if (m.isDefault)
                    GoldBadge(text: 'Основной')
                  else
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Установлен как основной'))),
                      child: const Text('Сделать основным', style: TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                    ),
                ]),
              ),
            )),
            const SizedBox(height: 16),
            GoldButton(text: '+ Добавить карту', isOutlined: true, onTap: () => _showAddCard(context)),
          ],
        ),
      ),
    );
  }

  void _showAddCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.secondaryBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Добавить карту', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            const SizedBox(height: 16),
            // Quick add options
            Row(children: [
              _QuickAddBtn(icon: '🟡', label: 'Kaspi', onTap: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kaspi добавлен'))); }),
              const SizedBox(width: 12),
              _QuickAddBtn(icon: '🟢', label: 'Halyk', onTap: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Halyk добавлен'))); }),
              const SizedBox(width: 12),
              _QuickAddBtn(icon: '💳', label: 'Карта', onTap: () {}),
            ]),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _QuickAddBtn extends StatelessWidget {
  final String icon, label;
  final VoidCallback onTap;
  const _QuickAddBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
        ]),
      ),
    ),
  );
}
