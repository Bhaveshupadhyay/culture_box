import 'package:flutter_test/flutter_test.dart';
import 'package:culture_box/main.dart';

void main() {
  testWidgets('CultureBoxApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CultureBoxApp());
    expect(find.text('CULTUREBOX TV NETWORK'), findsWidgets);
  });
}
