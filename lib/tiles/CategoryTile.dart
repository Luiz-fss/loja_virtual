import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/ProductScreen.dart';

class CategoryTile extends StatelessWidget {

   final DocumentSnapshot snapshot;
   CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //ícone a esqueda = leading
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      //seta na direita = traling
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(snapshot)));
      },
    );
  }
}
