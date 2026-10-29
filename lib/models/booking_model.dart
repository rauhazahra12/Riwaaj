enum BookingStatus {
  pending,
  accepted,
  active,
  returned,
  declined;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.returned:
        return 'Returned';
      case BookingStatus.declined:
        return 'Declined';
    }
  }

  static BookingStatus fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'accepted':
        return BookingStatus.accepted;
      case 'active':
        return BookingStatus.active;
      case 'returned':
        return BookingStatus.returned;
      case 'declined':
        return BookingStatus.declined;
      default:
        return BookingStatus.pending;
    }
  }
}

class BookingModel {
  final String id;
  final String outfitId;
  final String outfitTitle;
  final int outfitArtIndex;
  final String renterId;
  final String renterName;
  final String ownerId;
  final String ownerName;
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final double ratePerDay;
  final double rentalTotal;
  final double serviceFee;
  final double deposit;
  final double totalAmount;
  final String selectedSize;
  final String note;
  final BookingStatus status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.outfitId,
    required this.outfitTitle,
    this.outfitArtIndex = 0,
    required this.renterId,
    required this.renterName,
    required this.ownerId,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.ratePerDay,
    required this.rentalTotal,
    required this.serviceFee,
    required this.deposit,
    required this.totalAmount,
    required this.selectedSize,
    this.note = '',
    this.status = BookingStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  BookingModel copyWith({
    String? id,
    String? outfitId,
    String? outfitTitle,
    int? outfitArtIndex,
    String? renterId,
    String? renterName,
    String? ownerId,
    String? ownerName,
    DateTime? startDate,
    DateTime? endDate,
    int? days,
    double? ratePerDay,
    double? rentalTotal,
    double? serviceFee,
    double? deposit,
    double? totalAmount,
    String? selectedSize,
    String? note,
    BookingStatus? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      outfitId: outfitId ?? this.outfitId,
      outfitTitle: outfitTitle ?? this.outfitTitle,
      outfitArtIndex: outfitArtIndex ?? this.outfitArtIndex,
      renterId: renterId ?? this.renterId,
      renterName: renterName ?? this.renterName,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      ratePerDay: ratePerDay ?? this.ratePerDay,
      rentalTotal: rentalTotal ?? this.rentalTotal,
      serviceFee: serviceFee ?? this.serviceFee,
      deposit: deposit ?? this.deposit,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedSize: selectedSize ?? this.selectedSize,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'outfitId': outfitId,
      'outfitTitle': outfitTitle,
      'outfitArtIndex': outfitArtIndex,
      'renterId': renterId,
      'renterName': renterName,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'days': days,
      'ratePerDay': ratePerDay,
      'rentalTotal': rentalTotal,
      'serviceFee': serviceFee,
      'deposit': deposit,
      'totalAmount': totalAmount,
      'selectedSize': selectedSize,
      'note': note,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return BookingModel(
      id: docId ?? map['id'] ?? '',
      outfitId: map['outfitId'] ?? '',
      outfitTitle: map['outfitTitle'] ?? '',
      outfitArtIndex: (map['outfitArtIndex'] as num?)?.toInt() ?? 0,
      renterId: map['renterId'] ?? '',
      renterName: map['renterName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate']) ?? DateTime.now()
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.tryParse(map['endDate']) ?? DateTime.now().add(const Duration(days: 3))
          : DateTime.now().add(const Duration(days: 3)),
      days: (map['days'] as num?)?.toInt() ?? 3,
      ratePerDay: (map['ratePerDay'] as num?)?.toDouble() ?? 0.0,
      rentalTotal: (map['rentalTotal'] as num?)?.toDouble() ?? 0.0,
      serviceFee: (map['serviceFee'] as num?)?.toDouble() ?? 0.0,
      deposit: (map['deposit'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      selectedSize: map['selectedSize'] ?? 'M',
      note: map['note'] ?? '',
      status: BookingStatus.fromString(map['status']),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
