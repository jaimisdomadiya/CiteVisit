import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static String firebaseToken = '';
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  static Future initialize() async {
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_notification');

    DarwinInitializationSettings initializationSettingsDarwin =
        const DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      log('getInitialMessage==> $message');
      log('getInitialMessage==> ${message?.notification?.title}');
      //kill app
      if (message != null) {
        notificationClick(message);
      }
    });

    ///Foreground Message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('onMessage title==> ${message.notification?.title}');
      log('onMessage message==> ${message.notification?.body}');
      log('onMessage data==> ${message.data}');

      RemoteNotification? notification = message.notification;
      if (notification != null) {
        if (Platform.isAndroid) {
          displayNotification(message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onMessageOpenedApp==> $message');
      log('onMessageOpenedApp==> ${message.notification?.title}');
      notificationClick(message);
    });
  }

  static Future<void> getToken() async {
    try {
      firebaseToken = await FirebaseMessaging.instance.getToken() ?? '';
      log(firebaseToken, name: "Token");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log("onBackgroundMessage: $message");
    await Firebase.initializeApp();
  }

  static Future<void> selectNotification(
      NotificationResponse? payloadData) async {
    log('selectNotification: ${payloadData?.notificationResponseType}');
    log('selectNotification: ${payloadData?.id}');
    log('selectNotification: ${payloadData?.input}');
    log('selectNotification: ${payloadData?.payload}');
    Map<String, dynamic> payLoadMap = jsonDecode(payloadData?.payload ?? '');
    if (payloadData?.payload?.isNotEmpty ?? false) {
      log("${payloadData?.payload}");
    }
  }

  static Future<void> notificationClick(RemoteMessage message) async {
    String type = message.data['message'];

    log('Notification Type ==> $type');
    log('Notification Type ==> ${message.data}', name: "Notification Type");
    log('Notification Type ==>}', name: "Notification Type");
  }

  static Future<void> displayNotification(RemoteMessage message) async {
    String payloadText = "", title, notificationMsg;
    RemoteNotification? notification = message.notification;
    title = notification!.title ?? "";
    notificationMsg = notification.body ?? "";
    // title = message.data["push_title"];
    // notificationMsg = message.data["push_message"];
    payloadText = jsonEncode(message.data);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'business_channel',
      'business',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      playSound: true,
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
      categoryIdentifier: darwinNotificationCategoryPlain,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    log(payloadText, name: 'payLoadDatta');
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      notificationMsg,
      platformChannelSpecifics,
      payload: payloadText,
    );
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }
}
