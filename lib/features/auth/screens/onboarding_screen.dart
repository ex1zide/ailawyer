import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/config/constants.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';
import 'package:legalhelp_kz/providers/providers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      emoji: '⚡',
      title: 'Юридические ответы\nза 30 секунд',
      subtitle: 'AI-юрист понимает ваши вопросы\nна русском и казахском языках',
      features: [],
      gradient: [Color(0xFF1A1500), Color(0xFF0A0A0A)],
    ),
    _OnboardingPage(
      emoji: '💰',
      title: 'Сэкономьте 50 000 ₸\nна юристах',
      subtitle: 'Получайте профессиональную\nюридическую помощь по доступной цене',
      features: [
        '✅ Бесплатные AI-консультации',
        '✅ Юристы от 5 000 ₸/час',
        '✅ Шаблоны документов',
        '✅ Анализ договоров',
      ],
      gradient: [Color(0xFF0D1A0A), Color(0xFF0A0A0A)],
    ),
    _OnboardingPage(
      emoji: '🌍',
      title: 'Настройте под\nсебя',
      subtitle: 'Выберите язык, город и\nинтересующие вас темы права',
      features: [],
      isSetup: true,
      gradient: [Color(0xFF0A0A1A), Color(0xFF0A0A0A)],
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.push(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, i) => _PageView(page: _pages[i]),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 150, // Fixed height to prevent overflow
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryBackground.withOpacity(0),
                      AppColors.primaryBackground,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 24 : 8,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? AppColors.gold
                                : AppColors.textMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (_currentPage > 0)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GoldButton(
                                text: 'Назад',
                                isOutlined: true,
                                onTap: () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ),
                        Expanded(
                          child: GoldButton(
                            text: _currentPage == _pages.length - 1
                                ? 'Начать'
                                : 'Далее',
                            onTap: _next,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Skip button always visible
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.login),
                      child: const Text(
                        'Пропустить',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final List<String> features;
  final bool isSetup;
  final List<Color> gradient;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.features,
    this.isSetup = false,
    required this.gradient,
  });
}

class _PageView extends ConsumerStatefulWidget {
  final _OnboardingPage page;
  const _PageView({required this.page});

  @override
  ConsumerState<_PageView> createState() => _PageViewState();
}

class _PageViewState extends ConsumerState<_PageView> {
  String _selectedCity = 'Алматы';
  final List<String> _selectedInterests = ['ДТП', 'Семейное право'];

  @override
  Widget build(BuildContext context) {
    final page = widget.page;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji illustration
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.borderGold,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(page.emoji, style: const TextStyle(fontSize: 60)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                page.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                page.subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              if (page.features.isNotEmpty)
                ...page.features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    f,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                )),
              if (page.isSetup) ...[
                // Language selector
                const Text(
                  'Язык / Тіл',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Русский', 'Қазақша'].map((lang) {
                    final selectedLanguage = ref.watch(languageProvider);
                    final selected = selectedLanguage == lang;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(languageProvider.notifier).setLanguage(lang),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.borderGold : AppColors.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected ? AppColors.gold : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              lang,
                              style: TextStyle(
                                color: selected ? AppColors.gold : AppColors.textSecondary,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // City dropdown
                const Text(
                  'Ваш город',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      isExpanded: true,
                      dropdownColor: AppColors.secondaryBackground,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                      items: AppConstants.kazakhstanCities
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCity = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Interests
                const Text(
                  'Интересующие темы',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.interestsList.map((interest) {
                    final selected = _selectedInterests.contains(interest);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selected) {
                          _selectedInterests.remove(interest);
                        } else {
                          _selectedInterests.add(interest);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.borderGold : AppColors.secondaryBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? AppColors.gold : AppColors.border,
                          ),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            color: selected ? AppColors.gold : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
