import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/CartModel.dart';
import 'package:lojavirtual/models/UserModel.dart';
import 'package:lojavirtual/screens/LoginScreen.dart';
import 'package:lojavirtual/screens/OrderScreen.dart';
import 'package:lojavirtual/tiles/CartTile.dart';
import 'package:lojavirtual/widgets/CartPrice.dart';
import 'package:lojavirtual/widgets/DiscountCard.dart';
import 'package:lojavirtual/widgets/ShipCard.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context,child,model){
                int quantityProduct = model.products.length;
                return Text(
                    "${quantityProduct?? 0 } ${quantityProduct==1 ? "ITEM" : "ITENS"}",
                    style: TextStyle(
                      fontSize: 17
                    ),
                  );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (contex,child,model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(child: CircularProgressIndicator(),);
          }else if(!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,size: 80,color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16,),
                  Text("Faça o login para adcionar os produtos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16,),
                  RaisedButton(
                    child: Text("Entrar",style: TextStyle(fontSize: 18),),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>LoginScreen())
                      );
                    },
                  )
                ],
              ),
            );
          }else if(model.products==null || model.products.length==0){
            return Center(
              child: Text(
                  "Nenhum produto no carrinho",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            );
          }else{
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                      (product){
                        return CartTile(product);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(()async{
                 String orderId = await model.finishOrder();
                 if (orderId != null){
                   Navigator.of(context).pushReplacement(
                     MaterialPageRoute(builder: (context)=>OrderScreen(orderId))
                   );
                 }else{

                 }
                })
              ],
            );
          }
        },
      ),
    );
  }
}
