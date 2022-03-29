import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final String image;

  Product(
      {required this.name,
      required this.description,
      required this.price,
      required this.image});

  factory Product.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map;
    return Product(
        image: data['image'],
        name: data['name'],
        description: data['description'],
        price: data['price']);
  }
}

class ProductListProvider with ChangeNotifier,DiagnosticableTreeMixin{

  List<Product> productList=[];
  late DocumentSnapshot documentSnapshot;
  updateDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.documentSnapshot=documentSnapshot;
    notifyListeners();
  }
  addInProducts(List<Product> list){
   productList=list;
   notifyListeners();
  } 
  updateInProducts(List<Product> list){
   productList.addAll(list);
   notifyListeners();
  }

}
