import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Настройки'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(title: 'Уведомления', items: [
            _SwitchItem(label: 'Push-уведомления', icon: Icons.notifications_outlined,
              value: settings.pushNotifications, onChanged: (_) => notifier.togglePushNotifications()),
            _SwitchItem(label: 'Email-уведомления', icon: Icons.email_outlined,
              value: settings.emailNotifications, onChanged: (_) => notifier.toggleEmailNotifications()),
          ]),
          const SizedBox(height: 16),
          _SettingsSection(title: 'Безопасность', items: [
            _SwitchItem(label: 'Биометрическая аутентификация', icon: Icons.fingerprint,
              value: settings.biometricAuth, onChanged: (_) => notifier.toggleBiometric()),
          ]),
          const SizedBox(height: 16),
          _SettingsSection(title: 'Язык', items: [
            _RadioItem(label: 'Русский', value: 'ru', groupValue: settings.language,
              onChanged: (v) => notifier.setLanguage(v!)),
            _RadioItem(label: 'Қазақша', value: 'kk', groupValue: settings.language,
              onChanged: (v) => notifier.setLanguage(v!)),
          ]),
          const SizedBox(height: 16),
          _SettingsSection(title: 'О приложении', items: [
            _InfoItem(label: 'Версия', value: '1.0.0'),
            _InfoItem(label: 'Условия использования', value: '', hasArrow: true),
            _InfoItem(label: 'Политика конфиденциальности', value: '', hasArrow: true),
            _InfoItem(label: 'Лицензии', value: '', hasArrow: true),
          ]),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _SettingsSection({required this.title, required this.items});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(), style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, fontFamily: 'Inter')),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          children: List.generate(items.length, (i) => Column(
            children: [items[i], if (i < items.length - 1) const Divider(height: 1, color: AppColors.border, indent: 50)],
          )),
        ),
      ),
    ],
  );
}

class _SwitchItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchItem({required this.label, required this.icon, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(children: [
      Icon(icon, color: AppColors.textSecondary, size: 20),
      const SizedBox(width: 14),
      Expanded(child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'Inter'))),
      Switch(value: value, onChanged: onChanged, activeColor: AppColors.gold, activeTrackColor: AppColors.borderGold),
    ]),
  );
}

class _RadioItem extends StatelessWidget {
  final String label, value, groupValue;
  final ValueChanged<String?> onChanged;
  const _RadioItem({required this.label, required this.value, required this.groupValue, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(children: [
      Radio<String>(value: value, groupValue: groupValue, onChanged: onChanged, activeColor: AppColors.gold),
      Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'Inter')),
    ]),
  );
}

class _InfoItem extends StatelessWidget {
  final String label, value;
  final bool hasArrow;
  const _InfoItem({required this.label, required this.value, this.hasArrow = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'Inter'))),
      if (value.isNotEmpty) Text(value, style: const TextStyle(color: AppColors.textTertiary, fontSize: 13, fontFamily: 'Inter')),
      if (hasArrow) const Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 13),
    ]),
  );
}
