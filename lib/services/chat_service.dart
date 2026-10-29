import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';

abstract class IChatService {
  Future<List<ChatConversation>> getConversations();
  Stream<List<ChatConversation>> streamConversations();
  Future<ChatConversation?> getConversationById(String id);
  Future<void> sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
    required String senderName,
  });
  Future<ChatConversation> getOrCreateConversationForOutfit({
    required String ownerId,
    required String ownerName,
    required String outfitTitle,
    required double outfitPrice,
  });
  Future<void> acceptRentalRequestInChat({
    required String conversationId,
    required String messageId,
  });
}

class MockChatService implements IChatService {
  final _controller = StreamController<List<ChatConversation>>.broadcast();
  final List<ChatConversation> _conversations = [];
  final _uuid = const Uuid();

  MockChatService() {
    _initSampleData();
  }

  void _initSampleData() {
    final now = DateTime.now();
    _conversations.addAll([
      ChatConversation(
        id: 'chat_maha_01',
        otherUserId: 'owner_maha',
        otherUserName: 'Maha Rizvi',
        otherUserSubtitle: 'Verified · usually replies quickly',
        outfitTitle: 'Ruby farshi lehenga',
        outfitPricePerDay: 12500,
        lastMessage: 'Yes, it’s free for those dates!',
        lastMessageTime: now.subtract(const Duration(minutes: 18)),
        unreadCount: 1,
        messages: [
          ChatMessage(
            id: 'msg_1',
            senderId: 'usr_ayesha_01',
            senderName: 'Ayesha Khan',
            text: 'Assalam-o-alaikum! Is it available 12–15 Dec?',
            timestamp: now.subtract(const Duration(hours: 3)),
            isFromCurrentUser: true,
          ),
          ChatMessage(
            id: 'msg_2',
            senderId: 'owner_maha',
            senderName: 'Maha Rizvi',
            text: 'Walaikum assalam! Yes, it is available for your dates.',
            timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
            isFromCurrentUser: false,
          ),
          ChatMessage(
            id: 'msg_3',
            senderId: 'usr_ayesha_01',
            senderName: 'Ayesha Khan',
            text: 'That would be lovely, thank you! Sending booking request now.',
            timestamp: now.subtract(const Duration(hours: 2)),
            isFromCurrentUser: true,
          ),
          ChatMessage(
            id: 'msg_req_4',
            senderId: 'usr_ayesha_01',
            senderName: 'Ayesha Khan',
            text: 'Rental request submitted',
            timestamp: now.subtract(const Duration(hours: 1)),
            isFromCurrentUser: true,
            bookingCardData: {
              'bookingId': 'book_01',
              'title': 'Ruby farshi lehenga',
              'dates': '12–15 Dec',
              'total': 'PKR 68,125 total · size M',
              'isAccepted': false,
            },
          ),
          ChatMessage(
            id: 'msg_5',
            senderId: 'owner_maha',
            senderName: 'Maha Rizvi',
            text: 'Yes, it’s free for those dates! Looking forward to sending it.',
            timestamp: now.subtract(const Duration(minutes: 18)),
            isFromCurrentUser: false,
          ),
        ],
      ),
      ChatConversation(
        id: 'chat_noor_02',
        otherUserId: 'owner_noor',
        otherUserName: 'Noor Boutique',
        otherUserSubtitle: 'Boutique partner · Karachi',
        outfitTitle: 'Ivory nikkah set',
        outfitPricePerDay: 9500,
        lastMessage: 'I can share more photos on request.',
        lastMessageTime: now.subtract(const Duration(days: 1, hours: 2)),
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: 'n_msg_1',
            senderId: 'usr_ayesha_01',
            senderName: 'Ayesha Khan',
            text: 'Hi Noor! Does the ivory set come with jewelry matching?',
            timestamp: now.subtract(const Duration(days: 1, hours: 4)),
            isFromCurrentUser: true,
          ),
          ChatMessage(
            id: 'n_msg_2',
            senderId: 'owner_noor',
            senderName: 'Noor Boutique',
            text: 'I can share more photos on request. We also have matha patti.',
            timestamp: now.subtract(const Duration(days: 1, hours: 2)),
            isFromCurrentUser: false,
          ),
        ],
      ),
      ChatConversation(
        id: 'chat_areeba_03',
        otherUserId: 'owner_areeba',
        otherUserName: 'Areeba S.',
        otherUserSubtitle: 'Top Rated lender · Islamabad',
        outfitTitle: 'Sunlit mayun lehenga',
        outfitPricePerDay: 6500,
        lastMessage: 'Thank you so much! Received back safely.',
        lastMessageTime: now.subtract(const Duration(days: 3)),
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: 'a_msg_1',
            senderId: 'owner_areeba',
            senderName: 'Areeba S.',
            text: 'Thank you so much! Received back safely.',
            timestamp: now.subtract(const Duration(days: 3)),
            isFromCurrentUser: false,
          ),
        ],
      ),
    ]);
  }

  @override
  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_conversations);
  }

  @override
  Stream<List<ChatConversation>> streamConversations() {
    _controller.add(List.unmodifiable(_conversations));
    return _controller.stream;
  }

  @override
  Future<ChatConversation?> getConversationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final conv = _conversations[index];
      final newMsg = ChatMessage(
        id: _uuid.v4(),
        senderId: senderId,
        senderName: senderName,
        text: text,
        timestamp: DateTime.now(),
        isFromCurrentUser: true,
      );
      final updatedMessages = [...conv.messages, newMsg];
      _conversations[index] = conv.copyWith(
        messages: updatedMessages,
        lastMessage: text,
        lastMessageTime: DateTime.now(),
      );
      _controller.add(List.unmodifiable(_conversations));
    }
  }

  @override
  Future<ChatConversation> getOrCreateConversationForOutfit({
    required String ownerId,
    required String ownerName,
    required String outfitTitle,
    required double outfitPrice,
  }) async {
    final existing = _conversations.where((c) => c.otherUserId == ownerId).toList();
    if (existing.isNotEmpty) {
      return existing.first;
    }
    final newConv = ChatConversation(
      id: 'chat_${_uuid.v4()}',
      otherUserId: ownerId,
      otherUserName: ownerName,
      outfitTitle: outfitTitle,
      outfitPricePerDay: outfitPrice,
      lastMessage: 'Conversation started',
      lastMessageTime: DateTime.now(),
      messages: [],
    );
    _conversations.insert(0, newConv);
    _controller.add(List.unmodifiable(_conversations));
    return newConv;
  }

  @override
  Future<void> acceptRentalRequestInChat({
    required String conversationId,
    required String messageId,
  }) async {
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final conv = _conversations[convIndex];
      final updatedMsgs = conv.messages.map((m) {
        if (m.id == messageId && m.bookingCardData != null) {
          final updatedData = Map<String, dynamic>.from(m.bookingCardData!);
          updatedData['isAccepted'] = true;
          return ChatMessage(
            id: m.id,
            senderId: m.senderId,
            senderName: m.senderName,
            text: m.text,
            timestamp: m.timestamp,
            isFromCurrentUser: m.isFromCurrentUser,
            bookingCardData: updatedData,
          );
        }
        return m;
      }).toList();

      _conversations[convIndex] = conv.copyWith(messages: updatedMsgs);
      _controller.add(List.unmodifiable(_conversations));
    }
  }
}
