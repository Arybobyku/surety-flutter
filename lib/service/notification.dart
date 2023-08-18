// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();
//
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//   Future<void> init() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//             macOS: null);
//
//     tz.initializeTimeZones();
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }
//
//   Future selectNotification(String? payload) async {
//     //Handle notification tapped logic here
//   }
//
//   Future zonedSchedule(int id, String? title, String? body,
//       tz.TZDateTime scheduledDate, NotificationDetails notificationDetails,
//       {required UILocalNotificationDateInterpretation
//           uiLocalNotificationDateInterpretation,
//       required bool androidAllowWhileIdle,
//       String? payload,
//       DateTimeComponents? matchDateTimeComponents}) async {}
// }
