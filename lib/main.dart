import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/home.dart';
import 'preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await LoginPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdminApp();
    // const AdminTablet();
  }
}

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Work Record App',
        theme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: Colors.orange,
            brightness: Brightness.light),
        darkTheme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: Colors.orange,
            brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: const MobileHome());
  }
}

// class AdminTablet extends StatefulWidget {
//   const AdminTablet({Key? key}) : super(key: key);

//   @override
//   State<AdminTablet> createState() => _AdminTabletState();
// }

// class _AdminTabletState extends State<AdminTablet> {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//     ]);

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Work Record App',
//         theme: ThemeData(
//             fontFamily: 'Inter',
//             primarySwatch: Colors.orange,
//             brightness: Brightness.light),
//         darkTheme: ThemeData(
//             fontFamily: 'Inter',
//             primarySwatch: Colors.orange,
//             brightness: Brightness.dark),
//         themeMode: ThemeMode.system,
//         home: const TabletHome());
//   }
// }

const mainColor = Color(0xffFDBF05);
