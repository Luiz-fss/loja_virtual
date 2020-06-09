import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/CartProduct.dart';
import 'package:lojavirtual/datas/ProductData.dart';
import 'package:lojavirtual/models/CartModel.dart';
import 'package:lojavirtual/models/UserModel.dart';
import 'package:lojavirtual/screens/CartScreen.dart';
import 'package:lojavirtual/screens/LoginScreen.dart';

class ProductDetailScreen extends StatefulWidget {

  final ProductData product;
  ProductDetailScreen(this.product);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(product);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  final ProductData product;
  String size;
  _ProductDetailScreenState(this.product);



  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url){
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5
                    ),
                    children: product.sizes.map((sizes){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            size = sizes;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: size == sizes ? primaryColor : Colors.grey,
                              width: 3
                            )
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            sizes
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: size != null ? (){
                      if(UserModel.of(context).isLoggedIn()){
                        //adicionar ao carrinho
                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;
                        cartProduct.category = product.category;
                        cartProduct.productData = product;
                        CartModel.of(context).addCartItem(cartProduct);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>CartScreen())
                        );
                      }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho"
                      : "Entre para comprar",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                ),
                Text(product.description,style: TextStyle(fontSize: 16),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
