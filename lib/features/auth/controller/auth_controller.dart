import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_routes.dart';
import 'package:flutter_app/core/constants/widgets/snak_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_app/core/pereferences/shared_pref.dart';

class AuthController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phoneNum = TextEditingController();
  final formkeylogin = GlobalKey<FormState>();
  final formkeysignup = GlobalKey<FormState>();
  final formkeyforget = GlobalKey<FormState>();
  final formkeynewpass = GlobalKey<FormState>();
  final formkeyverify = GlobalKey<FormState>();

  var showPassIcon = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    showPassIcon.value = !showPassIcon.value;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
  }

  void _loadSavedData() {
    email.text = SharedPrefs.getString(SharedPrefs.email);
    username.text = SharedPrefs.getString(SharedPrefs.username);
    phoneNum.text = SharedPrefs.getString(SharedPrefs.phoneNumber);
  }

  void signUpFunc() {
    try {
      isLoading.value = true;

      SharedPrefs.setBoolean(SharedPrefs.isLogin, true);
      SharedPrefs.setString(SharedPrefs.username, username.text);
      SharedPrefs.setString(SharedPrefs.email, email.text);
      SharedPrefs.setString(SharedPrefs.password, password.text);
      SharedPrefs.setString(SharedPrefs.phoneNumber, phoneNum.text);

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginFunc() async {
    try {
      isLoading.value = true;

      // استرجاع البيانات المحفوظة
      final savedEmail = SharedPrefs.getString(SharedPrefs.email);
      final savedPassword = SharedPrefs.getString(SharedPrefs.password);
      final savedUsername = SharedPrefs.getString(SharedPrefs.username);
      final savedPhone = SharedPrefs.getString(SharedPrefs.phoneNumber);

      // التحقق من بيانات الدخول مقابل البيانات المحفوظة
      if ((email.text == savedEmail ||
              (username.text == savedUsername && phoneNum.text == savedPhone)) &&
          password.text == savedPassword) {
        await SharedPrefs.setBoolean(SharedPrefs.isLogin, true);
        Get.offAllNamed(AppRoutes.home);
      } else {
        showSnakBar(title: "Error", msg: "بيانات الدخول غير صحيحة", color: Colors.red);
      }
    } catch (e) {
      showSnakBar(title: "Error", msg: e.toString(), color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await SharedPrefs.setBoolean(SharedPrefs.isLogin, false);
    clearTextField();
    Get.offAllNamed(AppRoutes.home);
  }

  void clearTextField() {
    username.clear();
    email.clear();
    password.clear();
    phoneNum.clear();
  }
}
