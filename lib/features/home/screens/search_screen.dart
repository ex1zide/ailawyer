import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  int _filterIdx = 0;
  final _filters = ['Все', 'Законы', 'Темы', 'Юристы', 'Шаблоны'];

  final _trending = [
    'Увольнение без причины', 'Развод с детьми', 'ДТП без страховки',
    'Долги по ипотеке', 'Трудовой договор', 'Алименты 2026',
  ];
  final _recent = ['Что делать при аресте?', 'Как составить иск?'];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text;
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Поиск', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFamily: 'Inter')),
                  const SizedBox(height: 16),
                  // Search input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontFamily: 'Inter'),
                            decoration: const InputDecoration(
                              hintText: 'Поиск по казахстанскому праву...',
                              hintStyle: TextStyle(color: AppColors.textMuted, fontFamily: 'Inter', fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        if (query.isNotEmpty)
                          GestureDetector(
                            onTap: () { _controller.clear(); setState(() {}); },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Icon(Icons.close, color: AppColors.textTertiary, size: 18),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Filters
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, i) {
                        final sel = i == _filterIdx;
                        return GestureDetector(
                          onTap: () => setState(() => _filterIdx = i),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                            ),
                            child: Center(
                              child: Text(_filters[i], style: TextStyle(
                                color: sel ? AppColors.gold : AppColors.textSecondary,
                                fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontFamily: 'Inter',
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: query.isNotEmpty
                  ? _SearchResults(query: query)
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        if (_recent.isNotEmpty) ...[
                          SectionHeader(title: 'Недавние поиски', actionText: 'Очистить', onAction: () {}),
                          const SizedBox(height: 12),
                          ..._recent.map((r) => _SearchHistoryItem(
                            text: r,
                            onTap: () { _controller.text = r; setState(() {}); },
                          )),
                          const SizedBox(height: 24),
                        ],
                        const SectionHeader(title: 'Популярные темы'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _trending.map((t) => GestureDetector(
                            onTap: () { _controller.text = t; setState(() {}); },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.trending_up, color: AppColors.gold, size: 14),
                                  const SizedBox(width: 6),
                                  Text(t, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontFamily: 'Inter')),
                                ],
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 24),
                        const SectionHeader(title: 'Категории'),
                        const SizedBox(height: 12),
                        ...['ДТП', 'Трудовое право', 'Семейное право', 'Недвижимость', 'Бизнес'].map((cat) =>
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.lawyerMarketplace),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.category_outlined, color: AppColors.gold, size: 18),
                                  const SizedBox(width: 12),
                                  Text(cat, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'Inter')),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 14),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    final results = [
      {'title': 'Статья 113 ТК РК — Оплата труда', 'cat': 'Законы', 'desc': 'Порядок выплаты заработной платы'},
      {'title': 'Как подать иск в суд?', 'cat': 'Темы', 'desc': 'Пошаговое руководство по подаче иска'},
      {'title': 'Ерлан Касымов — Юрист', 'cat': 'Юристы', 'desc': 'Специалист по ДТП • 4.9 ★'},
      {'title': 'Шаблон трудового договора', 'cat': 'Шаблоны', 'desc': 'Готовый шаблон по казахстанскому закону'},
    ];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final r = results[i];
        return InkWell(
          onTap: () {
            if (r['cat'] == 'Юристы') {
              context.push('/lawyers/l001'); // Mock ID for demo
            } else if (r['cat'] == 'Законы' || r['cat'] == 'Темы') {
              context.push(AppRoutes.aiChat);
            } else if (r['cat'] == 'Шаблоны') {
              context.push('/documents');
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.article_outlined, color: AppColors.gold, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['title']!, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          GoldBadge(text: r['cat']!, small: true),
                          const SizedBox(width: 8),
                          Expanded(child: Text(r['desc']!, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12, fontFamily: 'Inter'), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchHistoryItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SearchHistoryItem({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            const Icon(Icons.history, color: AppColors.textTertiary, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontFamily: 'Inter'))),
            const Icon(Icons.north_west, color: AppColors.textTertiary, size: 14),
          ],
        ),
      ),
    );
  }
}

