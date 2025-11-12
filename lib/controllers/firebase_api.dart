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
*/























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
    if (_isInitialized) {  // GetController tekshiruvini qo'shish mumkin, lekin majburiy emas
      return;
    }
    _isInitialized = true;
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Bu qismni O'CHIRING yoki faqat shartni qoldiring, erase() ni olib tashlang:
      final box = GetStorage();
      if (box.read('fcmToken') == null) {
        debugPrint('FCM token yo\'q – qayta saqlanmoqda');  // Faqat log
        // box.erase();  ← Bu satrni O'CHIRING!
      }

      // FCM token olish va saqlash
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: $fcmToken');
      box.write('fcmToken', fcmToken ?? '');  // To'g'ridan-to'g'ri saqlash

      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      _setupForegroundHandlers();

      await _configureNotificationChannels();
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
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max, priority: Priority.high, showWhen: false);
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

  // Asosiy sozlash funksiyasi (yuklash majburiy qilindi)
  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      final box = GetStorage();
      if (box.read('fcmToken') == null) {
        debugPrint('FCM token yo\'q – qayta saqlanmoqda');
      }

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
      _setupForegroundHandlers();

      await _configureNotificationChannels();
      await subscribeToTopics();

      // ← MUHIM: App ochilganda HAR DOIM yuklash (bosilmasdan ham)
      _loadStoredNotifications();
    } catch (e) {
      debugPrint('Xabarlarni sozlashda xatolik: $e');
    }
  }

  // Foreground handler'larni sozlash (onMessageOpenedApp kuchaytirildi)
  static void _setupForegroundHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground xabarni qayta ishlash: ${message.messageId}');
      _saveNotificationToStorage(message);
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Xabarnoma orqali ochilgan: ${message.messageId}');
      // ← Kuchaytirilgan: Try-catch bilan saqlash (terminated dan ochilganda)
      try {
        _saveNotificationToStorage(message);
        debugPrint('OpenedApp da saqlash muvaffaqiyatli');
      } catch (e) {
        debugPrint('OpenedApp saqlash xatosi: $e – fallback saqlash');
        // Fallback: Agar xato bo'lsa, oddiy saqlash
        _saveSimpleNotification(message);
      }
      _loadStoredNotifications(); // Har doim yuklash
    });
  }

  // Mavzular bo'yicha obuna bo'lish (o'zgarishsiz)
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

  // Mahalliy xabarnomalarni sozlash (o'zgarishsiz)
  static Future<void> _configureNotificationChannels() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Notification'ni GetStorage'ga saqlash (YAXSHILANGAN: Har doim qo'shish + duplicate tozalash)
  static void _saveNotificationToStorage(RemoteMessage message) {
    final box = GetStorage();
    List messages = [];
    String? messagesJson = box.read('notificationMessages');
    if (messagesJson != null && messagesJson.isNotEmpty) {
      try {
        messages = json.decode(messagesJson);
        debugPrint('Eski notificationlar yuklandi: ${messages.length} ta');
      } catch (e) {
        debugPrint('JSON decode xatosi: $e – yangi ro\'yxat yaratilmoqda');
        messages = [];
      }
    }

    // Yangi notification (unique timestamp bilan)
    final now = DateTime.now().toIso8601String();
    final newMsg = {
      "title": message.data['title'] ?? 'Hicom Partner',
      "body": message.notification?.body ?? message.data['body'] ?? '',
      "date": now,
      "data": message.data,
      "messageId": message.messageId ?? 'fallback_${now.hashCode}', // Unique fallback
    };

    // Duplicate tekshirish: Oxirgi 24 soat ichida title+body bo'yicha (yumshatilgan)
    final recentThreshold = DateTime.now().subtract(const Duration(hours: 24));
    messages.removeWhere((msg) { // Eski duplicate'larni tozalash
      final msgDate = DateTime.tryParse(msg['date'] ?? '') ?? DateTime(2000);
      if (msgDate.isBefore(recentThreshold)) return true; // 24 soatdan eskilarini o'chir
      return (msg['title'] == newMsg['title']) && (msg['body'] == newMsg['body']);
    });

    // Har doim qo'shish (kelishi bilan saqlash)
    messages.add(newMsg);
    try {
      box.write('notificationMessages', json.encode(messages));
      debugPrint('Notification KELISHI BILAN SAQLANDI: ${messages.length} ta jami (ID: ${newMsg['messageId']})');
    } catch (e) {
      debugPrint('Saqlash xatosi: $e');
    }
  }

  // Fallback oddiy saqlash (openedApp uchun, agar murakkab bo'lsa)
  static void _saveSimpleNotification(RemoteMessage message) {
    final box = GetStorage();
    List messages = [];
    String? messagesJson = box.read('notificationMessages');
    if (messagesJson != null) {
      messages = json.decode(messagesJson);
    }
    final now = DateTime.now().toIso8601String();
    messages.add({
      "title": message.data['title'] ?? 'Hicom Partner',
      "body": message.notification?.body ?? message.data['body'] ?? '',
      "date": now,
      "data": message.data,
      "messageId": 'simple_${now.hashCode}',
    });
    box.write('notificationMessages', json.encode(messages));
    debugPrint('Simple saqlash muvaffaqiyatli');
  }

  // Saqlangan notification'larni yuklash (GetController ga yuborish uchun)
  static void _loadStoredNotifications() {
    final box = GetStorage();
    String? messagesJson = box.read('notificationMessages');
    if (messagesJson != null && messagesJson.isNotEmpty) {
      try {
        List loaded = json.decode(messagesJson);
        // ← Bu yerda GetController ga yuborish: Masalan, notification sahifasida ishlatish uchun
        // Get.find<GetController>().loadNotificationMessagesFromJson(loaded); // Sizning metod
        debugPrint('Saqlangan notification\'lar YUKLANDI: ${loaded.length} ta');
      } catch (e) {
        debugPrint('Yuklash xatosi: $e');
      }
    } else {
      debugPrint('Saqlangan notification yo\'q');
    }
  }

  // Fondagi xabarlarni qayta ishlash (kelishi bilan saqlash ta'minlandi)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    try {
      debugPrint('BACKGROUND HANDLER: ${message.messageId} | Kelgan notification saqlanmoqda');
      _saveNotificationToStorage(message); // ← Kelishi bilan saqlash
      await _showNotification(message);
      debugPrint('Background da saqlash va ko\'rsatish muvaffaqiyatli');
    } catch (e) {
      debugPrint('Background handler xatosi: $e');
    }
  }

  // Xabarlarni ko'rsatish (o'zgarishsiz)
  static Future<void> _showNotification(RemoteMessage message) async {
    final notificationDetails = _getNotificationDetails();
    final title = message.data['title'] ?? 'Hicom Partner';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: 'item x');
  }

  // Xabarnoma sozlamalari (o'zgarishsiz)
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
*/

