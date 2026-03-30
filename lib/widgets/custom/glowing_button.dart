import 'package:flutter/material.dart';
import 'package:legalhelp_kz/config/theme.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool fullWidth;
  
  const GlowingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(100), // full rounded (pill shape)
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              if (_isHovered || _isPressed)
                BoxShadow(
                  color: AppColors.blueAccent.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 2,
                )
              else
                BoxShadow(
                  color: AppColors.glowColor,
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
            ],
          ),
          transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
          transformAlignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: AppColors.activeAccent, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: const TextStyle(
                  color: AppColors.activeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

