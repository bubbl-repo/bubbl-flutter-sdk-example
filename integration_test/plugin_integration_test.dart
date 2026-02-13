import 'package:bubbl_flutter_sdk/bubbl_flutter_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sayHello returns non-empty value', (WidgetTester tester) async {
    final String value = await BubblFlutterSdk.instance.sayHello();
    expect(value.isNotEmpty, true);
  });
}
