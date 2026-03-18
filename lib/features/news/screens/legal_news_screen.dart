import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/core/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalNewsScreen extends ConsumerStatefulWidget {
  const LegalNewsScreen({super.key});
  @override
  ConsumerState<LegalNewsScreen> createState() => _LegalNewsScreenState();
}

class _LegalNewsScreenState extends ConsumerState<LegalNewsScreen> {
  String _filter = 'Все';

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final allStr = AppTranslations.tr('all_categories', lang);
    final newsStr = AppTranslations.tr('news_category', lang);
    final lawStr = AppTranslations.tr('news_law', lang);

    final _cats = [allStr, newsStr, lawStr, 'Бизнес', 'ДТП', 'Трудовое', 'Семейное', 'Недвижимость'];

    final news = _filter == 'Все' || _filter == allStr ? MockData.news : MockData.news.where((n) => n.category == _filter).toList();

    String _ago(DateTime dt) {
      final diff = DateTime.now().difference(dt);
      if (diff.inHours < 24) return '${diff.inHours} ч. назад';
      return '${diff.inDays} дн. назад';
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(title: AppTranslations.tr('legal_news', lang), showBack: true),
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
            child: ref.watch(newsProvider).when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
              error: (err, stack) => Center(child: Text('Ошибка загрузки: $err', style: const TextStyle(color: Colors.white))),
              data: (allNews) {
                final news = _filter == 'Все' || _filter == allStr ? allNews : allNews.where((n) => n.category == _filter).toList();
                if (news.isEmpty) {
                  return const EmptyState(icon: '📰', title: 'Нет новостей', subtitle: 'В этой категории пока нет новостей');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: news.length,
                  itemBuilder: (_, i) {
                    final n = news[i];
                    return GestureDetector(
                      onTap: () async {
                        if (n.url != null) {
                          final uri = Uri.parse(n.url!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      child: Container(
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
                            if (n.imageUrl != null) ...[
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(n.imageUrl!, height: 120, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox()),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(AppTranslations.tr('read_more', lang), style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, color: AppColors.gold, size: 13),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
