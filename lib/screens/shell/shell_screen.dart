import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_model.dart';
import '../../models/outfit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/outfit_provider.dart';
import '../../widgets/bottom_nav_bar.dart';

// Screens
import '../splash/splash_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../auth/login_screen.dart';
import '../auth/verify_screen.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../detail/outfit_detail_screen.dart';
import '../booking/booking_screen.dart';
import '../chats/chats_list_screen.dart';
import '../chats/chat_room_screen.dart';
import '../bookings/bookings_screen.dart';
import '../add_listing/add_listing_screen.dart';
import '../profile/profile_screen.dart';
import '../dashboard/boutique_dashboard_screen.dart';
import '../saved/saved_looks_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  String _currentPage = 'splash';
  int _currentTab = 0;

  OutfitModel? _activeOutfit;
  ChatConversation? _activeConversation;

  void _navigateTo(String page) {
    setState(() => _currentPage = page);
  }

  void _switchTab(int tabIndex) {
    setState(() {
      _currentTab = tabIndex;
      _currentPage = ['home', 'search', 'add', 'chats', 'profile'][tabIndex];
    });
  }

  void _openOutfitDetail(OutfitModel outfit) {
    setState(() {
      _activeOutfit = outfit;
      _currentPage = 'detail';
    });
  }

  void _openBooking(OutfitModel outfit) {
    setState(() {
      _activeOutfit = outfit;
      _currentPage = 'booking';
    });
  }

  void _openChatRoom(ChatConversation conversation) {
    setState(() {
      _activeConversation = conversation;
      _currentPage = 'chat';
    });
  }

  @override
  Widget build(BuildContext context) {
    final outfitProvider = context.watch<OutfitProvider>();
    final activeOutfit = _activeOutfit ??
        (outfitProvider.allOutfits.isNotEmpty ? outfitProvider.allOutfits.first : null);

    final Widget body;
    switch (_currentPage) {
      case 'splash':
        body = SplashScreen(
          onEnter: () => _navigateTo('onboard'),
          onLogin: () => _navigateTo('login'),
        );
        break;
      case 'onboard':
        body = OnboardingScreen(
          onFinish: () => _navigateTo('login'),
          onSkip: () => _navigateTo('login'),
        );
        break;
      case 'login':
        body = LoginScreen(
          onBack: () => _navigateTo('splash'),
          onSuccess: () => _navigateTo('home'),
          onContinueWithPhone: () => _navigateTo('verify'),
        );
        break;
      case 'verify':
        body = VerifyScreen(
          onBack: () => _navigateTo('login'),
          onSuccess: () => _navigateTo('home'),
        );
        break;
      case 'home':
        body = HomeScreen(
          onSearchTap: () => _switchTab(1),
          onFilterTap: () => _switchTab(1),
          onOutfitTap: _openOutfitDetail,
        );
        break;
      case 'search':
        body = SearchScreen(
          onOutfitTap: _openOutfitDetail,
        );
        break;
      case 'detail':
        body = activeOutfit != null
            ? OutfitDetailScreen(
                outfit: activeOutfit,
                onBack: () => _navigateTo('home'),
                onBook: _openBooking,
                onChat: () {
                  final conversation = context.read<ChatProvider>().activeConversation;
                  if (conversation != null) _openChatRoom(conversation);
                },
              )
            : HomeScreen(
                onSearchTap: () => _switchTab(1),
                onFilterTap: () => _switchTab(1),
                onOutfitTap: _openOutfitDetail,
              );
        break;
      case 'booking':
        body = activeOutfit != null
            ? BookingScreen(
                outfit: activeOutfit,
                onBack: () => _navigateTo('detail'),
                onSuccess: () => _navigateTo('bookings'),
              )
            : HomeScreen(
                onSearchTap: () => _switchTab(1),
                onFilterTap: () => _switchTab(1),
                onOutfitTap: _openOutfitDetail,
              );
        break;
      case 'chats':
        body = ChatsListScreen(
          onOpenChat: _openChatRoom,
        );
        break;
      case 'chat':
        final activeChat = context.watch<ChatProvider>().activeConversation;
        final conv = activeChat ?? _activeConversation ??
            (context.watch<ChatProvider>().conversations.isNotEmpty
                ? context.watch<ChatProvider>().conversations.first
                : null);
        body = conv != null
            ? ChatRoomScreen(
                conversation: conv,
                onBack: () => _navigateTo('chats'),
              )
            : ChatsListScreen(onOpenChat: _openChatRoom);
        break;
      case 'bookings':
        body = BookingsScreen(
          onChatWithOwner: (owner) => _switchTab(3),
        );
        break;
      case 'add':
        body = AddListingScreen(
          onPublished: () => _switchTab(0),
        );
        break;
      case 'profile':
        body = ProfileScreen(
          onOpenDashboard: () => _navigateTo('dashboard'),
          onOpenSaved: () => _navigateTo('saved'),
          onOpenBookings: () => _navigateTo('bookings'),
          onLogout: () {
            context.read<AuthProvider>().logout();
            _navigateTo('login');
          },
        );
        break;
      case 'dashboard':
        body = BoutiqueDashboardScreen(
          onBack: () => _navigateTo('profile'),
        );
        break;
      case 'saved':
        body = SavedLooksScreen(
          onBack: () => _navigateTo('profile'),
          onExplore: () => _switchTab(0),
          onOutfitTap: _openOutfitDetail,
        );
        break;
      default:
        body = HomeScreen(
          onSearchTap: () => _switchTab(1),
          onFilterTap: () => _switchTab(1),
          onOutfitTap: _openOutfitDetail,
        );
    }

    // Determine whether to display the floating bottom navigation bar
    final showBottomNav = ![
      'splash',
      'onboard',
      'login',
      'verify',
      'detail',
      'booking',
      'chat',
      'dashboard',
    ].contains(_currentPage);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: body),
          if (showBottomNav)
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingBottomNavBar(
                currentIndex: _currentTab,
                onTap: _switchTab,
              ),
            ),
        ],
      ),
    );
  }
}
