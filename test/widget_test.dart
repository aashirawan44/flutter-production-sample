import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_production_sample/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App simple smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    // ProviderScope overrides happen in main, but here we can just use the default mock setup
    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    // Verify that we start at splash or login
    expect(find.text('Restoring Session...'), findsOneWidget);
  });
}
