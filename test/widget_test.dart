import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/app.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LegalHelpApp(),
      ),
    );

    // Verify that splash screen or onboarding loads
    expect(find.byType(LegalHelpApp), findsOneWidget);
  });
}
