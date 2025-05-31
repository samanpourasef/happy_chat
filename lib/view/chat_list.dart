import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_chat/controllers/login_controller.dart';
import 'package:happy_chat/view/direct.dart';
import 'package:happy_chat/widget/texts.dart';
import '../controllers/chat_controller.dart';

class ChatList extends StatelessWidget {
  final String token;
  ChatList({super.key, required this.token});

  final contact = Get.find<ChatController>();
  final login = Get.find<LoginController>();
  final Map<String, String> profileImages = {
    "ریک سانچز": "assets/images/rick.png",
    "مورتی اسمیت": "assets/images/morty.png",
    "بت اسمیت": "assets/images/bes.png",
    "سامر اسمیت": "assets/images/samer.png",
  };

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(() {
          if(contact.contacts.value!=null){
            return Scaffold(
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
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.search),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/rick.png'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(

                        child: ListView.separated(
                            itemCount: contact.contacts.value!.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Get.to(Direct(
                                    username: contact.contacts.value!.data[index].name,
                                    contactToken: contact.contacts.value!.data[index].token,
                                    myToken: login.contacts.myToken,
                                  ));
                                  contact.setupMqtt();
                                },
                                title: Text(
                                  contact.contacts.value!.data[index].name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(TextsView.textSubtitle, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 14)),
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    profileImages[contact.contacts.value!.data[index].name] ?? 'assets/images/flag.png',
                                  ),
                                ),
                                trailing: Text(TextsView.textTrialing, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 12)),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              height: 1,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        },),
      ),
    );
  }
}
