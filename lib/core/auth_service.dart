import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_client.dart';


class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool ready = false;

  User? get user => _auth.currentUser;
  bool get isSignedIn => user != null;

  void init() {
    _auth.authStateChanges().listen((_) async {
      ready = true;
      ApiClient.instance.tokenProvider = idToken;
      if (isSignedIn) {
        await _registerPushToken();
      }
      notifyListeners();
    });
  }
  

//   void init() {
//   _auth.authStateChanges().listen((_) {
//     ready = true;
//     ApiClient.instance.tokenProvider = idToken;
//     notifyListeners();            // navigate immediately on auth change
//     if (isSignedIn) {
//       _registerPushToken();       // fire-and-forget, don't block the UI
//     }
//   });
// }

Future<String?> idToken() async => _auth.currentUser?.getIdToken();

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

Future<void> signInWithGoogle() async {
  if (kIsWeb) {
    // Web: Firebase handles the OAuth popup using firebase_options.dart config.
    final provider = GoogleAuthProvider();
    await _auth.signInWithPopup(provider);
    return;
  }
  // Mobile: use the google_sign_in plugin.
  final g = await GoogleSignIn().signIn();
  if (g == null) return;
  final auth = await g.authentication;
  final cred = GoogleAuthProvider.credential(
    accessToken: auth.accessToken,
    idToken: auth.idToken,
  );
  await _auth.signInWithCredential(cred);
}

  Future<void> signInWithApple() async {
    final appleCred = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final oauth = OAuthProvider('apple.com').credential(
      idToken: appleCred.identityToken,
      accessToken: appleCred.authorizationCode,
    );
    await _auth.signInWithCredential(oauth);
  }

  Future<void> signOut() async => _auth.signOut();

  // Future<void> _registerPushToken() async {
  //   try {
  //     await FirebaseMessaging.instance.requestPermission();
  //     final token = await FirebaseMessaging.instance.getToken();
  //     if (token != null) {
  //       await ApiClient.instance.post('/users/fcm-token', {'fcmToken': token});
  //     }
  //   } catch (_) {/* push optional in MVP */}
  // }

  Future<void> _registerPushToken() async {
  if (kIsWeb) return;   // FCM web needs a VAPID key + service worker; skip for MVP
  try {
    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await ApiClient.instance.post('/users/fcm-token', {'fcmToken': token});
    }
  } catch (_) {/* push optional in MVP */}
}
}
