// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Stream of auth changes
  Stream<User?> get user => _auth.authStateChanges();
  
  // Email/Password Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      print('📧 Attempting sign in with: $email');
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      User? user = result.user;
      print('✅ Sign in successful: ${user?.uid}');
      
      return user;
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuth error: ${e.code} - ${e.message}');
      
      if (e.code == 'user-not-found') {
        throw Exception('No user found with this email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email format');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Invalid email or password');
      } else if (e.code == 'network-request-failed') {
        throw Exception('Network error. Check your internet connection');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('❌ Unknown error: $e');
      throw Exception('Login failed: $e');
    }
  }
  
  // Email/Password Sign Up
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      print('📝 Creating account for: $email');
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      User? user = result.user;
      
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        
        // Create user document
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'isGuest': false,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
      
      print('✅ Account created: ${user?.uid}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('❌ Sign up error: ${e.code} - ${e.message}');
      
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already in use');
      } else if (e.code == 'weak-password') {
        throw Exception('Password too weak');
      } else {
        throw Exception('Sign up failed: ${e.message}');
      }
    }
  }
  
  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      GoogleAuthProvider provider = GoogleAuthProvider();
      UserCredential result = await _auth.signInWithPopup(provider);
      return result.user;
    } catch (e) {
      print('❌ Google sign in error: $e');
      throw Exception('Google sign in failed');
    }
  }
  
  // Guest Sign In
  Future<User?> signInAsGuest() async {
    try {
      print('👤 Signing in as guest');
      
      // Check if already signed in as guest
      if (_auth.currentUser?.isAnonymous ?? false) {
        return _auth.currentUser;
      }
      
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'isGuest': true,
          'chatsRemaining': 20,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
      
      print('✅ Guest sign in successful');
      return user;
    } catch (e) {
      print('❌ Guest sign in error: $e');
      throw Exception('Guest login failed');
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  // Check if user is guest
  bool get isGuest => _auth.currentUser?.isAnonymous ?? false;
}