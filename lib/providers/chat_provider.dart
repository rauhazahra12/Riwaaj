import 'package:flutter/foundation.dart';
import '../models/chat_model.dart';
import '../models/outfit_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final IChatService chatService;

  List<ChatConversation> _conversations = [];
  ChatConversation? _activeConversation;
  bool _isLoading = false;
  String? _errorMessage;

  ChatProvider({required this.chatService}) {
    loadConversations();
    chatService.streamConversations().listen((convs) {
      _conversations = convs;
      if (_activeConversation != null) {
        final updated = convs.where((c) => c.id == _activeConversation!.id).toList();
        if (updated.isNotEmpty) {
          _activeConversation = updated.first;
        }
      }
      notifyListeners();
    });
  }

  List<ChatConversation> get conversations => _conversations;
  ChatConversation? get activeConversation => _activeConversation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalUnreadCount =>
      _conversations.fold(0, (sum, item) => sum + item.unreadCount);

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await chatService.getConversations();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveConversation(ChatConversation conversation) {
    _activeConversation = conversation;
    // Mark as read
    if (conversation.unreadCount > 0) {
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
        _activeConversation = _conversations[index];
      }
    }
    notifyListeners();
  }

  Future<void> startChatForOutfit(OutfitModel outfit) async {
    _isLoading = true;
    notifyListeners();

    try {
      final conv = await chatService.getOrCreateConversationForOutfit(
        ownerId: outfit.ownerId,
        ownerName: outfit.ownerName,
        outfitTitle: outfit.title,
        outfitPrice: outfit.pricePerDay,
      );
      _activeConversation = conv;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text, {required String currentUserId, required String currentUserName}) async {
    if (_activeConversation == null || text.trim().isEmpty) return;

    final convId = _activeConversation!.id;
    await chatService.sendMessage(
      conversationId: convId,
      text: text.trim(),
      senderId: currentUserId,
      senderName: currentUserName,
    );
  }

  Future<void> acceptRentalRequest(String messageId) async {
    if (_activeConversation == null) return;
    await chatService.acceptRentalRequestInChat(
      conversationId: _activeConversation!.id,
      messageId: messageId,
    );
  }
}
