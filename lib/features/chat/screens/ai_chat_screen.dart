import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/constants.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/widgets/common/widgets.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});
  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  int _activeCategory = 0;
  final _categories = ['Все темы', 'Трудовое', 'Развод', 'ДТП', 'Договоры'];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _controller.clear();
    ref.read(chatProvider.notifier).sendMessage(text.trim());
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.secondaryBackground,
                border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: Row(
                children: [
                  // AI Avatar
                  Stack(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
                        child: const Center(child: Text('⚖️', style: TextStyle(fontSize: 22))),
                      ),
                      const Positioned(
                        right: 0, bottom: 0,
                        child: OnlineIndicator(isOnline: true),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AI Юрист', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text('Онлайн · Всегда доступен', style: TextStyle(color: AppColors.success, fontSize: 12, fontFamily: 'Inter')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(chatProvider.notifier).clearMessages(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.surfaceColor, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.refresh_outlined, color: AppColors.textSecondary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Category tabs
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final sel = i == _activeCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _activeCategory = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.borderGold : AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: sel ? AppColors.gold : AppColors.border),
                      ),
                      child: Center(child: Text(_categories[i], style: TextStyle(
                         color: sel ? AppColors.gold : AppColors.textSecondary,
                        fontSize: 12, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      ))),
                    ),
                  );
                },
              ),
            ),
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (_, i) => _MessageBubble(message: messages[i]),
              ),
            ),
            // Quick replies
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: AppConstants.quickReplies.map((r) => GestureDetector(
                  onTap: () => _send(r),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.borderGold,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                    ),
                     child: Center(child: Text(r, style: const TextStyle(
                      color: AppColors.gold, fontSize: 12,
                    ))),
                  ),
                )).toList(),
              ),
            ),
            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.secondaryBackground,
                border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Задайте юридический вопрос...',
                                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14, fontFamily: 'Inter'),
                                border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: _send,
                              maxLines: 3, minLines: 1,
                            ),
                          ),
                          // Voice button
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              width: 34, height: 34,
                              decoration: BoxDecoration(color: AppColors.borderGold, shape: BoxShape.circle),
                              child: const Icon(Icons.mic_none, color: AppColors.gold, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Send button
                  GestureDetector(
                    onTap: () => _send(_controller.text),
                    child: Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0,2))]),
                      child: const Icon(Icons.send_rounded, color: AppColors.primaryBackground, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    if (message.isLoading) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, right: 60),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4),
          ), border: Border.all(color: AppColors.border)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => _LoadingDot(delay: i * 150)),
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12, left: isUser ? 60 : 0, right: isUser ? 0 : 60),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser ? AppColors.goldGradient : null,
                color: isUser ? null : AppColors.secondaryBackground,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser ? null : Border.all(color: AppColors.border),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                   color: isUser ? AppColors.primaryBackground : AppColors.textPrimary,
                  fontSize: 14, height: 1.5,
                ),
              ),
            ),
            if (!isUser && message.sources != null && message.sources!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 6, runSpacing: 4,
                children: message.sources!.map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.borderGold, borderRadius: BorderRadius.circular(6)),
                  child: Text('📚 $s', style: const TextStyle(color: AppColors.gold, fontSize: 10)),
                )).toList(),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour.toString().padLeft(2,'0')}:${message.timestamp.minute.toString().padLeft(2,'0')}',
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDot extends StatefulWidget {
  final int delay;
  const _LoadingDot({required this.delay});
  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}
class _LoadingDotState extends State<_LoadingDot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _a = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _c.repeat(reverse: true); });
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _a,
    builder: (_, __) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 8, height: 8,
      decoration: BoxDecoration(color: AppColors.gold.withOpacity(_a.value), shape: BoxShape.circle),
    ),
  );
}
