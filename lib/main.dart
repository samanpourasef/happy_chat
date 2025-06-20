import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_chat/bindings/bindins.dart';
import 'package:happy_chat/themes.dart';
import 'package:happy_chat/view/chat_list.dart';
import 'package:happy_chat/view/direct.dart';
import 'package:happy_chat/view/login.dart';
import 'package:happy_chat/view/otp.dart';
import 'package:happy_chat/view/splash.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      getPages: [
        GetPage(name: '/login', page: () => Login(),),
        GetPage(name: '/otp', page: () => OtpLogin(),),
        GetPage(name: '/ChatList', page: () => ChatList(token: "",),),
        GetPage(name: '/Direct', page: () => Direct(username: "",myToken: '',contactToken: '',),),
        GetPage(name: '/splash', page: () =>  SplashPage()),
      ],
      initialBinding: MyBinding(),
      initialRoute: '/splash',

    );
  }
}

