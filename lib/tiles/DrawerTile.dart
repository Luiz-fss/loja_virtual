import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController pageController;
  //variavel para saber qual pagina o controlador tem que enviar o usuario
  final int page;

  DrawerTile(this.icon,this.text,this.pageController,this.page);

  @override
  Widget build(BuildContext context) {
    //retornando o Material para dar efeito visual
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: pageController.page.round() == page ? Theme.of(context).primaryColor
                : Colors.grey[700],
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
