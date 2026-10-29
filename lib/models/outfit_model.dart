class OutfitModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String designer;
  final String category;
  final List<String> availableSizes;
  final double pricePerDay;
  final double deposit;
  final String city;
  final String ownerId;
  final String ownerName;
  final double ownerRating;
  final bool isOwnerVerified;
  final int artIndex;
  final String? imageUrl;
  final String availabilityRange;
  final bool isPromoted;
  final int bookingCount;
  final DateTime createdAt;

  OutfitModel({
    required this.id,
    required this.title,
    this.subtitle = 'THE WEDDING EDIT',
    required this.description,
    required this.designer,
    required this.category,
    required this.availableSizes,
    required this.pricePerDay,
    required this.deposit,
    required this.city,
    required this.ownerId,
    required this.ownerName,
    this.ownerRating = 4.9,
    this.isOwnerVerified = true,
    this.artIndex = 0,
    this.imageUrl,
    this.availabilityRange = '12–20 December',
    this.isPromoted = false,
    this.bookingCount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  OutfitModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? designer,
    String? category,
    List<String>? availableSizes,
    double? pricePerDay,
    double? deposit,
    String? city,
    String? ownerId,
    String? ownerName,
    double? ownerRating,
    bool? isOwnerVerified,
    int? artIndex,
    String? imageUrl,
    String? availabilityRange,
    bool? isPromoted,
    int? bookingCount,
    DateTime? createdAt,
  }) {
    return OutfitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      designer: designer ?? this.designer,
      category: category ?? this.category,
      availableSizes: availableSizes ?? this.availableSizes,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      deposit: deposit ?? this.deposit,
      city: city ?? this.city,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerRating: ownerRating ?? this.ownerRating,
      isOwnerVerified: isOwnerVerified ?? this.isOwnerVerified,
      artIndex: artIndex ?? this.artIndex,
      imageUrl: imageUrl ?? this.imageUrl,
      availabilityRange: availabilityRange ?? this.availabilityRange,
      isPromoted: isPromoted ?? this.isPromoted,
      bookingCount: bookingCount ?? this.bookingCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'designer': designer,
      'category': category,
      'availableSizes': availableSizes,
      'pricePerDay': pricePerDay,
      'deposit': deposit,
      'city': city,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerRating': ownerRating,
      'isOwnerVerified': isOwnerVerified,
      'artIndex': artIndex,
      'imageUrl': imageUrl,
      'availabilityRange': availabilityRange,
      'isPromoted': isPromoted,
      'bookingCount': bookingCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OutfitModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return OutfitModel(
      id: docId ?? map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      designer: map['designer'] ?? '',
      category: map['category'] ?? 'Bridal',
      availableSizes: (map['availableSizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['M'],
      pricePerDay: (map['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      deposit: (map['deposit'] as num?)?.toDouble() ?? 0.0,
      city: map['city'] ?? 'Lahore',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerRating: (map['ownerRating'] as num?)?.toDouble() ?? 5.0,
      isOwnerVerified: map['isOwnerVerified'] ?? false,
      artIndex: (map['artIndex'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl'],
      availabilityRange: map['availabilityRange'] ?? '',
      isPromoted: map['isPromoted'] ?? false,
      bookingCount: (map['bookingCount'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
