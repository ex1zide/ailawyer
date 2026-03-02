import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});
  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).setupProfile(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Row(children: [Text('✅ '), Text('Профиль сохранён')])),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'Редактировать профиль',
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Сохранить', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3), blurRadius: 16)]),
                    child: Center(child: Text(
                      user.firstName?.isNotEmpty == true ? user.firstName![0].toUpperCase() : '👤',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.primaryBackground),
                    )),
                  ),
                  Positioned(bottom: 0, right: 0,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryBackground, width: 2)),
                      child: const Icon(Icons.camera_alt, color: AppColors.primaryBackground, size: 14),
                    )),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const _Label('Имя'),
            AppTextField(controller: _firstNameController, hint: 'Айгерим',
              validator: (v) => (v == null || v.isEmpty) ? 'Обязательное поле' : null),
            const SizedBox(height: 16),
            const _Label('Фамилия'),
            AppTextField(controller: _lastNameController, hint: 'Сейткали',
              validator: (v) => (v == null || v.isEmpty) ? 'Обязательное поле' : null),
            const SizedBox(height: 16),
            const _Label('Телефон'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Text(user.phone, style: const TextStyle(color: AppColors.textTertiary, fontSize: 15)),
            ),
            const SizedBox(height: 16),
            const _Label('Город'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                const Icon(Icons.location_on_outlined, color: AppColors.textTertiary, size: 18),
                const SizedBox(width: 10),
                Text(user.city, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
              ]),
            ),
            const SizedBox(height: 28),
            GoldButton(text: 'Сохранить изменения', onTap: _save),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
  );
}
