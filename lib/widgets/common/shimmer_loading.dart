import 'package:flutter/material.dart';
import 'package:legalhelp_kz/config/theme.dart';

/// Animated shimmer effect for loading placeholders.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(_animation.value - 1, 0),
            end: Alignment(_animation.value, 0),
            colors: const [
              Color(0xFF1A1A1A),
              Color(0xFF2A2A2A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton placeholder mimicking a lawyer card layout.
class LawyerCardSkeleton extends StatelessWidget {
  const LawyerCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 72, height: 72, borderRadius: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: MediaQuery.of(context).size.width * 0.4, height: 16),
                const SizedBox(height: 8),
                const ShimmerBox(width: 120, height: 12),
                const SizedBox(height: 12),
                const ShimmerBox(width: 180, height: 12),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(child: ShimmerBox(width: 80, height: 16)),
                    const SizedBox(width: 8),
                    const ShimmerBox(width: 90, height: 32, borderRadius: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton placeholder for news cards.
class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: double.infinity, height: 140, borderRadius: 10),
          const SizedBox(height: 12),
          ShimmerBox(width: MediaQuery.of(context).size.width * 0.7, height: 16),
          const SizedBox(height: 8),
          const ShimmerBox(width: double.infinity, height: 12),
          const SizedBox(height: 4),
          const ShimmerBox(width: 200, height: 12),
        ],
      ),
    );
  }
}

/// Skeleton for generic list loading — shows [count] skeleton cards.
class LawyerListSkeleton extends StatelessWidget {
  final int count;
  const LawyerListSkeleton({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => const LawyerCardSkeleton(),
    );
  }
}
