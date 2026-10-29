class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String cnic;
  final bool isVerified;
  final String city;
  final double rating;
  final int listingsCount;
  final int rentalsCount;
  final String? boutiqueName;
  final String avatarInitials;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.cnic = '',
    this.isVerified = true,
    this.city = 'Lahore',
    this.rating = 4.9,
    this.listingsCount = 6,
    this.rentalsCount = 14,
    this.boutiqueName = 'Noor Boutique',
    this.avatarInitials = 'AK',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? cnic,
    bool? isVerified,
    String? city,
    double? rating,
    int? listingsCount,
    int? rentalsCount,
    String? boutiqueName,
    String? avatarInitials,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      isVerified: isVerified ?? this.isVerified,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      listingsCount: listingsCount ?? this.listingsCount,
      rentalsCount: rentalsCount ?? this.rentalsCount,
      boutiqueName: boutiqueName ?? this.boutiqueName,
      avatarInitials: avatarInitials ?? this.avatarInitials,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'cnic': cnic,
      'isVerified': isVerified,
      'city': city,
      'rating': rating,
      'listingsCount': listingsCount,
      'rentalsCount': rentalsCount,
      'boutiqueName': boutiqueName,
      'avatarInitials': avatarInitials,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserModel(
      id: docId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      cnic: map['cnic'] ?? '',
      isVerified: map['isVerified'] ?? false,
      city: map['city'] ?? 'Lahore',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      listingsCount: (map['listingsCount'] as num?)?.toInt() ?? 0,
      rentalsCount: (map['rentalsCount'] as num?)?.toInt() ?? 0,
      boutiqueName: map['boutiqueName'],
      avatarInitials: map['avatarInitials'] ?? 'U',
    );
  }
}
