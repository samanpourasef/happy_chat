import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_chat/controllers/login_controller.dart';
import 'package:happy_chat/themes.dart';
import 'package:happy_chat/view/otp.dart';
import 'package:happy_chat/widget/texts.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final login = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
                    padding: EdgeInsets.only(top: Get.width / 3.5, bottom: 20),
                    child: Text(
                      TextsView.textHeader,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      TextsView.textNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  // textfield
                  Obx(() {
                    return Container(
                      width: Get.width / 1.2,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: login.showValidationError.value?Colors.red:Colors.grey, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              Image.asset('assets/images/flag.png'),
                              VerticalDivider(
                                width: 20,
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: login.textController,
                                        keyboardType: TextInputType.phone,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: TextsView.textHint,
                                            hintStyle: Theme.of(context).textTheme.labelMedium),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
                  Obx(() => Visibility(
                        visible: login.showValidationError.value,
                        child: Text(
                          TextsView.textError,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(child: Container()),

                  Obx(
                    () {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: login.text.value.isEmpty ? WidgetStateProperty.all(Colors.grey) : WidgetStateProperty.all(Colors.black), // مثال
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async  {
                          login.validatePhone();
                          await login.fetchLogin();

                        },
                        child: SizedBox(
                          width: Get.width / 1.3, // یک‌سوم عرض
                          child: Center(
                            child: login.isLoadingLogin.value ?CircularProgressIndicator(color: Colors.white,) :Text(
                              TextsView.textButton,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Expanded(child: Container())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
