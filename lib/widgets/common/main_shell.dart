import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:legalhelp_kz/core/utils/translations.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final _routes = [
    AppRoutes.home,
    AppRoutes.search,
    AppRoutes.aiChat,
    AppRoutes.lawyerMarketplace,
    AppRoutes.profile,
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    // Sync selected index based on current location
    final location = GoRouterState.of(context).uri.path;
    final idx = _routes.indexOf(location);
    if (idx != -1 && idx != _selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedIndex = idx);
      });
    }

    final lang = ref.watch(languageProvider);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          border: const Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: AppTranslations.tr('nav_home', lang),
                  isActive: _selectedIndex == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search,
                  label: AppTranslations.tr('nav_docs', lang), // search maps to docs in our setup
                  isActive: _selectedIndex == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: AppTranslations.tr('nav_chat', lang),
                  isActive: _selectedIndex == 2,
                  onTap: () => _onTap(2),
                  isHighlighted: true,
                ),
                _NavItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: AppTranslations.tr('nav_search', lang), // "Lawyers"
                  isActive: _selectedIndex == 3,
                  onTap: () => _onTap(3),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: AppTranslations.tr('nav_profile', lang),
                  isActive: _selectedIndex == 4,
                  onTap: () => _onTap(4),
                  badgeCount: unreadCount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool isHighlighted;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isHighlighted = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (isHighlighted) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.goldGradient : null,
            color: isActive ? null : AppColors.borderGold,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primaryBackground : AppColors.gold,
                size: 20,
              ),
              if (isActive) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primaryBackground,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.gold : AppColors.textTertiary,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.gold : AppColors.textTertiary,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
