import 'package:flash_card/global.dart';
import 'package:flash_card/helper/methods/get_user_preferred_language.dart';
import 'package:flash_card/provider/app_provider.dart';
import 'package:flash_card/provider/theme_provider.dart';
import 'package:flash_card/repo/fetch.dart';
import 'package:flash_card/repo/objectBox/object_box.dart';
import 'package:flash_card/route.dart';
import 'package:flash_card/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Create the ObjectBox
  final objectBox = await ObjectBox.create();

  //getUserPreferredLanguage (in get_user_preferred_language.dart)
  await getUserPreferredLanguage();

  //Get the user preferred language (Execute only once) (in fetch.dart)
  await getUserCountryAndLanguage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider(objectBox)),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //showLanguages(context); //Not working for now
  }

  @override
  Widget build(BuildContext context) {
    //Some settings to the status bar
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: "/home",
      onGenerateRoute: generateRoute,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      //darkTheme: darkMode, //It get the mode from the system
    );
    /* return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: "/home",
      onGenerateRoute: generateRoute,
      theme: Provider.of<ThemeProvider>(context).themeData,
      //darkTheme: darkMode, //It get the mode from the system
    ); */
  }
}
