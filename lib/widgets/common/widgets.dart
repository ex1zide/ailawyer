import 'package:flutter/material.dart';
import 'package:legalhelp_kz/config/theme.dart';

// ─── Gold Button ──────────────────────────────────────────────────────────────

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final IconData? prefixIcon;
  final double? width;

  const GoldButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.prefixIcon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width ?? double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: isOutlined ? null : AppColors.goldGradient,
          border: isOutlined ? Border.all(color: AppColors.gold, width: 1.5) : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isOutlined
              ? null
              : [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: isOutlined ? AppColors.gold : AppColors.primaryBackground,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(
                        prefixIcon,
                        color: isOutlined ? AppColors.gold : AppColors.primaryBackground,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: isOutlined ? AppColors.gold : AppColors.primaryBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Gold Icon Button ─────────────────────────────────────────────────────────

class GoldIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  const GoldIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}

// ─── App Text Field ───────────────────────────────────────────────────────────

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textTertiary, size: 20)
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Gold Badge ───────────────────────────────────────────────────────────────

class GoldBadge extends StatelessWidget {
  final String text;
  final bool small;

  const GoldBadge({super.key, required this.text, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.borderGold,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.gold,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

// ─── Custom App Bar ───────────────────────────────────────────────────────────

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBackground,
      elevation: 0,
      centerTitle: true,
      leading: leading ??
          (showBack
              ? GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
                  ),
                )
              : null),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      actions: actions,
    );
  }
}

// ─── Skeleton Loader ──────────────────────────────────────────────────────────

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
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
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null) ...[
              const SizedBox(height: 24),
              GoldButton(text: actionText!, onTap: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Star Rating ──────────────────────────────────────────────────────────────

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 14,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.gold, size: size),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: size - 2,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

// ─── Online Indicator ─────────────────────────────────────────────────────────

class OnlineIndicator extends StatelessWidget {
  final bool isOnline;

  const OnlineIndicator({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.success : AppColors.textTertiary,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryBackground, width: 1.5),
      ),
    );
  }
}

// ─── Gold Pulse Animation ─────────────────────────────────────────────────────

class GoldPulse extends StatefulWidget {
  final Widget child;
  const GoldPulse({super.key, required this.child});

  @override
  State<GoldPulse> createState() => _GoldPulseState();
}

class _GoldPulseState extends State<GoldPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
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
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: widget.child,
      ),
    );
  }
}
