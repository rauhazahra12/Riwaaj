import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import 'booking_service.dart';

class FirestoreBookingService implements IBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';

  @override
  Future<List<BookingModel>> getBookingsForRenter(String renterId) async {
    final snap = await _firestore
        .collection(_collection)
        .where('renterId', isEqualTo: renterId)
        .get();
    return snap.docs.map((d) => BookingModel.fromMap(d.data(), docId: d.id)).toList();
  }

  @override
  Future<List<BookingModel>> getBookingsForOwner(String ownerId) async {
    final snap = await _firestore
        .collection(_collection)
        .where('ownerId', isEqualTo: ownerId)
        .get();
    return snap.docs.map((d) => BookingModel.fromMap(d.data(), docId: d.id)).toList();
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    await _firestore.collection(_collection).doc(booking.id).set(booking.toMap());
  }

  @override
  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    await _firestore
        .collection(_collection)
        .doc(bookingId)
        .update({'status': status.name});
  }

  @override
  Stream<List<BookingModel>> streamBookings() {
    return _firestore.collection(_collection).snapshots().map(
      (snap) => snap.docs.map((d) => BookingModel.fromMap(d.data(), docId: d.id)).toList(),
    );
  }
}
