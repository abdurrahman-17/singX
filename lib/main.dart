import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:singx/screens/login/login.dart';
import 'package:singx/screens/splash/splash_screen.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/notifier/common_notifier.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  usePathUrlStrategy();
  refreshToken();
  permissionHandler();
  magnifierHandler();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ThemeData themeData = ThemeData(
    fontFamily: 'Manrope',
    errorColor: Color(0xffFD1413),
    scrollbarTheme: ScrollbarThemeData().copyWith(
      trackVisibility: MaterialStateProperty.all(kIsWeb ? true : false),
      thumbVisibility: MaterialStateProperty.all(kIsWeb ? true : false),
      thumbColor: MaterialStateProperty.all(
        Colors.grey.withOpacity(0.40),
      ),
      thickness: MaterialStatePropertyAll(8),
    ),
  );

  Iterable<LocalizationsDelegate<dynamic>> localDelegates = [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommonNotifier>(
          create: (_) => CommonNotifier(),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          navigatorKey: navigatorKey,
          scrollBehavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
          locale:
              Provider.of<CommonNotifier>(context, listen: true).currentLocale,
          localizationsDelegates: localDelegates,
          supportedLocales: S.delegate.supportedLocales,
          title: 'SingX',
          onGenerateRoute: MyRouter.onGenerateRoute,
          initialRoute: kIsWeb ? loginRoute : splashRoute,
          theme: themeData,
          debugShowCheckedModeBanner: false,
          home: kIsWeb
              ? Login(
                  isUserLogin: false,
                )
              : SplashScreen(),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void magnifierHandler() {
  TextMagnifier.adaptiveMagnifierConfiguration = TextMagnifierConfiguration(
      shouldDisplayHandlesInMagnifier: true,
      magnifierBuilder: (
          BuildContext context,
          MagnifierController controller,
          ValueNotifier<MagnifierInfo> magnifierInfo,
          ) {
        switch (defaultTargetPlatform) {
          case TargetPlatform.iOS:
            return null;
          case TargetPlatform.android:
            return TextMagnifier(
              magnifierInfo: magnifierInfo,
            );
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            return null;
        }
      }
  );
}

permissionHandler()async{
  if(!kIsWeb) {
    if (await Permission.accessMediaLocation.isDenied) {
      await Permission.accessMediaLocation.request();
    }
    if (await Permission.accessNotificationPolicy.isDenied) {
      await Permission.accessNotificationPolicy.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    } if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }if (await Permission.videos.isDenied) {
      await Permission.videos.request();
    }
  }
}
