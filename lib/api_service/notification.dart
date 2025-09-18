import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static Future<void> initialize(String userToken) async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      print("📲 FCM Token: $token");

      if (token != null) {
        await sendTokenToBackend(token, userToken);
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 إشعار مباشر: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 فتح من إشعار: ${message.notification?.title}");
    });
  }

  static Future<void> sendTokenToBackend(String fcmToken, String userToken) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.103:8000/api/UNReadd'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: '{"token": "$fcmToken"}',
    );

    print('📡 إرسال التوكن إلى الباكند: ${response.statusCode}');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("🔕 إشعار في الخلفية: ${message.notification?.title}");
  }
}
