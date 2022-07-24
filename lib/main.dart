import 'package:flutter_onboarding_screen/flutteronboardingscreens.dart';
import 'package:flutter_onboarding_screen/OnbordingData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences logpref = await SharedPreferences.getInstance();
  //var email = logpref.getString('email');
  //var whologged = logpref.getString('whologged');
  await Firebase.initializeApp();
  runApp(
    //email == null?
    E_kRaya(),
  );
  /* : whologged == 'true' ?
          MaterialApp(
              debugShowCheckedModeBanner: false,
              home: StudentRoute(),
            )
          : MaterialApp(
              debugShowCheckedModeBanner: false, home: TeacherRoute()));*/
}

class E_kRaya extends StatelessWidget {
  final List<OnbordingData> list = [
    OnbordingData(
      imagePath: "assets/shareboard.png",
      title: "Partager",
      desc:
          "Partager vos supports entre vos camarades de section ou via n'importe quel réseau social ",
    ),
    OnbordingData(
      imagePath: "assets/uploadBoard.png",
      title: "Télécharger",
      desc:
          "Télécharger vos supports éléctroniques et consulter les à tout moments et en hors ligne",
    ),
    OnbordingData(
      imagePath: "assets/chatBoard.png",
      title: "Discuter",
      desc:
          "Aborder des discussions entre les membres de votre section,posez toutes vos questions et explorer le travail partagé grace aux forum de E-9raya",
    ),
    OnbordingData(
      imagePath: "assets/downBoard.png",
      title: "Uploder",
      desc:
          "Pour les enseignants,uploader vos supports de cours,vos capsules vidéos  à vos étudiants pour qu'il puissent les consulter et leur faciliter l'apprentissage",
    ),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: IntroScreen(
              list, MaterialPageRoute(builder: (context) => HomePage())),
        ));
  }
}
