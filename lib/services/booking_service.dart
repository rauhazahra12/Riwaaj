import 'dart:async';
import '../models/booking_model.dart';

abstract class IBookingService {
  Future<List<BookingModel>> getBookingsForRenter(String renterId);
  Future<List<BookingModel>> getBookingsForOwner(String ownerId);
  Future<void> createBooking(BookingModel booking);
  Future<void> updateBookingStatus(String bookingId, BookingStatus status);
  Stream<List<BookingModel>> streamBookings();
}

class MockBookingService implements IBookingService {
  final _controller = StreamController<List<BookingModel>>.broadcast();
  final List<BookingModel> _bookings = [];

  MockBookingService() {
    _initSampleData();
  }

  void _initSampleData() {
    final now = DateTime.now();
    _bookings.addAll([
      BookingModel(
        id: 'book_01',
        outfitId: 'outfit_1',
        outfitTitle: 'Ruby farshi lehenga',
        outfitArtIndex: 0,
        renterId: 'usr_ayesha_01',
        renterName: 'Ayesha Khan',
        ownerId: 'owner_maha',
        ownerName: 'Maha Rizvi',
        startDate: DateTime(now.year, 12, 12),
        endDate: DateTime(now.year, 12, 15),
        days: 3,
        ratePerDay: 12500,
        rentalTotal: 37500,
        serviceFee: 5625,
        deposit: 25000,
        totalAmount: 68125,
        selectedSize: 'M',
        note: 'Assalam-o-alaikum Maha! Would love to wear this for my cousin\'s barat.',
        status: BookingStatus.accepted,
      ),
      BookingModel(
        id: 'book_02',
        outfitId: 'outfit_2',
        outfitTitle: 'Ivory nikkah set',
        outfitArtIndex: 1,
        renterId: 'usr_ayesha_01',
        renterName: 'Ayesha Khan',
        ownerId: 'owner_noor',
        ownerName: 'Noor Boutique',
        startDate: DateTime(now.year, 12, 22),
        endDate: DateTime(now.year, 12, 23),
        days: 2,
        ratePerDay: 9500,
        rentalTotal: 19000,
        serviceFee: 2850,
        deposit: 20000,
        totalAmount: 41850,
        selectedSize: 'M',
        note: 'Can I also request dry-cleaning verification before pickup?',
        status: BookingStatus.pending,
      ),
      BookingModel(
        id: 'book_03',
        outfitId: 'outfit_3',
        outfitTitle: 'Sunlit mayun lehenga',
        outfitArtIndex: 2,
        renterId: 'usr_ayesha_01',
        renterName: 'Ayesha Khan',
        ownerId: 'owner_areeba',
        ownerName: 'Areeba S.',
        startDate: DateTime(now.year, 11, 2),
        endDate: DateTime(now.year, 11, 4),
        days: 2,
        ratePerDay: 6500,
        rentalTotal: 13000,
        serviceFee: 1950,
        deposit: 15000,
        totalAmount: 29950,
        selectedSize: 'S',
        note: 'Returned in pristine condition with safety pouch.',
        status: BookingStatus.returned,
      ),
      BookingModel(
        id: 'book_04',
        outfitId: 'outfit_4',
        outfitTitle: 'Midnight gharara',
        outfitArtIndex: 3,
        renterId: 'renter_fatima',
        renterName: 'Fatima Zahra',
        ownerId: 'usr_ayesha_01', // Ayesha is lending this!
        ownerName: 'Ayesha Khan',
        startDate: DateTime(now.year, 12, 18),
        endDate: DateTime(now.year, 12, 20),
        days: 2,
        ratePerDay: 8000,
        rentalTotal: 16000,
        serviceFee: 2400,
        deposit: 18000,
        totalAmount: 36400,
        selectedSize: 'L',
        note: 'Looking forward to wearing your gharara for my sister’s qawwali night.',
        status: BookingStatus.pending,
      ),
    ]);
  }

  @override
  Future<List<BookingModel>> getBookingsForRenter(String renterId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _bookings.where((b) => b.renterId == renterId).toList();
  }

  @override
  Future<List<BookingModel>> getBookingsForOwner(String ownerId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _bookings.where((b) => b.ownerId == ownerId).toList();
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bookings.insert(0, booking);
    _controller.add(List.unmodifiable(_bookings));
  }

  @override
  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: status);
      _controller.add(List.unmodifiable(_bookings));
    }
  }

  @override
  Stream<List<BookingModel>> streamBookings() {
    _controller.add(List.unmodifiable(_bookings));
    return _controller.stream;
  }
}
