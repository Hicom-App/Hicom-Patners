import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hicom_patners/controllers/get_controller.dart';
import '../firebase_options.dart';

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
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
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









/*


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import '../firebase_options.dart';
import 'dart:convert';

class InitNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final List<String> _topics = ['HicomPartner_C1', 'HicomPartner_R12', 'HicomPartner_D3', 'HicomPartner_U2', 'HicomPartner'];
  static bool _isInitialized = false;

  // Asosiy sozlash funksiyasi
  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Kesh tozalanganligini tekshirish va toza boshlash
      final box = GetStorage();
      if (box.read('fcmToken') == null) {
        debugPrint('Kesh tozalangan – toza boshlanmoqda');
        box.erase(); // Eski qoldiqlarni tozalash
      }

      // FCM token olish va saqlash
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: $fcmToken');
      box.write('fcmToken', fcmToken ?? '');

      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      _setupForegroundHandlers(); // Foreground handler'larni sozlash

      await _configureNotificationChannels();

      // Mavzular bo'yicha obuna bo'lish (har safar)
      await subscribeToTopics();
    } catch (e) {
      debugPrint('Xabarlarni sozlashda xatolik: $e');
    }
  }

  // Foreground handler'larni sozlash
  static void _setupForegroundHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground xabarni qayta ishlash: ${message.messageId}');
      _saveNotificationToStorage(message); // To'g'ridan-to'g'ri saqlash
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Xabarnoma orqali ochilgan: ${message.messageId}');
      _saveNotificationToStorage(message); // Saqlash
      // Kesh tozalangan bo'lsa ham yuklash (bo'sh bo'lsa, yangi boshlanadi)
      _loadStoredNotifications();
    });
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

  // Notification'ni GetStorage'ga saqlash (umumiy metod, background/foreground uchun)
  static void _saveNotificationToStorage(RemoteMessage message) {
    final box = GetStorage();
    List messages = [];
    String? messagesJson = box.read('notificationMessages');
    if (messagesJson != null) {
      messages = json.decode(messagesJson);
    }

    // Yangi notification'ni qo'shing (agar allaqachon bor bo'lmasa)
    final newMsg = {
      "title": message.data['title'] ?? 'Hicom Partner',
      "body": message.notification?.body ?? message.data['body'] ?? '',
      "date": DateTime.now().toString(),
      "data": message.data,
    };

    // Takrorlanmaslik uchun tekshirish (null xavfsiz)
    if (!messages.any((msg) {
      final msgData = msg['data'] as Map<String, dynamic>?; // Null tekshiruvi
      return msgData != null && msgData['messageId'] == message.messageId;
    })) {
      messages.add(newMsg);
      box.write('notificationMessages', json.encode(messages));
      debugPrint('Yangi notification saqlandi: ${messages.length} ta jami');
    }
  }

  // Saqlangan notification'larni yuklash (ilova ochilganda)
  static void _loadStoredNotifications() {
    final box = GetStorage();
    String? messagesJson = box.read('notificationMessages');
    if (messagesJson != null && messagesJson.isNotEmpty) {
      List loaded = json.decode(messagesJson);
      debugPrint('Saqlangan notification\'lar yuklandi: ${loaded.length} ta');
      // Bu yerda UI'ga yuborish mumkin (masalan, Getx event orqali, lekin hozircha debug)
    } else {
      debugPrint('Saqlangan notification yo\'q – kesh tozalangan');
    }
  }

  // Fondagi xabarlarni qayta ishlash (background handler)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('Fondagi xabarni qayta ishlash: ${message.messageId}');

    // Background'da to'g'ridan-to'g'ri saqlash
    _saveNotificationToStorage(message);

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
}*/
