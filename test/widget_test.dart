import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riwaaj_flutter/main.dart';
import 'package:riwaaj_flutter/services/backend_config.dart';
import 'package:riwaaj_flutter/services/auth_service.dart';
import 'package:riwaaj_flutter/services/outfit_service.dart';
import 'package:riwaaj_flutter/services/booking_service.dart';
import 'package:riwaaj_flutter/services/chat_service.dart';

void main() {
  setUp(() {
    BackendConfig.currentMode = BackendMode.mock;
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('RiwaajApp loads splash screen successfully with backend services', (WidgetTester tester) async {
    await tester.pumpWidget(
      RiwaajApp(
        authService: MockAuthService(),
        outfitService: MockOutfitService(),
        bookingService: MockBookingService(),
        chatService: MockChatService(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Riwaaj'), findsOneWidget);
    expect(find.text('Enter the wardrobe'), findsOneWidget);
  });
}
