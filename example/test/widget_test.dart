import 'package:flutter_test/flutter_test.dart';

import 'package:edge_detection_example/main.dart';

void main() {
  testWidgets('Edge Detection Example smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the main page
    expect(find.text('Edge Detection Example'), findsOneWidget);
    expect(find.text('Scan with Camera'), findsOneWidget);
    expect(find.text('Upload from Gallery'), findsOneWidget);
  });
}
