import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  final _controller = StreamController<UserModel?>.broadcast();

  FirebaseAuthService() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        _currentUser = await _fetchUserProfile(firebaseUser.uid, firebaseUser.email ?? '');
      } else {
        _currentUser = null;
      }
      _controller.add(_currentUser);
    });
  }

  Future<UserModel> _fetchUserProfile(String uid, String email) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, docId: uid);
      }
    } catch (_) {}

    final name = email.split('@').first.replaceAll('.', ' ');
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final newUser = UserModel(
      id: uid,
      name: name,
      email: email,
      avatarInitials: initials,
    );
    await _firestore.collection('users').doc(uid).set(newUser.toMap(), SetOptions(merge: true));
    return newUser;
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _currentUser = await _fetchUserProfile(cred.user!.uid, email);
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final parts = name.trim().split(' ');
    final initials = parts.length > 1
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : 'U';

    final newUser = UserModel(
      id: cred.user!.uid,
      name: name,
      email: email,
      avatarInitials: initials,
      isVerified: false,
    );

    await _firestore.collection('users').doc(cred.user!.uid).set(newUser.toMap());
    _currentUser = newUser;
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> sendOtp({required String phone}) async {
    // Phone auth hook for Firebase Auth
  }

  @override
  Future<UserModel> verifyOtp({required String code, required String cnic}) async {
    if (_currentUser != null) {
      final updated = _currentUser!.copyWith(cnic: cnic, isVerified: true);
      await _firestore.collection('users').doc(_currentUser!.id).update({
        'cnic': cnic,
        'isVerified': true,
      });
      _currentUser = updated;
      _controller.add(_currentUser);
      return _currentUser!;
    }
    return _currentUser!;
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap(), SetOptions(merge: true));
    _currentUser = user;
    _controller.add(_currentUser);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _controller.add(null);
  }
}
