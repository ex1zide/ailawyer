import 'package:flutter/material.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});
  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  final _faqs = [
    ('Как работает AI-юрист?', 'AI-юрист анализирует ваш вопрос и предоставляет информацию на основе законодательства Казахстана. Это не замена личной консультации, а первая помощь.'),
    ('Насколько точны ответы AI?', 'AI основывается на актуальной базе законов РК. Для сложных дел рекомендуем проконсультироваться с живым юристом из нашего маркетплейса.'),
    ('Как записаться к юристу?', 'Перейдите в раздел «Юристы», выберите специалиста, нажмите «Записаться» и выберите удобное время и формат консультации.'),
    ('Что входит в Pro-подписку?', 'Pro-подписка включает неограниченные AI-запросы, доступ к шаблонам документов, приоритетный поиск юристов и скидки до 20%.'),
    ('Как удалить аккаунт?', 'Напишите нам на support@legalhelp.kz с запросом об удалении аккаунта. Данные будут удалены в течение 30 дней.'),
    ('Безопасны ли мои данные?', 'Все данные шифруются по стандарту AES-256. Мы не передаём личную информацию третьим лицам без вашего согласия.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Помощь и поддержка'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact options
          Row(
            children: [
              _SupportCard(icon: '💬', title: 'Чат', subtitle: 'Онлайн сейчас', onTap: () {}),
              const SizedBox(width: 12),
              _SupportCard(icon: '📧', title: 'Email', subtitle: 'support@\nlegalhelp.kz', onTap: () {}),
              const SizedBox(width: 12),
              _SupportCard(icon: '📞', title: 'Звонок', subtitle: '+7 727 000 0000', onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Часто задаваемые вопросы'),
          const SizedBox(height: 12),
          ...List.generate(_faqs.length, (i) {
            final isExpanded = _expandedIndex == i;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isExpanded ? AppColors.gold.withOpacity(0.4) : AppColors.border),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(child: Text(_faqs[i].$1, style: TextStyle(
                            color: isExpanded ? AppColors.gold : AppColors.textPrimary,
                            fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter',
                          ))),
                          Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: isExpanded ? AppColors.gold : AppColors.textTertiary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Text(_faqs[i].$2, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter', height: 1.5)),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final String icon, title, subtitle;
  final VoidCallback onTap;
  const _SupportCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontFamily: 'Inter'), textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}

