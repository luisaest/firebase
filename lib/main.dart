import 'package:firebase/screens/agregar_screen.dart';
import 'package:firebase/screens/list_screen.dart';
import 'package:firebase/screens/products_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/agregar' : (BuildContext context) => AgregarProducto(),
      },
      home: ListarProducto()
    );
  }
}