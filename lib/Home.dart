import 'package:flutter/material.dart';

import 'Helper/AnnotationHelper.dart';
import 'model/Annotation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();

  _showRegisterScreen(){
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Add annotation"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Type a title"
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Type a description"
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context),
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: (){

                  _saveAnnotation();
                },
                child: Text("Save"),
              )
            ],
          );
      }
    );
  }

  _saveAnnotation() async{

    String title = _titleController.text;
    String description = _descriptionController.text;

    Annotation annotation = Annotation(title,description,DateTime.now().toString());
    int result = await _db.saveAnnotation(annotation);
    print("annotation saved "+result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take a Note"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            _showRegisterScreen();
          }
      ),
    );
  }
}
