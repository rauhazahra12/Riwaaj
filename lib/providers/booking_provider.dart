import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../models/outfit_model.dart';
import '../services/booking_service.dart';
import '../core/constants/app_constants.dart';

class BookingProvider extends ChangeNotifier {
  final IBookingService bookingService;

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  BookingModel? _selectedBooking;
  int _activeTab = 0; // 0 = Renting, 1 = Lending

  BookingProvider({required this.bookingService}) {
    loadBookings();
    bookingService.streamBookings().listen((b) {
      _bookings = b;
      notifyListeners();
    });
  }

  List<BookingModel> get allBookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get activeTab => _activeTab;
  BookingModel? get selectedBooking => _selectedBooking;

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void setSelectedBooking(BookingModel booking) {
    _selectedBooking = booking;
    notifyListeners();
  }

  List<BookingModel> get rentingBookings {
    return _bookings.where((b) => b.renterId == 'usr_ayesha_01').toList();
  }

  List<BookingModel> get lendingBookings {
    return _bookings.where((b) => b.ownerId == 'usr_ayesha_01').toList();
  }

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await bookingService.getBookingsForRenter('usr_ayesha_01');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRentalRequest({
    required OutfitModel outfit,
    required DateTime startDate,
    required DateTime endDate,
    required String selectedSize,
    required String note,
    required String renterId,
    required String renterName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final days = endDate.difference(startDate).inDays.clamp(1, 30);
      final rentalTotal = outfit.pricePerDay * days;
      final serviceFee = rentalTotal * AppConstants.serviceFeePercentage;
      final deposit = outfit.deposit;
      final totalAmount = rentalTotal + serviceFee + deposit;

      final newBooking = BookingModel(
        id: 'book_${DateTime.now().millisecondsSinceEpoch}',
        outfitId: outfit.id,
        outfitTitle: outfit.title,
        outfitArtIndex: outfit.artIndex,
        renterId: renterId,
        renterName: renterName,
        ownerId: outfit.ownerId,
        ownerName: outfit.ownerName,
        startDate: startDate,
        endDate: endDate,
        days: days,
        ratePerDay: outfit.pricePerDay,
        rentalTotal: rentalTotal,
        serviceFee: serviceFee,
        deposit: deposit,
        totalAmount: totalAmount,
        selectedSize: selectedSize,
        note: note,
        status: BookingStatus.pending,
      );

      await bookingService.createBooking(newBooking);
      _bookings.insert(0, newBooking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateStatus(String bookingId, BookingStatus newStatus) async {
    await bookingService.updateBookingStatus(bookingId, newStatus);
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      _bookings[idx] = _bookings[idx].copyWith(status: newStatus);
      if (_selectedBooking?.id == bookingId) {
        _selectedBooking = _bookings[idx];
      }
      notifyListeners();
    }
  }
}
