import 'package:flutter/material.dart';
import 'package:local/config/router/router.dart';
import 'package:local/config/theme/app_theme.dart';
import 'package:local/helpers/database_helper.dart';
import 'package:local/presentation/gasto/gasto_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme(selectedColor: 1).themeData(),
      routerConfig: appRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
