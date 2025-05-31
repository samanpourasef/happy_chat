import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_chat/view/chat_list.dart';
import '../models/login_model.dart';
import '../models/token_model.dart';
import '../sevices.dart';
import '../view/otp.dart';
import 'chat_controller.dart';

class LoginController extends GetxController {
  final contacts= Get.put(ChatController(myToken: "",contactToken: ""));
  final textController = TextEditingController();
  final text = ''.obs;
  final isPhoneValid = false.obs;
  final showValidationError = false.obs;
  final showValidationErrorOtp = false.obs;

  var isLoadingLogin = false.obs;
  var isLoadingOtp = false.obs;
  var loginData = Rxn<LoginModel>();
  var otpData = Rxn<TokenModel>();

  final otpTimer = 50.obs; // شمارش معکوس ثانیه‌ها
  final isResendVisible = false.obs; // نمایش دکمه "ارسال مجدد"
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      text.value = textController.text.trim();
      if(text.value.isEmpty) {
        showValidationError.value=false;
      }
    });
  }

  void validatePhone() {
    final phone = text.value;
    final regex = RegExp(r'^09\d{9}$');
    isPhoneValid.value = regex.hasMatch(phone);
    showValidationError.value = !isPhoneValid.value;
  }

  void startOtpTimer() {
    otpTimer.value = 50;
    isResendVisible.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) {
        otpTimer.value--;
      } else {
        timer.cancel();
        isResendVisible.value = true;
      }
    });
  }
  void resendOtp() {
    startOtpTimer();
    fetchLogin();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future fetchLogin() async{
    isLoadingLogin.value = true;
    try {
      var signUp = await Api.login(textController.text);
      if (signUp != null) {
        loginData.value = signUp;
        if (loginData.value!.message =="OTP has been sent successfully") {
          Get.to(OtpLogin());
        }else{
        }
      } else {

      }
    } catch (e) {
      print("خطا: $e");
    } finally {
      isLoadingLogin.value = false; // پایان بارگذاری
    }
  }

  Future fetchOtp(int otp) async{
    isLoadingOtp.value = true;
    try {
      var data = await Api.otp(textController.text,otp);
      if (data != null) {
        otpData.value = data;
        if (otpData.value!.token.isNotEmpty) {
          print('my token ${otpData.value!.token}');
          contacts.fetchContacts(otpData.value!.token);

        }else{
          showValidationErrorOtp.value=true;
        }
      } else {

      }
    } catch (e) {
      print("خطا: $e");
    } finally {
      isLoadingOtp.value = false; // پایان بارگذاری
    }
  }
}
