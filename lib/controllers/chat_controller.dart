import 'dart:convert';
import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../models/contact_model.dart';
import '../sevices.dart';
import '../view/chat_list.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController{
  var isLoadingChatList = false.obs;
  var contacts = Rxn<ContactModel>();
  late MqttServerClient client;
  final messages = <ChatMessage>[].obs;
  final String myToken;
  final String contactToken;
  late String topic;
  final connectionStatus = Rx<MqttConnectionState>(MqttConnectionState.disconnected);


  String? _lastSentMessageId;

  ChatController({
    required this.myToken,
    required this.contactToken,
  });

  Future fetchContacts(String token) async{
    isLoadingChatList.value = true;
    try {
      var data = await Api.token(token);
      if (data != null) {
        contacts.value = data;
        if (contacts.value!.data.isNotEmpty) {
          Get.to(ChatList(token:token));
        }else{
        }
      }
    } catch (e) {
      print("خطا: $e");
    } finally {
      isLoadingChatList.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    setupMqtt();
  }

  void setupMqtt() {
    client = MqttServerClient('185.204.197.138', '');
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    final connMess = MqttConnectMessage()
        .authenticateAs('challenge', 'sdjSD12\$5sd')
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;
    _connect();
  }

  Future<void> _connect() async {
    try {
      connectionStatus.value = MqttConnectionState.connecting;
      await client.connect();
    } catch (e) {
      connectionStatus.value = MqttConnectionState.faulted;
      print('Exception: $e');
      SnackbarController(GetSnackBar(
        title: "اخطار",
        message: "اتصال برقرار نشد",
        backgroundColor: Colors.red,
      ));
    }
  }


  void _onConnected() {
    connectionStatus.value = MqttConnectionState.connected;
    final topic = 'challenge/user/$contactToken/$myToken';
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      // تغییر این خط برای استفاده از UTF-8
      final message = utf8.decode(recMess.payload.message);
      if (_lastSentMessageId != null && message.contains('ID:$_lastSentMessageId')) {
        _lastSentMessageId = null;
      } else {
        messages.add(ChatMessage(text: message, isSentByMe: false));
      }
    });
  }

  void publishMessage(String message) {
    if (connectionStatus.value == MqttConnectionState.connected) {
      final topic = 'challenge/user/$contactToken/$myToken';
      final builder = MqttClientPayloadBuilder();
      _lastSentMessageId = DateTime.now().millisecondsSinceEpoch.toString();
      final fullMessage = 'ID:$_lastSentMessageId $message';
      // تغییر این خط برای استفاده از UTF-8
      builder.addUTF8String(fullMessage);
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      messages.add(ChatMessage(text: message, isSentByMe: true));
    } else {
      print('Cannot publish - not connected');
    }
  }

  void _onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void _onDisconnected() {
    connectionStatus.value = MqttConnectionState.disconnected;
    print('Disconnected from MQTT');
  }


  @override
  void onClose() {
    client.disconnect();
    super.onClose();
  }
}