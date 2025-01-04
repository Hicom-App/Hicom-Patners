import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hicom_patners/controllers/get_controller.dart';
import '../firebase_options.dart';

/*class InitNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final List<String> _topics = ['HicomPartner_C1', 'HicomPartner_R12', 'HicomPartner_D3', 'HicomPartner_U2', 'HicomPartner'];

  static Future<void> initialize() async {
    if (GetController().getNotification() == false) {
      return;
    }
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
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
    debugPrint('======================================================================================================================================================');
    debugPrint("Handling background message: ${message.messageId}");
    debugPrint("Message data: ${message.data}");
    debugPrint("Message data: ${message.notification?.body}");
    debugPrint("Message data: ${message.notification?.title}");
    debugPrint('======================================================================================================================================================');
    GetController().loadNotificationMessages();
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
    );
    return const NotificationDetails(android: androidDetails);
  }
}*/


class InitNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final List<String> _topics = ['HicomPartner_C1', 'HicomPartner_R12', 'HicomPartner_D3', 'HicomPartner_U2', 'HicomPartner'];
  static bool _isInitialized = false;

  // Asosiy sozlash funksiyasi
  static Future<void> initialize() async {
    if (_isInitialized || !GetController().getNotification()) {
      return;
    }
    _isInitialized = true;
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: $fcmToken');
      GetController().saveFcmToken(fcmToken ?? '');
      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        debugPrint('Xabarnoma orqali ochilgan: ${message.messageId}');
      });

      await _configureNotificationChannels();
    } catch (e) {
      debugPrint('Xabarlarni sozlashda xatolik: $e');
    }
  }

  // Mavzular bo'yicha obuna bo'lish
  static Future<void> subscribeToTopics() async {
    for (var topic in _topics) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
        debugPrint('Mavzuga obuna bo\'lindi: $topic');
      } catch (e) {
        debugPrint('Mavzuga obuna bo\'lishda xatolik: $topic. Xato: $e');
      }
    }
  }

  // Mahalliy xabarnomalarni sozlash
  static Future<void> _configureNotificationChannels() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Fondagi xabarlarni qayta ishlash
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('Fondagi xabarni qayta ishlash: ${message.messageId}');
    GetController().saveNotificationMessage(
      message.data['title'] ?? 'Hicom Partner',
      message.notification?.body ?? message.data['body'] ?? '',
    );
    _showNotification(message);
  }

  // Xabarlarni ko'rsatish
  static Future<void> _showNotification(RemoteMessage message) async {
    final notificationDetails = _getNotificationDetails();
    final title = message.data['title'] ?? 'Hicom Partner';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: 'item x');
  }

  // Xabarnoma sozlamalari
  static NotificationDetails _getNotificationDetails() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    return const NotificationDetails(android: androidDetails);
  }
}
