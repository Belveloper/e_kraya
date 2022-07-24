
import 'dart:io';

import 'package:e_kraya/TeacherOrstudent/Student.dart';
import 'package:e_kraya/TeacherOrstudent/Teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class LoginRoute extends StatefulWidget {
  bool studentSelected;

  LoginRoute({this.studentSelected});

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final _auth=FirebaseAuth.instance;
  String email;
  String password;
  String name;
  bool _obscureText=true;
  var _icon=Icons.visibility;
  // ignore: non_constant_identifier_names
  void _ShowHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
      if(_obscureText)_icon=Icons.visibility;
      else _icon=Icons.visibility_off;
    });
  }
  bool showSpinner=false;
  final _formKey = GlobalKey<FormState>();
  String _error ;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context){
      return Scaffold(
          body:LoadingOverlay(
            isLoading: showSpinner,
            child: SingleChildScrollView(
              child: Form(
                key:  _formKey ,
                child: SafeArea(
                  child: Column(

                    children: [
                      SizedBox(height: 10,),
                      showAlert(),
                      SizedBox(height: 10,),
                      Text('Connexion',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35,fontFamily: 'Righteous'),),
                      /*SizedBox(
                    height: 50,
                  ),*/
                      Image(image: AssetImage('assets/login.png'),),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                          validator: (val) =>
                          val.isEmpty || !val.contains('@')? "entrer un email valide" : null,
                          decoration: new InputDecoration(
                            labelText: "Email",
                            fillColor: Colors.grey,
                            prefixIcon: Icon(Icons.person),

                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(35.0),
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,1),
                        child: TextFormField(

                          obscureText: _obscureText,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          validator: (val) =>
                          val.length<8 ? "entrer un mot de passe (+8 caracteres)" : null,
                          decoration: new InputDecoration(
                            labelText: "mot de passe",
                            fillColor: Colors.grey,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(onPressed: _ShowHidePassword,icon: Icon(_icon),),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(35.0),
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: Text(
                              "mot de passe oubliè?",
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: (){
                              if(email.isNotEmpty) {
                                _auth.sendPasswordResetEmail(email: email);
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "un Email de réinitialisation du mot de passe a été envoyé à $email veuillez suivre le lien pour le réinitialiser"),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "ok",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.cyan),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }

                            }
                            //forgotten password
                            //print("forgotten password text tapped\n");
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),
                      RaisedButton(onPressed: ()async{

                        if(_formKey.currentState.validate()){
                          setState(() {
                            showSpinner=true;
                          });
                        print(widget.studentSelected);
                          try {
                            final result = await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                              print('connected');

                            }
                          } on SocketException catch (_) {
                            print('not connected');
                           setState(() {
                             showSpinner=false;
                           });
                            Fluttertoast.showToast(
                                msg: " Veuillez vérifier votre connexion internet et réesayer !",
                                toastLength:
                                Toast.LENGTH_SHORT,
                                gravity:
                                ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor:
                                Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          try{
                            final user = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
                            if(user != null){
                              SharedPreferences logpref = await SharedPreferences.getInstance();
                              logpref.setString('email', email);
                              SharedPreferences whologged = await SharedPreferences.getInstance();
                              whologged.setString('whologged', widget.studentSelected.toString());
                              if(widget.studentSelected) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StudentRoute()));
                              else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TeacherRoute()));
                            }
                            setState(() {
                              showSpinner=false;
                            });
                          }
                          catch(e){
                            setState(() {
                              _error= e.message;
                              showSpinner=false;
                            });
                            print(e);
                          }
                      }},
                        child: Text('Connexion'),
                        color: Colors.white,
                        focusColor: Colors.greenAccent,

                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      ) ;
    });

  }

  Widget showAlert() {
    if(_error!=null){

        return Container(
          color: Colors.amber.shade600,
          width: double.infinity,
          padding: EdgeInsets.only(right:2.0) ,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right:10.0,left: 10.0),
                child: Icon(Icons.error_outline),
              ),
              Expanded(child: Text(_error,maxLines: 3,),),
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: IconButton(icon: Icon(Icons.close),onPressed: (){setState(() {
                  _error=null;
                });},),
              ),

            ],
          ),

        );

    }
    return SizedBox();
  }
}
