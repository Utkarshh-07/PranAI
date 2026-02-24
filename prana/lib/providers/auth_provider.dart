// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  
  AuthProvider() {
    _authService.user.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _user?.isAnonymous ?? false;
  
  Future<User?> signInAsGuest() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      User? user = await _authService.signInAsGuest();
      return user;
    } catch (e) {
      print('❌ Guest sign in error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<User?> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      User? user = await _authService.signInWithEmail(email, password);
      return user;
    } catch (e) {
      print('❌ Email sign in error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      User? user = await _authService.signUpWithEmail(email, password, name);
      return user;
    } catch (e) {
      print('❌ Sign up error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<User?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      User? user = await _authService.signInWithGoogle();
      return user;
    } catch (e) {
      print('❌ Google sign in error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
  
  // REMOVED: useGuestChat() method - not needed for now
  // If you need it later, we'll add it properly
}