import 'package:get/get.dart';
import 'package:happy_chat/controllers/login_controller.dart';

import '../controllers/chat_controller.dart';
class MyBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    // TODO: implement dependencies
  }

}