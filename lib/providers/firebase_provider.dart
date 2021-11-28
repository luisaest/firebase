//clase a utilizarse para realizar las peticiones, medio de comunicacion con el servicio
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/product_dao.dart';

class FirebaseProvider {

  late FirebaseFirestore _firestore;
  late CollectionReference _productsCollection;

  FirebaseProvider(){
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection('products');

  }

  Future<void> saveProduct(ProductDao objPDAO) =>  _productsCollection.add(objPDAO.toMap());
  
  Future<void> updateProduct(ProductDao objPDAO, String DocumentID){
    //DocumentID es la llave primaria que firebase asigna 
    return _productsCollection.doc(DocumentID).update(objPDAO.toMap());
  }

  Future<void> deleteProduct(String DocumentID){
    return _productsCollection.doc(DocumentID).delete();
  }

  Stream<QuerySnapshot> getAllProducts(){
    return _productsCollection.snapshots();
  }

}