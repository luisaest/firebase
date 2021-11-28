import 'dart:io';
import 'package:firebase/utils/utility.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase/utils/color_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class AgregarProducto extends StatefulWidget {
  AgregarProducto({Key? key}) : super(key: key);

  @override
  _AgregarProductoState createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerDescripcion = TextEditingController();
  
  late FirebaseProvider _firebaseProvider;

  bool _validateNombre = false;
  bool _validateDescripcion = false;
  String? _imgn=null;
  String? filePath;

  Future<String> uploadFile(String filePath) async {
    var filename = Uuid().v1();
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('imagenes/$filename.jpg')
          .putFile(file);
      return downloadURL(filename);
    } on firebase_core.FirebaseException catch (e) {
      return e.code;
    }
  }

  Future<String> downloadURL(String filename) async {
  return await firebase_storage.FirebaseStorage.instance
      .ref('imagenes/$filename.jpg')
      .getDownloadURL();
  }

  @override
  void initState(){
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSettings.colorPrimary,
        title: Text('Agregar producto'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Container(
                      child: filePath == null ? Text('Aún no ha cargado imagen') : Image.file(File(filePath!), fit: BoxFit.fill,)
                    ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder()
                    ),
                    onPressed: () async{
                      final img = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 800,
                        maxWidth: 800,
                      );
                      setState(() {
                        filePath =  img!.path;
                      });
                    },
                    child: Icon(Icons.image_outlined)
                  )
                ],
              ),            
              SizedBox(height: 10,),
              _crearTextFieldNombre(),
              SizedBox(height: 10,),  //tener espaciado entre widgets
              _crearTextFieldDescripcion(),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    _controllerNombre.text.isEmpty ? _validateNombre = true : _validateNombre = false;
                    _controllerDescripcion.text.isEmpty ? _validateDescripcion = true : _validateDescripcion = false;                      
                    if(_validateNombre == false && _validateDescripcion == false &&  _controllerNombre.text.length<=48 && _controllerDescripcion.text.length<=98)
                    {
                      uploadFile(filePath!).then((value){
                        ProductDao pro = ProductDao(
                          cveprod: _controllerNombre.text,
                          descprod: _controllerDescripcion.text,
                          imgprod: value
                        );
                        _firebaseProvider.saveProduct(pro).then(
                          (value){
                            Navigator.pop(context);
                          }
                        );
                      });
                      
                    }
                  
                  });
                }, 
                child: Text('Guardar')
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearTextFieldNombre(){
    return TextField(
      controller:  _controllerNombre,
      keyboardType: TextInputType.text,
      maxLength: 48,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Nombre del producto",
        errorText: _validateNombre ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){

      },
    );
  }
  Widget _crearTextFieldDescripcion(){
    return TextField(
      controller: _controllerDescripcion,
      keyboardType: TextInputType.text,
      maxLines: 8,
      maxLength: 98,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Descripcion del producto",
        errorText: _validateDescripcion ? 'Este campo es obligatorio' : null,
      ),
      onChanged: (value){

      },
    );
  }
}