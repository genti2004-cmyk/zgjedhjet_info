import 'package:flutter_test/flutter_test.dart';
import 'package:zgjedhjet_info/src/app/zgjedhjet_info_app.dart';

void main() {
  testWidgets('Zgjedhjet Info app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const ZgjedhjetInfoApp());

    expect(find.text('Zgjedhjet Info'), findsOneWidget);
    expect(
      find.text('Rezultatet dhe informacionet zgjedhore në një vend'),
      findsOneWidget,
    );
  });
}