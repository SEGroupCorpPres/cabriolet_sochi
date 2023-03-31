import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class OrderNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> init({bool initScheduled = false}) async {
    timezone.initializeTimeZones();
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinInitializationSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: darwinInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required String userImgUrl,
    required String carImgUrl,
  }) async {
    final largeIconPath = await _downloadAndSaveFile(userImgUrl, 'largeIcon');
    final bigPicturePath = await _downloadAndSaveFile(carImgUrl, 'bigPicture');
    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        styleInformation: styleInformation,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Simple Notification',
      'New user Send Message',
      notificationDetails,
    );
  }

  Future<void> showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required String userImgUrl,
    required String carImgUrl,
    required DateTime dateTime,
    required int seconds,
  }) async {
    final largeIconPath = await _downloadAndSaveFile(userImgUrl, 'largeIcon');
    final bigPicturePath = await _downloadAndSaveFile(carImgUrl, 'bigPicture');
    final styleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath), largeIcon: FilePathAndroidBitmap(largeIconPath));
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        styleInformation: styleInformation,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      timezone.TZDateTime.from(dateTime.add(Duration(seconds: seconds)), timezone.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
