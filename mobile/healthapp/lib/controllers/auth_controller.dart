import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/local_db_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<UserModel>();

  final Rxn<User> _firebaseUser = Rxn<User>();

  final LocalDbService _localDb = LocalDbService();

  @override
  void onInit() {
    super.onInit();

    _firebaseUser.bindStream(_auth.authStateChanges());

    ever(_firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user == null) {
      isLoggedIn.value = false;
      Get.offAllNamed('/welcome');
    } else {
      isLoggedIn.value = true;

      _checkLocalSession();
      Get.offAllNamed('/dashboard');
    }
  }

  void _checkLocalSession() async {
    final cachedUser = await _localDb.getCachedUser();
    if (cachedUser != null) {
      currentUser.value = UserModel.fromJson(cachedUser);
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final response = await ApiService.getUserByUid(cred.user!.uid);

      if (response != null) {
        UserModel user = UserModel.fromJson(response);
        currentUser.value = user;
        await _localDb.cacheUser(user.userId!, user.userName!, user.email!);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Error",
        e.message ?? "Authentication failed",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    isLoading.value = true;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      bool success = await ApiService.signupUser(
        uid: cred.user!.uid,
        name: name,
        email: email,
        phone: phone,
      );

      if (success) {
        Get.snackbar("Success", "Account created successfully!");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    await _localDb.clearAllData();
    currentUser.value = null;
  }
}
