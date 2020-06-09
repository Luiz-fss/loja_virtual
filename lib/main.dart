import 'package:flutter/material.dart';
import 'package:lojavirtual/models/CartModel.dart';
import 'package:lojavirtual/models/UserModel.dart';
import 'package:lojavirtual/screens/HomeScreen.dart';
import 'package:scoped_model/scoped_model.dart';

void main () {

  runApp(ScopedModel<UserModel>(
    /*Tudo que estiver abaixo do ScopedModel vai ter acesso
    * ao UserModel e vai ser modificado caso algo aconteça*/
    model: UserModel(),
    child: ScopedModelDescendant<UserModel>(
      builder: (context,child,model){
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: MaterialApp(
            title: "Flutter's Cloathing",
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color.fromARGB(255, 4, 125, 141),
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
        );
      },
    )
  ));
}

