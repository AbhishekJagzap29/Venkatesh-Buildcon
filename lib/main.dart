import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Screen/MaterialInspectionScreen/material_inspection_screen_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
 OneSignal.initialize("372b0e53-5037-4ca5-a4bd-8ecb65c2aa78");
 // OneSignal.initialize("3dbd7654-0443-42a0-b8f1-10f0b4770d8d");

  await OneSignal.Notifications.requestPermission(true);

  OneSignal.Notifications.addClickListener((event) {
    print('event----------- ${event}');

    debugPrint("NOTIFICATION :::::::::: ${event.notification.notificationId}");
    debugPrint("TITLE :::::::::: ${event.notification.title}");
    debugPrint("BODY :::::::::: ${event.notification.body}");
  });

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print(
        'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
  });

  OneSignal.InAppMessages.addClickListener((event) {
    print("IN APP MESSAGES :::: ${event}");
    print("IN APP MESSAGES :::: ${event.message}");
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(Responsive.isDesktop(context)
              ? 1.6
              : Responsive.isTablet(context)
                  ? 1.7
                  : 1.1)),
      child: GetMaterialApp(
        title: 'Venkatesh Buildcon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(seedColor: appColor),
        ),
        initialBinding: BaseBinding(),
        initialRoute: Routes.splashScreen,
        getPages: Routes.routes,
      ),
    );
  }
}

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaterialInspectionScreenController(), fenix: true);
  }
}
