import 'package:flutter/foundation.dart';
import '../models/outfit_model.dart';
import '../services/outfit_service.dart';

class OutfitProvider extends ChangeNotifier {
  final IOutfitService outfitService;

  List<OutfitModel> _allOutfits = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  double _minPrice = 1000;
  double _maxPrice = 50000;
  String? _selectedCity;
  final Set<String> _selectedSizes = {};

  final Set<String> _favoriteIds = {'outfit_1', 'outfit_2'}; // Initial favorites
  OutfitModel? _selectedOutfit;

  OutfitProvider({required this.outfitService}) {
    loadOutfits();
    outfitService.streamOutfits().listen((outfits) {
      _allOutfits = outfits;
      notifyListeners();
    });
  }

  void applyFilters({
    required double min,
    required double max,
    String? city,
    required Set<String> sizes,
  }) {
    _minPrice = min;
    _maxPrice = max;
    _selectedCity = city;
    _selectedSizes.clear();
    _selectedSizes.addAll(sizes);
    notifyListeners();
  }

  List<OutfitModel> get allOutfits => _allOutfits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String? get selectedCity => _selectedCity;
  Set<String> get selectedSizes => _selectedSizes;
  Set<String> get favoriteIds => _favoriteIds;
  OutfitModel? get selectedOutfit => _selectedOutfit;

  List<OutfitModel> get filteredOutfits {
    return _allOutfits.where((outfit) {
      // Category filter
      if (_selectedCategory != 'All' &&
          outfit.category.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }

      // Search query filter
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final matchTitle = outfit.title.toLowerCase().contains(q);
        final matchDesigner = outfit.designer.toLowerCase().contains(q);
        final matchCity = outfit.city.toLowerCase().contains(q);
        final matchDesc = outfit.description.toLowerCase().contains(q);
        if (!matchTitle && !matchDesigner && !matchCity && !matchDesc) {
          return false;
        }
      }

      // Price filter
      if (outfit.pricePerDay < _minPrice || outfit.pricePerDay > _maxPrice) {
        return false;
      }

      // City filter
      if (_selectedCity != null && _selectedCity!.isNotEmpty && _selectedCity != 'All Cities') {
        if (outfit.city.toLowerCase() != _selectedCity!.toLowerCase()) {
          return false;
        }
      }

      // Size filter
      if (_selectedSizes.isNotEmpty) {
        final hasSizeMatch = outfit.availableSizes.any((s) => _selectedSizes.contains(s));
        if (!hasSizeMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<OutfitModel> get savedOutfits {
    return _allOutfits.where((o) => _favoriteIds.contains(o.id)).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setCity(String? city) {
    _selectedCity = city;
    notifyListeners();
  }

  void toggleSizeFilter(String size) {
    if (_selectedSizes.contains(size)) {
      _selectedSizes.remove(size);
    } else {
      _selectedSizes.add(size);
    }
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _minPrice = 1000;
    _maxPrice = 50000;
    _selectedCity = null;
    _selectedSizes.clear();
    notifyListeners();
  }

  void selectOutfit(OutfitModel outfit) {
    _selectedOutfit = outfit;
    notifyListeners();
  }

  void selectOutfitById(String id) {
    try {
      _selectedOutfit = _allOutfits.firstWhere((o) => o.id == id);
      notifyListeners();
    } catch (_) {}
  }

  bool isFavorite(String outfitId) => _favoriteIds.contains(outfitId);

  void toggleFavorite(String outfitId) {
    if (_favoriteIds.contains(outfitId)) {
      _favoriteIds.remove(outfitId);
    } else {
      _favoriteIds.add(outfitId);
    }
    notifyListeners();
  }

  Future<void> loadOutfits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allOutfits = await outfitService.getOutfits();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addListing(OutfitModel outfit) async {
    _isLoading = true;
    notifyListeners();

    try {
      await outfitService.addOutfit(outfit);
      _allOutfits.insert(0, outfit);
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
}
