import 'package:surety/helper/color_palette.dart';
import 'package:surety/injection.dart';
import 'package:surety/provider/admin.dart';
import 'package:surety/provider/article_provider.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/banner_provider.dart';
import 'package:surety/provider/form_provider.dart';
import 'package:surety/provider/friends_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/setup_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  configureInjection();
  // await NotificationService().init();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  setupLocator().then((value) {
    // Workmanager().initialize(
    //     callbackDispatcher, // The top level function, aka callbackDispatcher
    //     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    // );
    // Workmanager().registerPeriodicTask("peminjaman", "peminjaman",frequency: Duration(minutes: 1));
    runApp(MyApp());
    runApp(const MyApp());
  });
}

setUpNotification() async {
  // final AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('app_icon');
  //
  // final IOSInitializationSettings initializationSettingsIOS =
  // IOSInitializationSettings(
  //   requestSoundPermission: false,
  //   requestBadgePermission: false,
  //   requestAlertPermission: false,
  // );
  //
  // final InitializationSettings initializationSettings =
  // InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //     macOS: null);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        ChangeNotifierProvider(create: (context) => FormProvider()),
        ChangeNotifierProvider(create: (context) => FriendsProvider()),
        ChangeNotifierProvider(create: (context) => BannerProvider()..getBanner()),
      ],
      child: GetMaterialApp(
        builder: EasyLoading.init(),
        navigatorKey: Get.key,
        debugShowCheckedModeBanner: false,
        color: ColorPalette.generalBackgroundColor,
        title: 'MyPerpus',
        initialRoute: Routes.navigator,
        getPages: Routes.newRoutes,
        theme: ThemeData(
          primaryColor: ColorPalette.generalPrimaryColor,
          backgroundColor: ColorPalette.generalBackgroundColor,
          appBarTheme: AppBarTheme(
              color: ColorPalette.generalPrimaryColor,
              iconTheme:
                  IconThemeData(color: ColorPalette.generalPrimaryColor)),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

void callbackDispatcher() {
  // var storageService = locator<LocalStorageService>();
  // var bookName =storageService.getStringFromPref(Constants.notifikasiPengembalian);
  // if(bookName!=null){
  //   Workmanager().executeTask((task, inputData) async{
  //     await NotificationService.flutterLocalNotificationsPlugin.show(
  //         12345,
  //         "Pengembalian Buku",
  //         "Harap mengembalikan buku $bookName",
  //         platformChannelSpecifics,);
  //     return Future.value(true);
  //   });
  // }

  // Workmanager().executeTask((task, inputData) async{
  //   await NotificationService.flutterLocalNotificationsPlugin.show(
  //     12345,
  //     "Pengembalian Buku",
  //     "Harap mengembalikan buku",
  //     platformChannelSpecifics,);
  //   return Future.value(true);
  // });
}
