import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class DocumentLibraryScreen extends ConsumerStatefulWidget {
  const DocumentLibraryScreen({super.key});
  @override
  ConsumerState<DocumentLibraryScreen> createState() => _DocumentLibraryScreenState();
}

class _DocumentLibraryScreenState extends ConsumerState<DocumentLibraryScreen> {
  String _filter = 'All';
  final _filters = [('All', 'Все'), ('Contracts', 'Договоры'), ('Court', 'Суд'), ('Personal', 'Личные')];

  @override
  Widget build(BuildContext context) {
    final docs = ref.watch(documentsProvider);
    final filtered = _filter == 'All' ? docs : docs.where((d) => d.type == _filter).toList();

    String _typeLabel(String t) {
      switch (t) {
        case 'Contracts': return 'Договор';
        case 'Court': return 'Суд';
        case 'Personal': return 'Личное';
        default: return t;
      }
    }

    String _sizeStr(int bytes) {
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(0)} KB';
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    }

    final monthNames = ['', 'янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'Документы',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.documentScanner),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: AppColors.primaryBackground, size: 16),
                    SizedBox(width: 4),
                    Text('Сканировать', style: TextStyle(color: AppColors.primaryBackground, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final sel = _filters[i].$1 == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = _filters[i].$1),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.borderGold : AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                    ),
                    child: Center(child: Text(_filters[i].$2, style: TextStyle(
                      color: sel ? AppColors.gold : AppColors.textSecondary,
                      fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontFamily: 'Inter',
                    ))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(icon: '📄', title: 'Нет документов', subtitle: 'Отсканируйте первый документ', actionText: 'Сканировать')
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final doc = filtered[i];
                      return Container(
                        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceColor,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('📄', style: TextStyle(fontSize: 40)),
                                      const SizedBox(height: 4),
                                      GoldBadge(text: _typeLabel(doc.type), small: true),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Inter'), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(_sizeStr(doc.size), style: const TextStyle(color: AppColors.textTertiary, fontSize: 10, fontFamily: 'Inter')),
                                      const Spacer(),
                                      Text('${doc.createdAt.day} ${monthNames[doc.createdAt.month]}', style: const TextStyle(color: AppColors.textTertiary, fontSize: 10, fontFamily: 'Inter')),
                                    ],
                                  ),
                                ],
                              ),
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
