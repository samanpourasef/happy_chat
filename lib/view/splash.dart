import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:happy_chat/controllers/chat_controller.dart';
import 'chat_list.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final contact = Get.put(ChatController(myToken: "", contactToken: ""));

  @override
  Widget build(BuildContext context) {
    checkToken();

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void checkToken() async {
    await Future.delayed(const Duration(seconds: 1));
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'token');
    if (token != null && token.isNotEmpty) {

      contact.fetchContacts(token);
      Get.offAll(() => ChatList(token: token));
    } else {

      Get.offAllNamed('/login');
    }
  }
}
