import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kvytok_flutter/trip_list_page.dart';

void main() => runApp(MyApp());

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFFCA5421),
    100: Color(0xFFCA5421),
    200: Color(0xFFCA5421),
    300: Color(0xFFCA5421),
    400: Color(0xFFCA5421),
    500: Color(_blackPrimaryValue),
    600: Color(0xFFCA5421),
    700: Color(0xFFCA5421),
    800: Color(0xFFCA5421),
    900: Color(0xFFCA5421),
  },
);
const int _blackPrimaryValue = 0xFFCA5421;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return MaterialApp(
      title: 'Kvytok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        cardTheme: CardTheme(elevation: 8.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)))),
        primarySwatch: primaryBlack,
        accentColor: Color(0xFFCA5421),
      ),
      home: TripListPage(title: 'Kvytok'),
    );
  }
}
