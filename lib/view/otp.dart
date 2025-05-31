import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_chat/controllers/login_controller.dart';
import 'package:happy_chat/themes.dart';
import 'package:happy_chat/view/chat_list.dart';
import 'package:happy_chat/widget/texts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpLogin extends StatelessWidget {
  OtpLogin({super.key});

  final login = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    login.startOtpTimer();
    return WillPopScope(
      onWillPop: () async{
        login.showValidationErrorOtp.value=false;
        return true;
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFffeeeb),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              width: Get.width,
              height: Get.height,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              login.showValidationErrorOtp.value=false;
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Color(0xff2434431A)
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_back,size: 18,),
                                  ),
                                ),
                                SizedBox(width: 2,),
                                Text("بازگشت"),
                              ],
                            ),
                          ),

                          Expanded(child: Container()),

                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: Get.width / 3.5, bottom: 20),
                      child: Text(
                        TextsView.textHeader,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        TextsView.textOtp,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    // textfield

                    Obx(() => Visibility(
                          visible: login.showValidationError.value,
                          child: Text(
                            TextsView.textOtpError,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: OtpTextField(

                        keyboardType: TextInputType.number,
                        fieldHeight: 60,
                        fieldWidth: 60,
                        numberOfFields: 4,
                        borderColor: Color(0xFFEB5757),
                        cursorColor: Colors.grey,
                        fillColor: Color(0xFFEB5757),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        focusedBorderColor: Color(0xFFEB5757),
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        showFieldAsBox: true,

                        onSubmit: (value) async {
                          int number = int.parse(value);
                         await login.fetchOtp(number);
                         // Get.to(ChatList());
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Obx(() => Visibility(
                      visible: login.showValidationErrorOtp.value,
                      child: Text(
                        TextsView.textOtpError,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )),
                    SizedBox(height: 10,),
                    Obx(() {
                      return login.isLoadingOtp.value?
                          CircularProgressIndicator(color: Color(0xffDA7E70),):login.isResendVisible.value
                          ? TextButton(
                        onPressed: () {
                          login.resendOtp();
                          login.showValidationErrorOtp.value=false;
                        },
                        child: Text(
                          TextsView.textOtpResend,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                          : Text(
                        "ارسال مجدد تا ${login.otpTimer} ثانیه دیگر",
                        style: Theme.of(context).textTheme.labelMedium,
                      );
                    }),
                    Expanded(child: Container())

                    // Expanded(child: Container())
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
