import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imageLink;
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[

              SizedBox(height: 64,), //just for spacing

              imageLink != null ?
              CircleAvatar(
                child: ClipOval(
                  child: Image.network(imageLink),
                ),
                radius: 100,
              ):

              CircleAvatar(
                child: ClipOval(
                  child: Icon(Icons.person, size: 100,),
                ),
                radius: 100,
              ),

              SizedBox(height: 16,),//just for spacing

              FlatButton(
                child: Text("Change Image"),
                onPressed: ()async{
                  _image = await ImagePicker.pickImage(source: ImageSource.gallery);

                  FirebaseStorage fs = FirebaseStorage.instance;

                  StorageReference rootReference = fs.ref();

                  StorageReference pictureFolderRef = rootReference.child("pictures").child("image");

                  pictureFolderRef.putFile(_image).onComplete.then((storageTask)async{
                    String link = await storageTask.ref.getDownloadURL();
                    print("uploaded");
                    setState(() {
                      imageLink = link;
                    });
                  });
                },
                color: Colors.green,
                textColor: Colors.white,
              )
            ],
          ),
        )
    );
  }
}
