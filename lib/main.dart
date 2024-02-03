import 'package:ask_geoffrey/purchase_api.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/views/authentication/auth_view_model.dart';
import 'package:ask_geoffrey/views/camera_screen.dart';
import 'package:ask_geoffrey/views/splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await PurchaseApi.init();
  // camera = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        //minTextAdapt: true,
        //splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              primarySwatch: AppColors.primaryColor,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
