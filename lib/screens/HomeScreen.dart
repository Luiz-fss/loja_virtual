import 'package:flutter/material.dart';
import 'package:lojavirtual/tabs/HomeTab.dart';
import 'package:lojavirtual/tabs/OrderTab.dart';
import 'package:lojavirtual/tabs/PlacesTab.dart';
import 'package:lojavirtual/tabs/ProductsTab.dart';
import 'package:lojavirtual/widgets/CartButton.dart';
import 'package:lojavirtual/widgets/CustomDrawer.dart';

class HomeScreen extends StatelessWidget {

  //controlador da PageView
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Categorias"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
