class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isFromCurrentUser;
  final Map<String, dynamic>? bookingCardData; // for rental request actionable bubble

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    DateTime? timestamp,
    this.isFromCurrentUser = false,
    this.bookingCardData,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isFromCurrentUser': isFromCurrentUser,
      'bookingCardData': bookingCardData,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map, {String? docId, String? currentUserId}) {
    final senderId = map['senderId'] ?? '';
    final isMe = currentUserId != null ? (senderId == currentUserId) : (map['isFromCurrentUser'] ?? false);
    return ChatMessage(
      id: docId ?? map['id'] ?? '',
      senderId: senderId,
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      isFromCurrentUser: isMe,
      bookingCardData: map['bookingCardData'] != null ? Map<String, dynamic>.from(map['bookingCardData']) : null,
    );
  }
}

class ChatConversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserSubtitle;
  final String outfitTitle;
  final double outfitPricePerDay;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<ChatMessage> messages;

  ChatConversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserSubtitle = 'Verified · usually replies quickly',
    required this.outfitTitle,
    required this.outfitPricePerDay,
    required this.lastMessage,
    DateTime? lastMessageTime,
    this.unreadCount = 0,
    this.messages = const [],
  }) : lastMessageTime = lastMessageTime ?? DateTime.now();

  ChatConversation copyWith({
    String? id,
    String? otherUserId,
    String? otherUserName,
    String? otherUserSubtitle,
    String? outfitTitle,
    double? outfitPricePerDay,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<ChatMessage>? messages,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserSubtitle: otherUserSubtitle ?? this.otherUserSubtitle,
      outfitTitle: outfitTitle ?? this.outfitTitle,
      outfitPricePerDay: outfitPricePerDay ?? this.outfitPricePerDay,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserSubtitle': otherUserSubtitle,
      'outfitTitle': outfitTitle,
      'outfitPricePerDay': outfitPricePerDay,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  factory ChatConversation.fromMap(Map<String, dynamic> map, {String? docId, List<ChatMessage> messages = const []}) {
    return ChatConversation(
      id: docId ?? map['id'] ?? '',
      otherUserId: map['otherUserId'] ?? '',
      otherUserName: map['otherUserName'] ?? '',
      otherUserSubtitle: map['otherUserSubtitle'] ?? 'Verified · usually replies quickly',
      outfitTitle: map['outfitTitle'] ?? '',
      outfitPricePerDay: (map['outfitPricePerDay'] as num?)?.toDouble() ?? 0.0,
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.tryParse(map['lastMessageTime']) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: (map['unreadCount'] as num?)?.toInt() ?? 0,
      messages: messages,
    );
  }
}
