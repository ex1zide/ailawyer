import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/config/routes.dart';
import 'package:legalhelp_kz/config/theme.dart';

class LegalHelpApp extends ConsumerWidget {
  const LegalHelpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'LegalHelp KZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Material(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  physics: const BouncingScrollPhysics(),
                ),
                child: child!,
              ),
            ),
          ),
        );
      },
    );
  }
}
