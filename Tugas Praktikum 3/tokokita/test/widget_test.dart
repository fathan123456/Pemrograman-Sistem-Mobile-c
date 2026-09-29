import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';

void main() {
  testWidgets('TokoKita smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    expect(find.text('Katalog TokoKita'), findsOneWidget);
  });
}
