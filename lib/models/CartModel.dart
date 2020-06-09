import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/CartProduct.dart';
import 'package:lojavirtual/models/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{


  String couponCode;
  int discountPercentage = 0;
  UserModel user;
  List<CartProduct> products =[];
  CartModel(this.user){
   if(user.isLoggedIn()){
     _loadCartItems();
   }
  }

  bool isLoading =  false;

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getShipPrice(){
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }

  Future<String> finishOrder()async{
    if(products.length==0){
      return null;
    }
    isLoading = true;
    notifyListeners();
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //criando as referencias do pedido no firebase de acordo com o usuario
    DocumentReference reference = await Firestore.instance.collection("orders").add({
      "clientId" : user.firebaseUser.uid,
      "products" : products.map((cartProduct)=>cartProduct.toMap()).toList(),
      "shipPrice" : shipPrice,
      "productPrice" : productsPrice,
      "discount": discount,
      "total" : productsPrice + shipPrice - discount,
      "status" : 1
    });

    //salvando o id de referencia numa collection dentro do usuario
     await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("orders").document(reference.documentID)
    .setData({
      "orderId" : reference.documentID
    });

     //deletando os itens do carrinho no firebase
    //acessando os produtos do carrinho do usuario
    QuerySnapshot querySnapshot = await Firestore.instance.collection("users")
    .document(user.firebaseUser.uid).collection("cart").getDocuments();

    //pegando cada um dos documentos da lista do carrinho
    for(DocumentSnapshot doc in querySnapshot.documents){
      doc.reference.delete();
    }

    //limpando lista local de produtos
    products.clear();
    discount = 0;
    couponCode = null;

    isLoading = false;
    notifyListeners();

    return reference.documentID;

  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  void _loadCartItems() async {

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity --;
    //atualizando a nova quantidade no firebase
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity ++;
    //atualizando a nova quantidade no firebase
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }
  void removedCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();
    products.remove(cartProduct);
    notifyListeners();
  }
}