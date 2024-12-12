/*
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hicom_patners/controllers/get_controller.dart';
import '../firebase_options.dart';

class InitNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final List<String> _topics = ['HicomPartner_C1', 'HicomPartner_R12', 'HicomPartner_D3', 'HicomPartner_U2', 'HicomPartner'];

  static Future<void> initialize() async {
    //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');
    GetController().saveFcmToken(fcmToken ?? '');
    await FirebaseMessaging.instance.requestPermission();
    for (var topic in _topics) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
        debugPrint('Subscribed to topic: $topic');
      } catch (e) {
        debugPrint('Failed to subscribe to topic: $topic. Error: $e');
      }
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from notification: ${message.messageId}');
    });

    await _configureNotificationChannels();
  }

  static Future<void> _configureNotificationChannels() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    _showNotification(message);
    debugPrint('======================================================================================================================================================');
    debugPrint("Handling background message: ${message.messageId}");
    debugPrint("Message data: ${message.data}");
    debugPrint("Message data: ${message.notification?.body}");
    debugPrint("Message data: ${message.notification?.title}");
    debugPrint('======================================================================================================================================================');
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('======================================================================================================================================================');
    debugPrint('Foreground message: ${message.messageId}');
    debugPrint("Message data: ${message.data}");
    debugPrint("Message data: ${message.notification?.body}");
    debugPrint("Message data: ${message.notification?.title}");
    debugPrint('======================================================================================================================================================');

    GetController().saveNotificationMessage(message.data['title'] ?? 'Hicom Partner', message.notification?.body ?? message.data['body'] ?? '');
    debugPrint("Notification message saved");
    debugPrint(GetController().loadNotificationMessages());
    _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    final notificationDetails = _getNotificationDetails();
    final title = message.data['title'] ?? 'Hicom Partner';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: 'item x');
  }

  static NotificationDetails _getNotificationDetails() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      //largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    return const NotificationDetails(android: androidDetails);
  }
}*/

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';
import 'get_controller.dart';

class InitNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //_getController.getNotificationValue.value,

  static Future<void> initialize() async {
    if (GetController().getNotification() == false) {
      return;
    }
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Future<void> requestNotificationPermissions() async {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Foydalanuvchi ruxsat berdi');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('Foydalanuvchi vaqtinchalik ruxsat berdi');
      } else {
        print('Foydalanuvchi ruxsat bermadi');
      }
    }
    requestNotificationPermissions();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');
    GetController().saveFcmToken(fcmToken!);
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from notification: ${message.messageId}');
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    _showNotification(message);
    print('======================================================================================================================================================');
    print("Handling background message: ${message.messageId}");
    print("Message data: ${message.data}");
    print("Message data: ${message.notification?.body}");
    print("Message data: ${message.notification?.title}");
    print('======================================================================================================================================================');

  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('======================================================================================================================================================');
    print('Foreground message: ${message.messageId}');
    print("Message data: ${message.data}");
    print("Message data: ${message.notification?.body}");
    print("Message data: ${message.notification?.title}");
    print('======================================================================================================================================================');

    _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    final notificationDetails = _getNotificationDetails();
    final title = message.data['title'] ?? 'Hicom Partner';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: 'item x');
  }

  static NotificationDetails _getNotificationDetails() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true, // Display alert
      presentBadge: true, // Update badge
      presentSound: true, // Play notification sound
      badgeNumber: 1, // Optional: Set badge number
    );

    return const NotificationDetails(android: androidDetails, iOS: darwinDetails);
  }
}