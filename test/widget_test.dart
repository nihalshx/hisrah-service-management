import 'package:flutter_test/flutter_test.dart';

import 'package:hisrah_service_management/main.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(const HisrahApp());
    await tester.pump(const Duration(milliseconds: 100));

    // App bar title should be visible on either screen.
    expect(find.text('Service Management'), findsOneWidget);
  });
}
