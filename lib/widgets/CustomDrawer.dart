import 'package:flutter/material.dart';
import 'package:lojavirtual/models/UserModel.dart';
import 'package:lojavirtual/screens/LoginScreen.dart';
import 'package:lojavirtual/tiles/DrawerTile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  //adicionando o _controller do Page View para poder fazer as passagens de telas
  //utilizando o customDrawer

  final PageController pageController;

  CustomDrawer(this.pageController);


  @override
  Widget build(BuildContext context) {

    //fazendo degrade
    Widget _buildDrawerBack(){
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 203, 236, 241),
                  Colors.white
                ],
                //começo do gradiente
                begin: Alignment.topCenter,
                //final
                end: Alignment.bottomCenter
            )
        ),
      );
    }


    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32,top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text("Flutter's\nClothing",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) =>
                                            LoginScreen()));
                                  }else{
                                    model.signOut();
                                  }
                                },
                                child: Text(
                                  !model.isLoggedIn() ?
                                  "Entre ou cadastre-se" : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home,"Inicio",pageController,0),
              DrawerTile(Icons.list,"Produtos",pageController,1),
              DrawerTile(Icons.location_on,"Lojas",pageController,2),
              DrawerTile(Icons.playlist_add_check,"Meus Pedidos",pageController,3),
            ],
          )
        ],
      ),
    );
  }
}
