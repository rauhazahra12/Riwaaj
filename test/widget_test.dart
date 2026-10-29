import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riwaaj_flutter/main.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('RiwaajApp loads splash screen successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const RiwaajApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Riwaaj'), findsOneWidget);
    expect(find.text('Enter the wardrobe'), findsOneWidget);
  });
}
