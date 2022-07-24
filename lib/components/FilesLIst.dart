import 'package:flutter/material.dart';

class ListFile extends StatelessWidget {
  var listFile=[];
  ListFile({this.listFile});
  @override
  Widget build(BuildContext context) {
    final title = "ListView List";


    return MaterialApp(
      title: title,
      home: Scaffold(appBar: AppBar(
        title: Text(title),
      ),
        body: new ListView.builder(
          itemCount: listFile.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: listFile[index],
            );
          }),
      ),

    );

  }
  }

