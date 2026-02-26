
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_zen/Pages/Intro_page.dart';
import 'package:manga_zen/Pages/home_page.dart';

void main() async {


 await Hive.initFlutter();

  await Hive.openBox('favorites');
  await Hive.openBox('readChapters');
  await Hive.openBox('app');
  await Hive.openBox('history'); 
  await Hive.openBox('Profile');
  await Hive.openBox('readingProgress');

  runApp(
    const MyApp()
);
   

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final box = Hive.box('app');

    final bool onboardingdone =
    box.get('onboardingdone',defaultValue: false);

    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: 
      const TextSelectionThemeData(
        selectionHandleColor: Colors.white,
        
      )
      ),
      debugShowCheckedModeBanner: false,
      home: onboardingdone
      ? HomePage()
      :IntroPage(),
    
    );
  }
}

