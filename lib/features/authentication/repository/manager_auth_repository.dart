// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../model/manager_model.dart';

// class ManagerAuthRepository {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<void> registerManager({
//     required String name,
//     required String email,
//     required String phone,
//     required String password,
//   }) async {
//     try {
//       final credential =
//           await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final uid = credential.user!.uid;

//       ManagerModel manager = ManagerModel(
//         uid: uid,
//         name: name,
//         email: email,
//         phone: phone,
//         isVerified: false,
//         venueSubmitted: false,
//         verificationStatus: "not_submitted",
//       );

//       await firestore
//           .collection("managers")
//           .doc(uid)
//           .set(manager.toMap());
//     } catch (e) {
//       rethrow;
//     }
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_venue_manager/features/authentication/model/manager_model.dart';

class ManagerAuthException implements Exception {
  final String message;

  const ManagerAuthException(this.message);

  @override
  String toString() => message;
}

class ManagerAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ManagerAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> registerManager({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const ManagerAuthException(
          "Manager account could not be created.",
        );
      }

      final ManagerModel manager = ManagerModel(
        uid: firebaseUser.uid,
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        isVerified: false,
        venueSubmitted: false,
        verificationStatus: "not_submitted",
      );

      await _firestore.collection("managers").doc(firebaseUser.uid).set({
        ...manager.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (error) {
      throw ManagerAuthException(
        _getAuthErrorMessage(error.code),
      );
    } on FirebaseException catch (error) {
      throw ManagerAuthException(
        error.message ?? "Manager information could not be saved.",
      );
    } on ManagerAuthException {
      rethrow;
    } catch (_) {
      throw const ManagerAuthException(
        "Something went wrong while registering.",
      );
    }
  }

  Future<ManagerModel> loginManager({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const ManagerAuthException(
          "Manager login failed.",
        );
      }

      final DocumentSnapshot<Map<String, dynamic>> managerDocument =
          await _firestore
              .collection("managers")
              .doc(firebaseUser.uid)
              .get();

      final Map<String, dynamic>? managerData = managerDocument.data();

      // The Firebase account exists, but it is not a manager account.
      if (!managerDocument.exists || managerData == null) {
        await _auth.signOut();

        throw const ManagerAuthException(
          "This account is not registered as a manager.",
        );
      }

      return ManagerModel.fromMap(managerData);
    } on FirebaseAuthException catch (error) {
      throw ManagerAuthException(
        _getAuthErrorMessage(error.code),
      );
    } on FirebaseException catch (error) {
      throw ManagerAuthException(
        error.message ?? "Manager information could not be loaded.",
      );
    } on ManagerAuthException {
      rethrow;
    } catch (_) {
      throw const ManagerAuthException(
        "Something went wrong while logging in.",
      );
    }
  }

  Future<void> logoutManager() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw ManagerAuthException(
        error.message ?? "Logout failed.",
      );
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "Please enter a valid email address.";

      case "user-not-found":
        return "No account was found with this email.";

      case "wrong-password":
        return "The password you entered is incorrect.";

      case "invalid-credential":
        return "The email or password is incorrect.";

      case "email-already-in-use":
        return "An account already exists with this email.";

      case "weak-password":
        return "The password must contain at least 6 characters.";

      case "user-disabled":
        return "This manager account has been disabled.";

      case "too-many-requests":
        return "Too many attempts. Please try again later.";

      case "network-request-failed":
        return "Please check your internet connection.";

      case "operation-not-allowed":
        return "Email and password login is not enabled.";

      default:
        return "Authentication failed. Please try again.";
    }
  }
}