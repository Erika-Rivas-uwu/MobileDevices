import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:persistance1/screens/home_screen.dart';
import 'package:persistance1/screens/taken_picture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(SqliteApp(
    firstCamera: firstCamera,
  ));
}

class SqliteApp extends StatelessWidget {
  final CameraDescription firstCamera;
  const SqliteApp({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Example',
      initialRoute: 'home',
      routes: {
        'home': (context) => TakenPictureScreen(
              camera: firstCamera,
            )
      },
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: Color(0xFFFBE5A3))),
    );
  }
}
