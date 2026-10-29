import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/outfit_model.dart';
import 'outfit_service.dart';

class FirestoreOutfitService implements IOutfitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'outfits';

  @override
  Future<List<OutfitModel>> getOutfits() async {
    final snap = await _firestore.collection(_collection).get();
    return snap.docs.map((d) => OutfitModel.fromMap(d.data(), docId: d.id)).toList();
  }

  @override
  Stream<List<OutfitModel>> streamOutfits() {
    return _firestore.collection(_collection).snapshots().map(
      (snap) => snap.docs.map((d) => OutfitModel.fromMap(d.data(), docId: d.id)).toList(),
    );
  }

  @override
  Future<OutfitModel?> getOutfitById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return OutfitModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> addOutfit(OutfitModel outfit) async {
    await _firestore.collection(_collection).doc(outfit.id).set(outfit.toMap());
  }

  @override
  Future<void> updateOutfit(OutfitModel outfit) async {
    await _firestore.collection(_collection).doc(outfit.id).update(outfit.toMap());
  }

  @override
  Future<void> deleteOutfit(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
