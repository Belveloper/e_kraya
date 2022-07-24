import 'package:e_kraya/Screens/LoginPage.dart';
import 'package:e_kraya/Screens/RegisterPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool studentSelected;
  Color activeSelectedColor = Colors.indigoAccent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "E-9raya",
              style: TextStyle(fontSize: 40, fontFamily: 'Righteous'),
            ),
            Expanded(
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage('assets/home.png'),
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Text(
              "vous êtes",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      studentSelected = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRoute(
                                  studentSelected: studentSelected,
                                )));
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Image(
                            image: AssetImage('assets/Teacher.png'),
                            height: 150,
                            width: 150),
                        Text(
                          "Enseignant",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    print("clicked");
                    setState(() {
                      studentSelected = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRoute(
                                  studentSelected: studentSelected,
                                )));
                  },
                  child: Card(
                      elevation: 3,
                      child: Column(
                        children: [
                          Image(
                              image: AssetImage('assets/Student.png'),
                              height: 150,
                              width: 150),
                          Text(
                            "Etudiant",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                )
              ],
            ),
            SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () {
                print('clicked');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterRoute()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                ),
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(30),
                child: Expanded(
                  child: Row(
                    children: [
                      Text(
                        " \t Nouveau sur E-9raya ? , ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Righteous'),
                      ),
                      Expanded(
                        child: Text(
                          "inscrivez vous",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
