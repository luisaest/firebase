import 'package:firebase/screens/products_screen.dart';
import 'package:flutter/material.dart';

class ListarProducto extends StatefulWidget {
  const ListarProducto({Key? key}) : super(key: key);

  @override
  _ListarProductoState createState() => _ListarProductoState();
}

class _ListarProductoState extends State<ListarProducto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase'),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/agregar').whenComplete((){ //refresh automatica
                setState(() {});
              });
              }, 
              icon: Icon(Icons.add)
            )
          ],
        ),
        body: ListProducts(),
      );
  }
}