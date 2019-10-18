import 'package:flutter/material.dart';
import 'package:play_fm/utils/ThemeNotifier.dart';
import 'package:play_fm/utils/constants.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(ChangeNotifierProvider<ThemeNotifier>(
      builder: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Play FM',
      theme: themeNotifier.getTheme(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
