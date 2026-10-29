import 'dart:async';
import '../models/outfit_model.dart';

abstract class IOutfitService {
  Future<List<OutfitModel>> getOutfits();
  Stream<List<OutfitModel>> streamOutfits();
  Future<OutfitModel?> getOutfitById(String id);
  Future<void> addOutfit(OutfitModel outfit);
  Future<void> updateOutfit(OutfitModel outfit);
  Future<void> deleteOutfit(String id);
}

class MockOutfitService implements IOutfitService {
  final _controller = StreamController<List<OutfitModel>>.broadcast();
  final List<OutfitModel> _outfits = [];

  MockOutfitService() {
    _initSampleData();
  }

  void _initSampleData() {
    _outfits.addAll([
      OutfitModel(
        id: 'outfit_1',
        title: 'Ruby farshi lehenga',
        subtitle: 'THE WEDDING EDIT',
        description:
            'Hand-finished ruby raw silk with antique gold zardozi and kora dabka threadwork. A magnificent statement piece tailored for bridal and barat occasions, preserved in immaculate condition.',
        designer: 'Elan Bridal',
        category: 'Lehenga',
        availableSizes: ['XS', 'S', 'M', 'L'],
        pricePerDay: 12500,
        deposit: 25000,
        city: 'Lahore',
        ownerId: 'owner_maha',
        ownerName: 'Maha Rizvi',
        ownerRating: 4.9,
        isOwnerVerified: true,
        artIndex: 0,
        availabilityRange: '12–20 December',
        isPromoted: true,
        bookingCount: 12,
      ),
      OutfitModel(
        id: 'outfit_2',
        title: 'Ivory nikkah set',
        subtitle: 'TIMELESS EDIT',
        description:
            'Subtle ivory net peshwas embellished with delicate pearls, crystals, and silver resham embroidery. Paired with a crushed silk dupatta and flared sharara.',
        designer: 'Faiza Saqlain',
        category: 'Bridal',
        availableSizes: ['S', 'M', 'L'],
        pricePerDay: 9500,
        deposit: 20000,
        city: 'Karachi',
        ownerId: 'owner_noor',
        ownerName: 'Noor Boutique',
        ownerRating: 4.8,
        isOwnerVerified: true,
        artIndex: 1,
        availabilityRange: '20–28 December',
        isPromoted: true,
        bookingCount: 8,
      ),
      OutfitModel(
        id: 'outfit_3',
        title: 'Sunlit mayun lehenga',
        subtitle: 'MEHNDI & MAYUN',
        description:
            'Vibrant mustard and marigold chanderi silk lehenga with mirrorwork borders and gota patti detailing. Comfortable, lightweight, and photograph-ready.',
        designer: 'Zara Shahjahan',
        category: 'Lehenga',
        availableSizes: ['S', 'M'],
        pricePerDay: 6500,
        deposit: 15000,
        city: 'Islamabad',
        ownerId: 'owner_areeba',
        ownerName: 'Areeba S.',
        ownerRating: 4.9,
        isOwnerVerified: true,
        artIndex: 2,
        availabilityRange: '01–10 December',
        isPromoted: false,
        bookingCount: 5,
      ),
      OutfitModel(
        id: 'outfit_4',
        title: 'Midnight gharara',
        subtitle: 'ROYAL HERITAGE',
        description:
            'Lustrous midnight blue jamawar gharara accompanied by a velvet short kurti encrusted with tilla and dabka work. Ideal for walima or high-formals.',
        designer: 'Sania Maskatiya',
        category: 'Gharara',
        availableSizes: ['M', 'L', 'XL'],
        pricePerDay: 8000,
        deposit: 18000,
        city: 'Lahore',
        ownerId: 'usr_ayesha_01',
        ownerName: 'Ayesha Khan',
        ownerRating: 4.9,
        isOwnerVerified: true,
        artIndex: 3,
        availabilityRange: '15–25 December',
        isPromoted: false,
        bookingCount: 9,
      ),
      OutfitModel(
        id: 'outfit_5',
        title: 'Emerald velvet sherwani',
        subtitle: 'GROOM EDIT',
        description:
            'Bespoke emerald green micro-velvet sherwani with ornate hand-engraved metal buttons and subtle collar bullion embroidery.',
        designer: 'Deepak Perwani',
        category: 'Sherwani',
        availableSizes: ['M', 'L', 'XL'],
        pricePerDay: 11000,
        deposit: 22000,
        city: 'Karachi',
        ownerId: 'owner_hamza',
        ownerName: 'Hamza Malik',
        ownerRating: 5.0,
        isOwnerVerified: true,
        artIndex: 1,
        availabilityRange: '10–18 December',
        isPromoted: false,
        bookingCount: 4,
      ),
      OutfitModel(
        id: 'outfit_6',
        title: 'Rosewater tissue saree',
        subtitle: 'COUTURE DRAPES',
        description:
            'Metallic rosewater pink tissue organza saree with scalloped crystal cutwork border and raw silk blouse.',
        designer: 'Suffuse by Sana Yasir',
        category: 'Saree',
        availableSizes: ['S', 'M'],
        pricePerDay: 7500,
        deposit: 16000,
        city: 'Lahore',
        ownerId: 'owner_maha',
        ownerName: 'Maha Rizvi',
        ownerRating: 4.9,
        isOwnerVerified: true,
        artIndex: 0,
        availabilityRange: '18–25 December',
        isPromoted: true,
        bookingCount: 7,
      ),
    ]);
  }

  @override
  Future<List<OutfitModel>> getOutfits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_outfits);
  }

  @override
  Stream<List<OutfitModel>> streamOutfits() {
    _controller.add(List.unmodifiable(_outfits));
    return _controller.stream;
  }

  @override
  Future<OutfitModel?> getOutfitById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _outfits.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addOutfit(OutfitModel outfit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _outfits.insert(0, outfit);
    _controller.add(List.unmodifiable(_outfits));
  }

  @override
  Future<void> updateOutfit(OutfitModel outfit) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _outfits.indexWhere((o) => o.id == outfit.id);
    if (index != -1) {
      _outfits[index] = outfit;
      _controller.add(List.unmodifiable(_outfits));
    }
  }

  @override
  Future<void> deleteOutfit(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _outfits.removeWhere((o) => o.id == id);
    _controller.add(List.unmodifiable(_outfits));
  }
}
