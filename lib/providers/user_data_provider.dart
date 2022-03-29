import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../config/paths.dart';
import '../models/product.dart';

class UserDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth mAuth = FirebaseAuth.instance;
  late DocumentSnapshot lastDocumentSnapshot;

  Future<List<Product>> getInitialProducts() async {
    List<Product> products = [];
    QuerySnapshot snapshot =
        await db.collection(Paths.productsPath).orderBy('name').limit(10).get();
    lastDocumentSnapshot = snapshot.docs[snapshot.docs.length - 1];
    products = List<Product>.from(
      (snapshot.docs).map(
        (e) => Product.fromFirestore(e),
      ),
    );

    return products;
  }

  Future<List<Product>> getMoreProducts(Product last) async {
    List<Product> products = [];
    QuerySnapshot snapshot = await db
        .collection(Paths.productsPath)
        .orderBy('name')
        .startAfter([last.name])
        .limit(10)
        .get();
    products = List<Product>.from(
      (snapshot.docs).map(
        (e) => Product.fromFirestore(e),
      ),
    );
    return products;
  }

  Stream<List<Product>>? getProducts() {
    List<Product> products = List.empty(growable: true);

    try {
      CollectionReference collectionReference =
          db.collection(Paths.productsPath);

      return collectionReference.snapshots().transform(StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>, List<Product>>.fromHandlers(
            handleData: (QuerySnapshot snap, EventSink<List<Product>> sink) {
              products = List<Product>.from(
                snap.docs.map(
                  (e) => Product.fromFirestore(e),
                ),
              );
              sink.add(products);
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> addNewProduct(Map product) async {
    String productId;
    try {
      productId = const Uuid().v1();

      //upload images first
      var uuid = const Uuid().v4();
      Reference storageReference =
          firebaseStorage.ref().child('productImages/$uuid');
      UploadTask storageUploadTask = storageReference.putFile(product['Image']);
      TaskSnapshot storageTaskSnapshot = await storageUploadTask;
      var url = await storageTaskSnapshot.ref.getDownloadURL();

      //upload product to db
      await db.collection(Paths.productsPath).doc(productId).set({
        "id": productId,
        "image": url,
        "name": product['name'],
        "description": product['description'],
        "price": product['price']
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
