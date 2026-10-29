import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';
import 'chat_service.dart';

class FirestoreChatService implements IChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'conversations';
  final _uuid = const Uuid();

  @override
  Future<List<ChatConversation>> getConversations() async {
    final snap = await _firestore.collection(_collection).get();
    final List<ChatConversation> results = [];
    for (var doc in snap.docs) {
      final msgsSnap = await doc.reference.collection('messages').orderBy('timestamp').get();
      final msgs = msgsSnap.docs.map((m) => ChatMessage.fromMap(m.data(), docId: m.id)).toList();
      results.add(ChatConversation.fromMap(doc.data(), docId: doc.id, messages: msgs));
    }
    return results;
  }

  @override
  Stream<List<ChatConversation>> streamConversations() {
    return _firestore.collection(_collection).snapshots().asyncMap((snap) async {
      final List<ChatConversation> list = [];
      for (var doc in snap.docs) {
        final msgsSnap = await doc.reference.collection('messages').orderBy('timestamp').get();
        final msgs = msgsSnap.docs.map((m) => ChatMessage.fromMap(m.data(), docId: m.id)).toList();
        list.add(ChatConversation.fromMap(doc.data(), docId: doc.id, messages: msgs));
      }
      return list;
    });
  }

  @override
  Future<ChatConversation?> getConversationById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    final msgsSnap = await doc.reference.collection('messages').orderBy('timestamp').get();
    final msgs = msgsSnap.docs.map((m) => ChatMessage.fromMap(m.data(), docId: m.id)).toList();
    return ChatConversation.fromMap(doc.data()!, docId: doc.id, messages: msgs);
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    final newMsg = ChatMessage(
      id: _uuid.v4(),
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      isFromCurrentUser: true,
    );

    final convRef = _firestore.collection(_collection).doc(conversationId);
    await convRef.collection('messages').doc(newMsg.id).set(newMsg.toMap());
    await convRef.update({
      'lastMessage': text,
      'lastMessageTime': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<ChatConversation> getOrCreateConversationForOutfit({
    required String ownerId,
    required String ownerName,
    required String outfitTitle,
    required double outfitPrice,
  }) async {
    final query = await _firestore
        .collection(_collection)
        .where('otherUserId', isEqualTo: ownerId)
        .where('outfitTitle', isEqualTo: outfitTitle)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final msgsSnap = await doc.reference.collection('messages').orderBy('timestamp').get();
      final msgs = msgsSnap.docs.map((m) => ChatMessage.fromMap(m.data(), docId: m.id)).toList();
      return ChatConversation.fromMap(doc.data(), docId: doc.id, messages: msgs);
    }

    final newId = 'chat_${_uuid.v4()}';
    final newConv = ChatConversation(
      id: newId,
      otherUserId: ownerId,
      otherUserName: ownerName,
      outfitTitle: outfitTitle,
      outfitPricePerDay: outfitPrice,
      lastMessage: 'Conversation started',
      lastMessageTime: DateTime.now(),
      messages: [],
    );
    await _firestore.collection(_collection).doc(newId).set(newConv.toMap());
    return newConv;
  }

  @override
  Future<void> acceptRentalRequestInChat({
    required String conversationId,
    required String messageId,
  }) async {
    final msgRef = _firestore
        .collection(_collection)
        .doc(conversationId)
        .collection('messages')
        .doc(messageId);

    final doc = await msgRef.get();
    if (doc.exists && doc.data() != null) {
      final data = Map<String, dynamic>.from(doc.data()!);
      if (data['bookingCardData'] != null) {
        final cardData = Map<String, dynamic>.from(data['bookingCardData']);
        cardData['isAccepted'] = true;
        await msgRef.update({'bookingCardData': cardData});
      }
    }
  }
}
