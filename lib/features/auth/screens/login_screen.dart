import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';
import 'package:legalhelp_kz/core/utils/translations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        final error = ref.read(authProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(title: AppTranslations.tr('login', lang)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'С возвращением',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Войдите в свой аккаунт, чтобы продолжить',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  AppTranslations.tr('email_hint', lang),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _emailController,
                  hint: 'example@mail.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Введите email';
                    if (!v.contains('@')) return 'Неверный формат email';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  AppTranslations.tr('password_hint', lang),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Введите пароль';
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                GoldButton(
                  text: AppTranslations.tr('sign_in', lang),
                  isLoading: _isLoading,
                  onTap: _login,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppTranslations.tr('no_account', lang)} ',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text(
                        AppTranslations.tr('register_now', lang),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
