import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Экстренные контакты'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SOS banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Center(child: Text('🆘', style: TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Нужна срочная помощь?', style: TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                      SizedBox(height: 2),
                      Text('Нажмите на номер для быстрого вызова', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Main emergency numbers
          Row(
            children: [
              _EmergencyTile(number: '102', label: 'Полиция', icon: '🚔', onTap: () => _call('102')),
              const SizedBox(width: 12),
              _EmergencyTile(number: '103', label: 'Скорая', icon: '🚑', onTap: () => _call('103')),
              const SizedBox(width: 12),
              _EmergencyTile(number: '112', label: 'Спасение', icon: '🆘', onTap: () => _call('112')),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Юридические службы'),
          const SizedBox(height: 12),
          ...MockData.emergencyContacts.map((c) => _ContactCard(contact: c, onCall: () => _call(c.phone))),
        ],
      ),
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  final String number, label, icon;
  final VoidCallback onTap;
  const _EmergencyTile({required this.number, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 6),
            Text(number, style: const TextStyle(color: AppColors.error, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'Inter')),
          ],
        ),
      ),
    ),
  );
}

class _ContactCard extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback onCall;
  const _ContactCard({required this.contact, required this.onCall});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Row(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(contact.icon ?? '📞', style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(contact.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                if (contact.isAvailable24h) ...[
                  const SizedBox(width: 6),
                  GoldBadge(text: '24/7', small: true),
                ],
              ]),
              Text(contact.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Inter')),
            ],
          ),
        ),
        GestureDetector(
          onTap: onCall,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withOpacity(0.4)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.call, color: AppColors.success, size: 14),
              const SizedBox(width: 4),
              Text(contact.phone, style: const TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            ]),
          ),
        ),
      ],
    ),
  );
}

