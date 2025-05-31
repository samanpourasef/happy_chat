import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:happy_chat/widget/back_button.dart';
import '../controllers/chat_controller.dart';
import 'package:happy_chat/widget/texts.dart';

class Direct extends StatelessWidget {
  final String username;
  final String myToken;
  final String contactToken;
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Direct({super.key, required this.username, required this.myToken, required this.contactToken});

  final TextEditingController messageController = TextEditingController();

  final Map<String, String> profileImages = {
    "ریک سانچز": "assets/images/rick.png",
    "مورتی اسمیت": "assets/images/morty.png",
    "بت اسمیت": "assets/images/bes.png",
    "سامر اسمیت": "assets/images/samer.png",
  };

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController(
      myToken: myToken,
      contactToken: contactToken,
    ));
    print('token ${myToken}   ${contactToken}');
    return WillPopScope(
      onWillPop: () async{
        controller.client.disconnect();
        controller.messages.clear();
        return true;
      },
      child: SafeArea(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage(
                    profileImages[username] ?? 'assets/images/flag.png',
                  )),
                  SizedBox(
                    width: 0.1,
                  ),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  BackButtonRow(
                    onTap: () {
                      Get.back();
                      controller.client.disconnect();
                      controller.messages.clear();
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Obx(() {
              return controller.messages.isEmpty
                  ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/portal.png'),
                        SizedBox(height: 12,),
                        Text(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          TextsView.textFirstDirect,
                        )
                      ],
                    ),
                  ))
                  : Expanded(
                child: Obx(() {
                  WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: controller.messages.length,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      return Align(
                        alignment: msg.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                          decoration: BoxDecoration(
                            color: msg.isSentByMe ? const Color(0xffFDE7A9) : const Color(0xffF2B6B6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text.replaceFirst(RegExp(r'ID:\d+\s*'), ''),
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  );
                }),
              );
            },),

            const Divider(height: 1),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Color(0xFFffeeeb),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 22,
                        ),
                        onPressed: () {
                          final text = textController.text.trim();
                          if (text.isNotEmpty) {
                            controller.publishMessage(text);
                            textController.clear();
                            scrollToBottom();
                          }
                        },
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: TextsView.textNewMessage,
                              hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ))),
    );
  }
}
