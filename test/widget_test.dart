import 'package:flutter_test/flutter_test.dart';

import 'package:bubbl_flutter_sdk_example/main.dart';

void main() {
  testWidgets('renders flutter method playground shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BubblFlutterExampleApp());

    expect(find.text('Bubbl Flutter SDK Example'), findsOneWidget);
    expect(
      find.text(
        'Method playground aligned with guides/flutter-sdk/method-reference.md',
      ),
      findsOneWidget,
    );
  });
}
