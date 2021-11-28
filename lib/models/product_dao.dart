class ProductDao {
  String? cveprod;
  String? descprod;
  String? imgprod;

  ProductDao({this.cveprod, this.descprod, this.imgprod});

  //Mapear los datos
  Map<String, dynamic> toMap(){
    return {
      'cveprod' : cveprod,
      'descprod': descprod,
      'imgprod' : imgprod
    };
  }

}