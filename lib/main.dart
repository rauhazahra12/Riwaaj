import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';

// Services
import 'services/auth_service.dart';
import 'services/outfit_service.dart';
import 'services/booking_service.dart';
import 'services/chat_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/outfit_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/chat_provider.dart';

// Screens
import 'screens/shell/shell_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    final effectiveAuth = authService ?? MockAuthService();
    final effectiveOutfit = outfitService ?? MockOutfitService();
    final effectiveBooking = bookingService ?? MockBookingService();
    final effectiveChat = chatService ?? MockChatService();

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
