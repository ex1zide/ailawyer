import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final auth = ref.read(authProvider.notifier);
      final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      await auth.sendOtp(phone);
      if (mounted) context.push('${AppRoutes.smsVerification}?phone=$phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

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
                GestureDetector(
                  onTap: () => context.go(AppRoutes.onboarding),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary, size: 18),
                  ),
                ),
                const SizedBox(height: 40),
                // Logo
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('⚖️', style: TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Войти в\nLegalHelp KZ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Введите номер телефона для получения кода',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 40),
                // Phone input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('🇰🇿', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            const Text(
                              '+7',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.textTertiary, size: 18),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            PhoneInputFormatter(),
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Введите номер телефона';
                            if (v.replaceAll(RegExp(r'\D'), '').length < 10) {
                              return 'Неверный формат';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            letterSpacing: 1,
                          ),
                          decoration: const InputDecoration(
                            hintText: '(707) 447 96 40',
                            hintStyle: TextStyle(
                              color: AppColors.textMuted,
                              fontFamily: 'Inter',
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GoldButton(
                  text: 'Получить код',
                  isLoading: isLoading,
                  onTap: _submit,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'или',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.login),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Войти по Email',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.register),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(text: 'Нет аккаунта? '),
                          TextSpan(
                            text: 'Создать по Email',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(text: 'Нажимая кнопку, вы соглашаетесь с\n'),
                          TextSpan(
                            text: 'Условиями использования',
                            style: TextStyle(
                              color: AppColors.gold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' и '),
                          TextSpan(
                            text: 'Политикой конфиденциальности',
                            style: TextStyle(
                              color: AppColors.gold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
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

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 10) return oldValue;

    String formatted = '';
    if (text.isNotEmpty) {
      formatted += '(' + text.substring(0, text.length > 3 ? 3 : text.length);
      if (text.length > 3) {
        formatted += ') ' + text.substring(3, text.length > 6 ? 6 : text.length);
      }
      if (text.length > 6) {
        formatted += ' ' + text.substring(6, text.length > 8 ? 8 : text.length);
      }
      if (text.length > 8) {
        formatted += ' ' + text.substring(8, text.length);
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

