import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:neptune_app/common/user_profile/user_profile.dart';

class UserRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  UserRepository({required this.firebaseAuth, required this.firestore});

  Future<UserCredential> register({
    required String email,
    required String password
  }) {
    return firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  Future<UserCredential> authenticate({
    required String email,
    required String password
  }) {
    return firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  User? currentUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> logout() {
    return firebaseAuth.signOut();
  }

  Future<bool> isLoggedIn() async {
    return currentUser() != null;
  }

  Future<bool> startFirebaseUI() async {
    final providers = [
      AuthUiProvider.phone,
      AuthUiProvider.email,
    ];

    return FlutterAuthUi.startUi(
      items: providers,
      tosAndPrivacyPolicy: TosAndPrivacyPolicy(
        tosUrl: "https://www.google.com",
        privacyPolicyUrl: "https://www.google.com",
      ),
      androidOption: AndroidOption(
        enableSmartLock: false, // default true
        showLogo: false, // default false
        overrideTheme: true, // default false
      ),
      emailAuthOption: EmailAuthOption(
        requireDisplayName: true, // default true
        enableMailLink: false, // default false
        handleURL: '',
        androidPackageName: '',
        androidMinimumVersion: '',
      ),
    );
  }

  Stream<UserProfile?> getCurrentProfileStream() async* {
    if (!(await isLoggedIn())) {
      yield null;
    }

    var snapshots = firestore.collection('users').doc(currentUser()?.uid.toString()).snapshots();
    await for (var snapshot in snapshots) {
      var data = snapshot.data();

      if (data == null) {
        yield null;
        continue;
      }

      yield UserProfile(
        userType: UserType.values[data['userType']],
      );
    }
  }

  Future<bool> setUserProfile(UserProfile profile) async {
    if (!(await isLoggedIn())) {
      return false;
    }

    await firestore.collection('users').doc(currentUser()?.uid.toString()).set({
      'userType': profile.userType.index,
    });

    return true;
  }
}