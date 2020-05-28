import 'dart:io';

import 'package:PTasker/models/user.dart';
import 'package:PTasker/services/auth.dart';
import 'package:PTasker/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static final List<String> PUSH_NOTIFICATION_ARRAY = [
    'onCreateProjectNotification',
  ];

  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _fcm.requestNotificationPermissions();
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // TODO optional
        },
        onBackgroundMessage: myBackgroundMessageHandler,
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _fcm.getToken();
      print("FirebaseMessaging token: $token");

      _saveDeviceToken();
      _initNotificationSettings();

      _initialized = true;
    }
  }

  _initNotificationSettings() async {
    PUSH_NOTIFICATION_ARRAY.forEach((value) async {
      bool prefsValue = (await _prefs).getBool(value);
      if (prefsValue == null) {
        (await _prefs).setBool(value, true);
      }
      if ((await _prefs).getBool(value)) {
        _fcm.subscribeToTopic(value);
      } else {
        _fcm.unsubscribeFromTopic(value);
      }
    });
  }

  _saveDeviceToken() async {
    // Get the current user
    User user = await AuthService().getUser;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = DatabaseService()
          .usersCollection
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  Future<void> unsubtopic(String topic) async {
    (await _prefs).setBool(topic, false);
    _fcm.unsubscribeFromTopic(topic);
  }

  Future<void> subtopic(String topic) async {
    (await _prefs).setBool(topic, true);
    _fcm.subscribeToTopic(topic);
  }

  Future<Map<String, bool>> get notificationStatus async {
    var prefs = await _prefs;
    return Map.fromIterable(PushNotificationService.PUSH_NOTIFICATION_ARRAY,
        key: (e) => e,
        value: (e) {
          print(prefs.getBool(e));
          return prefs.getBool(e);
        });
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
    
    print(message);
    // Or do other work.
  }
}
