import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/local_db_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<UserModel>();

  final LocalDbService _localDb = LocalDbService();

  @override
  void onInit() {
    super.onInit();
    _checkLocalSession();
  }

  void _checkLocalSession() async {
    final cachedUser = await _localDb.getCachedUser();
    if (cachedUser != null) {
      currentUser.value = UserModel.fromJson(cachedUser);
      isLoggedIn.value = true;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await ApiService.loginUser(email, password);

      if (response != null && response['success'] == true) {
        UserModel user = UserModel.fromJson(response);

        currentUser.value = user;
        isLoggedIn.value = true;

        await _localDb.cacheUser(user.userId!, user.userName!, user.email!);

        Get.offAllNamed('/dashboard');
      } else {
        Get.snackbar(
          "Login Failed",
          response?['message'] ?? "Invalid credentials",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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
      bool success = await ApiService.signupUser(name, email, password, phone);
      if (success) {
        Get.snackbar(
          "Success",
          "Account created! Please login.",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed('/auth');
      } else {
        Get.snackbar(
          "Error",
          "Registration failed.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _localDb.clearAllData();
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/welcome');
  }
}
