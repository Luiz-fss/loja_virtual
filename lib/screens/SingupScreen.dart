import 'package:flutter/material.dart';
import 'package:lojavirtual/models/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';


class SingupScreen extends StatefulWidget {
  @override
  _SingupScreenState createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao criar usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }


/*
  _onFail(){
    final snackbar = SnackBar(
      content: Text("Falha ao criar usuário"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

 */
  /*
  _onSucess(){
    final snackbar = SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
    Scaffold.of(context).showSnackBar(snackbar);
  }

   */


  _onSucess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context,child, model){
            if(model.isLoading){
              return Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    validator: (texto){
                      if(texto.isEmpty){
                        return "Nome inválido";
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Nome Completo"
                    ),
                  ),

                  SizedBox(height: 16,),

                  TextFormField(
                    controller: _emailController,
                    validator: (texto){
                      if(texto.isEmpty || !texto.contains("@")){
                        return "E-mail inválido";
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "E-mail"
                    ),
                  ),
                  SizedBox(height: 16,),

                  TextFormField(
                    controller: _addressController,
                    validator: (texto){
                      if(texto.isEmpty){
                        return "Endereço inválida";
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Endereço"
                    ),
                  ),
                  SizedBox(height: 16,),

                  TextFormField(
                    controller: _passController,
                    validator: (texto){
                      if(texto.isEmpty || texto.length < 6){
                        return "Senha inválida";
                      }
                    },
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                  ),

                  SizedBox(height: 16,),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          Map<String,dynamic>userData = {
                            "name":_nameController.text,
                            "email":_emailController.text,
                            "address":_addressController.text
                          };

                          model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSucess,
                              onFail: _onFail
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }
}



