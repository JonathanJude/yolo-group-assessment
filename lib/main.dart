import 'package:casino_test/src/di/main_di_module.dart';
import 'package:casino_test/src/presentation/ui/character_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  //Moved this piece of code here to fix the error that kept on coming when hot-reloading the app,
  // registering dependencies inside your Widget Tree is bad practice as the widget tree would always be rebuilt, thereby re-registering your dependencies
  MainDIModule().configure(GetIt.I);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test app',
      home: CharactersScreen(),
    );
  }
}
