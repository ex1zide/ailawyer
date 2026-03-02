import 'package:flutter/material.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class LegalNewsScreen extends StatefulWidget {
  const LegalNewsScreen({super.key});
  @override
  State<LegalNewsScreen> createState() => _LegalNewsScreenState();
}

class _LegalNewsScreenState extends State<LegalNewsScreen> {
  String _filter = 'Все';
  final _cats = ['Все', 'Бизнес', 'ДТП', 'Трудовое', 'Семейное', 'Недвижимость'];

  @override
  Widget build(BuildContext context) {
    final news = _filter == 'Все' ? MockData.news : MockData.news.where((n) => n.category == _filter).toList();

    String _ago(DateTime dt) {
      final diff = DateTime.now().difference(dt);
      if (diff.inHours < 24) return '${diff.inHours} ч. назад';
      return '${diff.inDays} дн. назад';
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const CustomAppBar(title: 'Правовые новости', showBack: true),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _cats.length,
              itemBuilder: (_, i) {
                final sel = _cats[i] == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = _cats[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                    ),
                    child: Center(child: Text(_cats[i], style: TextStyle(
                      color: sel ? AppColors.gold : AppColors.textSecondary, fontSize: 13,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontFamily: 'Inter',
                    ))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: news.isEmpty
                ? const EmptyState(icon: '📰', title: 'Нет новостей', subtitle: 'В этой категории пока нет новостей')
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: news.length,
                    itemBuilder: (_, i) {
                      final n = news[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GoldBadge(text: n.category, small: true),
                                const SizedBox(width: 8),
                                Text(_ago(n.publishedAt), style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                                const Spacer(),
                                Text(n.source, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, fontFamily: 'Inter')),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(n.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter', height: 1.3)),
                            const SizedBox(height: 6),
                            Text(n.summary, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Inter', height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text('Читать полностью', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, color: AppColors.gold, size: 13),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
