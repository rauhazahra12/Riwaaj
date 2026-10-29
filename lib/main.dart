import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';

// Services
import 'services/backend_config.dart';
import 'services/auth_service.dart';
import 'services/outfit_service.dart';
import 'services/booking_service.dart';
import 'services/chat_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/firestore_outfit_service.dart';
import 'services/firestore_booking_service.dart';
import 'services/firestore_chat_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/outfit_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/chat_provider.dart';

// Screens
import 'screens/shell/shell_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase backend with user's credentials (fallbacks safely if offline or in testing)
  await BackendConfig.initializeFirebase();

  runApp(const RiwaajApp());
}

class RiwaajApp extends StatelessWidget {
  const RiwaajApp({
    super.key,
    this.authService,
    this.outfitService,
    this.bookingService,
    this.chatService,
  });

  final IAuthService? authService;
  final IOutfitService? outfitService;
  final IBookingService? bookingService;
  final IChatService? chatService;

  @override
  Widget build(BuildContext context) {
    final isFirebase = BackendConfig.isFirebaseEnabled;

    final effectiveAuth = authService ??
        (isFirebase ? FirebaseAuthService() : MockAuthService());
    final effectiveOutfit = outfitService ??
        (isFirebase ? FirestoreOutfitService() : MockOutfitService());
    final effectiveBooking = bookingService ??
        (isFirebase ? FirestoreBookingService() : MockBookingService());
    final effectiveChat = chatService ??
        (isFirebase ? FirestoreChatService() : MockChatService());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService: effectiveAuth),
        ),
        ChangeNotifierProvider<OutfitProvider>(
          create: (_) => OutfitProvider(outfitService: effectiveOutfit),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(bookingService: effectiveBooking),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(chatService: effectiveChat),
        ),
      ],
      child: MaterialApp(
        title: 'Riwaaj',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ShellScreen(),
      ),
    );
  }
}
