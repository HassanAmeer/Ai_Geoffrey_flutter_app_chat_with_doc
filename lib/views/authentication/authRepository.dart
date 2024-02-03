import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> registerUser(
      {required String email, required String password, required String name}) async {
    late UserCredential result;
    try {
      result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await result.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      handleAuthExceptions(e.code);
    }
    return result.user;
  }

  bool isUserLoggedIn() {
    // print(auth.currentUser != null);
    return auth.currentUser != null;
  }

  String userUid() {
    return auth.currentUser!.uid;
  }

  Future<User?> loginUser(
      {required String email, required String password}) async {
    late UserCredential result;
    try {
      result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      handleAuthExceptions(e.code);
    }
    return result.user;
  }

  Future<void> logoutUser() async {
    return auth.signOut();
  }

  void handleAuthExceptions(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        throw "Email already used. Go to login page.";

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        throw "Wrong email/password combination.";

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        throw "No user found with this email.";

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        throw "User disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        throw "Too many requests to log into this account.";

      case "ERROR_OPERATION_NOT_ALLOWED":
        throw "Server error, please try again later.";

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        throw "Email address is invalid.";
      default:
        throw "Request failed. Please try again.";
    }
  }
}
