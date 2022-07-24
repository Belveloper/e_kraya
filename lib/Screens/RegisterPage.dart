import 'dart:async';
import 'dart:io';

import 'package:e_kraya/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class RegisterRoute extends StatefulWidget {
  bool studentSelected;
  RegisterRoute({this.studentSelected});
  @override
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  var _icon = Icons.visibility;
  bool _obscureText = true;
  String _error;
  // ignore: non_constant_identifier_names
  void _ShowHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText)
        _icon = Icons.visibility;
      else
        _icon = Icons.visibility_off;
    });
  }

  User _user;
  Timer timer;
  @override
  void initState() {
    _user = _auth.currentUser;
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              showAlert(),
              SizedBox(
                height: 10,
              ),
              Text(
                '\nInscription',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35,fontFamily: 'Righteous'),
              ),
              /*SizedBox(
                  height: 50,
                ),*/
              Image(
                image: AssetImage('assets/register.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  validator: (val) => val.isEmpty ? "entrer un email" : null,
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
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: TextFormField(
                  obscureText: _obscureText,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  validator: (val) => val.length < 8
                      ? "entrer un mot de passe (+8 caracteres)"
                      : null,
                  decoration: new InputDecoration(
                    labelText: "mot de passe",
                    fillColor: Colors.grey,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: _ShowHidePassword,
                      icon: Icon(_icon),
                    ),
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
              RaisedButton(
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      print('connected');
                      if (_formKey.currentState.validate()) {
                        print('$email\n$password');
                        try {
                          final user =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email.trim(),
                                  password: password.trim());
                          if (user != null) {
                            _user.sendEmailVerification();

                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "un Email de verificiation a été envoyé à $email veuillez le vérifier et attendre un instant pour vous redirigez vers l'acceuil"),
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
                        } catch (e) {
                          setState(() {
                            _error = e.message;
                          });
                          print(e);
                        }
                      }
                    }
                  } on SocketException catch (_) {
                    print('not connected');
                    Fluttertoast.showToast(
                        msg:
                            " Veuillez vérifier votre connexion internet et réesayer !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Text('S\'inscrire'),
                color: Colors.white,
                focusColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> checkEmailVerified() async {
    _user = _auth.currentUser;
   try{ await _user.reload();
    if (_user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }}catch(e){

   }
  }

  showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amber.shade600,
        width: double.infinity,
        padding: EdgeInsets.only(right: 2.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0,left: 10.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }
}
