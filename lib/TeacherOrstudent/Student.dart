import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kraya/Screens/ChatPageRoute.dart';
import 'package:e_kraya/Screens/HomePage.dart';
import 'package:e_kraya/Screens/todo_screen.dart';
import 'package:e_kraya/TeacherOrstudent/Teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentRoute extends StatefulWidget {
  @override
  _StudentRouteState createState() => _StudentRouteState();
}

class _StudentRouteState extends State<StudentRoute> {
  final _fireStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  void getFiles() async {
    final files = await _fireStore.collection('Fichiers').get();
    for (var file in files.docs) print(file.data());
  }

  final _auth = FirebaseAuth.instance;
  User loggedUser;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser.email);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Scaffold(

        appBar: AppBar(

          backgroundColor: Colors.greenAccent.shade100,
          titleSpacing: 3,
          title: Text("Etudiant"),
        ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Image(
                  fit : BoxFit.fitWidth,
                  image: AssetImage('assets/class.png'),
                ),
                ),

                ListTile(
                  trailing: Icon(Icons.chat_outlined),
                  title: Expanded(
                    child: Text('Forum de discussion'),
                  ),
                   onTap:() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>ChatScreen()));
                   },
                ),
                ListTile(
                  trailing: Icon(Icons.calendar_today_outlined),
                  title: Expanded(child: Text('Emlpoi du temps')),
                  onTap:() {
                    if(TeacherRoute.urlEmploi=='')
                    {
                      Fluttertoast.showToast(
                          msg: "l'emlpoi du temps n'est pas encore pret ",
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
                    else{

                        launch(TeacherRoute.urlEmploi);
                        }

                  },
                ),
                ListTile(
                  trailing: Icon(Icons.check_box_outlined,),

                  title: Expanded(
                    child: Text('Tache à faire'),
                  ),
                  onTap:()async {
                    await _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>ToDoRoute()));
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.logout,color: Colors.white,),
                  tileColor: Colors.redAccent,
                  title: Expanded(
                    child: Text('Déconnexion',style: TextStyle(color: Colors.white),),
                  ),
                  onTap:()async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.remove('tasks');
                    pref.remove('email');
                    await _auth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomePage()));

                  },
                ),


              ],
            ),
          ),
          body: Column(
        children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                  child: Text('\nCours et enregistrement',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 10,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _fireStore.collection('Fichiers').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                    final files = snapshot.data.docs;
                    List<Column> filecards = [];
                    for (var file in files) {
                      final filename = file['nom_pdf'];
                      final fileurl = file['pdf'];
                      final filetime = file['date'];
                      final filecard = Column(children: [
                        Card(
                          elevation: 5,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  filename.toString().endsWith('pdf') ||
                                          filename.toString().endsWith('docx')
                                      ? Icons.picture_as_pdf
                                      : Icons.video_collection_sharp,
                                  color: filename.toString().endsWith('pdf') ||
                                          filename.toString().endsWith('docx')
                                      ? Colors.red.shade400
                                      : Colors.purple.shade200,
                                ),
                              ),
                              SizedBox(
                                  width: 230,
                                  // height:40,
                                  child: Text(
                                    ' $filename ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Text(
                                '\n$filetime',
                                style: TextStyle(fontSize: 10),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: FocusedMenuHolder(


                                      menuItems: [
                                        FocusedMenuItem(
                                            title: Text(
                                              'Télécharger',

                                            ),
                                            onPressed: () async {
                                                  await launch(fileurl);
                                                  },

                                            trailingIcon: Icon(
                                              Icons.download_rounded,
                                              color: Colors.blueGrey,
                                            ),
                                           ),
                                        FocusedMenuItem(
                                          title: Text(
                                            'Partager',

                                          ),
                                          onPressed: () async {
                                            Share.share(fileurl);

                                          },

                                          trailingIcon: Icon(
                                            Icons.share_rounded,
                                            color: Colors.blueGrey,
                                          ),
                                        )
                                      ],
                                      onPressed: (){},
                                      child: Icon(Icons.more_vert_outlined)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]);
                      filecards.add(filecard);
                    }
                    return ListView(
                      children: filecards,
                    );
                  }),
            ),
          ),
        ],
      ));
    });
  }
}
