import 'dart:async';
import 'dart:io';
import 'package:e_kraya/Screens/HomePage.dart';
import 'package:e_kraya/Screens/search_file.dart';
import 'package:e_kraya/custom_apis/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/modals.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherRoute extends StatefulWidget {
  static String urlEmploi;

  @override
  _TeacherRouteState createState() => _TeacherRouteState();
}

class _TeacherRouteState extends State<TeacherRoute> {
  final succesSsnackBar = SnackBar(
    content: Text('Fichier ajouté avex succès '),
    backgroundColor: Colors.green,
  );
  final failureSsnackBar = SnackBar(
    content: Text('Operation annulé '),
    backgroundColor: Colors.red,
  );

  final _fireStore = FirebaseFirestore.instance;

  File file;
  @override
  void initState() {
    super.initState();
  }

  void getFiles() async {
    final files = await _fireStore.collection('Fichiers').get();
    for (var file in files.docs) print(file.data());
  }

  /*Future addFileToDatabase(String FileName , String fileUrl ,DateTime date,) async {
  }*/

  Future uploadFile(File file) async {
    if (file == null)
      print('no file selected');
    else {
      final fileName = basename(file.path);
      var destination = 'fichiers/$fileName';
      if (fileName.endsWith('.mp4'))
        destination = 'fichiers/RECORDS/$fileName';
      else if (fileName.endsWith('.pdf'))
        destination = 'fichiers/PDFs/$fileName';

      FirebaseApi.UploadTask(destination, file);
    }
  }

  Future uploadtoDb(File file) async {
    final fileName = basename(file.path);
    var destination = 'fichiers/$fileName';
    if (fileName.endsWith('.mp4'))
      destination = 'fichiers/RECORDS/$fileName';
    else if (fileName.endsWith('.pdf')) destination = 'fichiers/PDFs/$fileName';
    final ref = FirebaseStorage.instance.ref();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    try {
      _fireStore.collection('Fichiers').add({
        'date': formattedDate,
        'nom_pdf': ref.name,
        'pdf': await ref.getDownloadURL(),
      });
    } on FirebaseException catch (e) {
      print(e);
      print(ref.child(fileName).getDownloadURL());
    }
  }

  TextEditingController controller = TextEditingController();
  var fileIcon;
  setEmploiDuTemps(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text('Entrer le lien vers le sheet de l\'emploi du temps'),
              content: TextFormField(
                controller: controller,
                validator: (val) => val.isEmpty ? "saisir une url" : null,
              ),
              actions: [
                MaterialButton(
                    child: Text(
                      'Valider',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          TeacherRoute.urlEmploi = controller.text;
                          Navigator.of(context).pop();
                        });
                      }
                    })
              ],
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent.shade100,
            titleSpacing: 3,
            title: Text("Enseignant"),
          ),
          drawer: Drawer(
            child: ListView(children: [
              DrawerHeader(
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/tdrawerimage.png'),
                ),
              ),
              ListTile(
                  trailing: Icon(Icons.calendar_today_outlined),
                  title: Text('Emploi du temps'),
                  onLongPress: () {
                    setEmploiDuTemps(context);
                  },
                  onTap: () async {
                    await launch(TeacherRoute.urlEmploi);
                  }),
              ListTile(
                  trailing: Icon(Icons.search),
                  title: Text('Chercher un fichier'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchFileRoute()));
                  }),
              ListTile(
                tileColor: Colors.redAccent,
                title: Align(
                  alignment: Alignment.bottomCenter,
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Déconnexion',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 170,
                        ),
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove('email');
                  await _auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ]),
          ),
          body: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  '\n\t  Uploads ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //Text('Bonjour ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
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
                                              filename
                                                  .toString()
                                                  .endsWith('docx')
                                          ? Icons.picture_as_pdf
                                          : Icons.video_collection_sharp,
                                      color:
                                          filename.toString().endsWith('pdf') ||
                                                  filename
                                                      .toString()
                                                      .endsWith('docx')
                                              ? Colors.red.shade400
                                              : Colors.purple.shade200,
                                    ),
                                  ),
                                  SizedBox(
                                      width: 230,
                                      // height:40,
                                      child: Text(
                                        ' $filename ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Expanded(
                                    child: Text(
                                      '\n$filetime',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: FocusedMenuHolder(
                                          menuItems: [
                                            FocusedMenuItem(
                                                title: Text(
                                                  'Supprimer',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () async {
                                                  await _fireStore.runTransaction(
                                                      (Transaction
                                                          myTransaction) async {
                                                    await myTransaction
                                                        .delete(file.reference);
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: "Fichier supprimé",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 2,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor: Colors.red)
                                          ],
                                          onPressed: null,
                                          child:
                                              Icon(Icons.more_vert_outlined)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]);
                          filecards.add(filecard);
                        }
                        return filecards.isEmpty
                            ? Center(child: Text('aucun fichier'))
                            : ListView(
                                children: filecards,
                              );
                      }),
                ),
              ),
              InkWell(
                onTap: () async {
                  final result =
                      await FilePicker.platform.pickFiles(allowMultiple: true);
                  if (result != null) {
                    final path = result.files.single.path;
                    setState(() async {
                      file = File(path);
                      await uploadFile(file);
                      var timer =
                          Timer.periodic(Duration(seconds: 3), (timer) async {
                        await uploadtoDb(file).whenComplete(() {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(succesSsnackBar);
                          timer.cancel();
                        });
                      });
                      //getFiles();
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(failureSsnackBar);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(25.0),
                  alignment: Alignment.bottomCenter,
                  color: Colors.greenAccent.shade100,
                  child: Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Uploader un fichier\t',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Icon(Icons.upload_file),
                    ],
                  )),
                ),
              ),

              //SizedBox(height: 20,)
            ],
          ),
        ),
      );
    });
  }
}
