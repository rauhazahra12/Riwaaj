import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final IAuthService authService;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({required this.authService}) {
    _user = authService.currentUser;
    authService.authStateChanges.listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isVerified => _user?.isVerified ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authService.login(email: email, password: password);
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

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authService.signUp(name: name, email: email, password: password);
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

  Future<bool> verifyCnicAndOtp({required String otpCode, required String cnic}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authService.verifyOtp(code: otpCode, cnic: cnic);
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

  Future<void> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();
    await authService.updateProfile(updatedUser);
    _user = updatedUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await authService.logout();
    _user = null;
    notifyListeners();
  }
}
