import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasAvatar = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).setupProfile(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        );
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Настройте профиль',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Расскажите немного о себе',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 40),
                // Avatar
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _hasAvatar = !_hasAvatar),
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: _hasAvatar ? AppColors.goldGradient : null,
                            color: _hasAvatar ? null : AppColors.secondaryBackground,
                            border: Border.all(color: AppColors.border, width: 2),
                          ),
                          child: _hasAvatar
                              ? const Center(
                                  child: Text('👤', style: TextStyle(fontSize: 48)),
                                )
                              : const Icon(Icons.person_outline,
                                  color: AppColors.textTertiary, size: 48),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primaryBackground, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: AppColors.primaryBackground, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Добавить фото',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // First name
                const Text(
                  'Имя',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _firstNameController,
                  hint: 'Айгерим',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.isEmpty) ? 'Введите имя' : null,
                ),
                const SizedBox(height: 16),
                // Last name
                const Text(
                  'Фамилия',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _lastNameController,
                  hint: 'Сейткали',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.isEmpty) ? 'Введите фамилию' : null,
                ),
                const Spacer(),
                GoldButton(text: 'Начать', onTap: _submit),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.home),
                    child: const Text(
                      'Пропустить',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

