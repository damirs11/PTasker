import 'package:PTasker/models/user.dart';
import 'package:PTasker/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<User> get getUser {
    return _auth.currentUser().then(_userFromFirebaseUser);
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    if (user != null) {
      return User(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoUrl);
    } else {
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, UserUpdateInfo userUpdateInfo) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      user.updateProfile(userUpdateInfo);

      UserData userData = new UserData(
        uid: user.uid,
        displayName: userUpdateInfo.displayName,
        email: user.email,
        isAdmin: false,
      );

      await DatabaseService(uid: user.uid).updateUserData(userData);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    email = email.trim();

    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
