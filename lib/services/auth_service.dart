import 'dart:async';
import '../models/user_model.dart';

abstract class IAuthService {
  UserModel? get currentUser;
  Stream<UserModel?> get authStateChanges;

  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> sendOtp({required String phone});
  Future<UserModel> verifyOtp({required String code, required String cnic});
  Future<void> updateProfile(UserModel user);
  Future<void> logout();
}

class MockAuthService implements IAuthService {
  final _controller = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  MockAuthService() {
    // Default initial authenticated user for seamless testing
    _currentUser = const UserModel(
      id: 'usr_ayesha_01',
      name: 'Ayesha Khan',
      email: 'ayesha@email.com',
      phone: '+92 300 1234567',
      cnic: '12345-1234567-1',
      isVerified: true,
      city: 'Lahore',
      rating: 4.9,
      listingsCount: 6,
      rentalsCount: 14,
      boutiqueName: 'Noor Boutique',
      avatarInitials: 'AK',
    );
    _controller.add(_currentUser);
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final initials = email.isNotEmpty ? email.substring(0, 1).toUpperCase() : 'U';
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first.replaceAll('.', ' ').toUpperCase(),
      email: email,
      avatarInitials: initials,
      isVerified: true,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final parts = name.trim().split(' ');
    final initials = parts.length > 1
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : 'U';

    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      avatarInitials: initials,
      isVerified: false,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> sendOtp({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserModel> verifyOtp({required String code, required String cnic}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        cnic: cnic,
        isVerified: true,
      );
      _controller.add(_currentUser);
      return _currentUser!;
    }
    _currentUser = UserModel(
      id: 'usr_verified_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Ayesha Khan',
      email: 'ayesha@email.com',
      cnic: cnic,
      isVerified: true,
    );
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    _currentUser = user;
    _controller.add(_currentUser);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _controller.add(null);
  }
}
