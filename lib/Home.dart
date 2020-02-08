import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Helper/AnnotationHelper.dart';
import 'model/Annotation.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();
  List<Annotation> _annotations = List<Annotation>();

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
                  Navigator.pop(context);
                },
                child: Text("Save"),
              )
            ],
          );
      }
    );
  }

  _recoveryAnnotation() async{

    List annotationsRecovered = await _db.recoveryAnnotation();

    List<Annotation> tempList = List<Annotation>();
    for(var item in annotationsRecovered){
      Annotation annotation = Annotation.fromMap(item);
      tempList.add(annotation);
    }
    setState(() {
      _annotations = tempList;

    });
    tempList = null;


  }

  _saveAnnotation() async{

    String title = _titleController.text;
    String description = _descriptionController.text;

    _titleController.clear();
    _descriptionController.clear();

    Annotation annotation = Annotation(title,description,DateTime.now().toString());
    int result = await _db.saveAnnotation(annotation);
    print("annotation saved "+result.toString());

    _recoveryAnnotation();
  }

  @override
  void initState(){
    super.initState();
    _recoveryAnnotation();
  }
  _formatDate(String date){

    initializeDateFormatting("pt_BR");

    //var formater = DateFormat("d/MM/y H:m");

    var formater = DateFormat.yMd("pt_BR");
    DateTime convertedDate = DateTime.parse(date);
    String formatedDate = formater.format( convertedDate);
    return formatedDate;
  }

  @override
  Widget build(BuildContext context) {

    _recoveryAnnotation();
    return Scaffold(
      appBar: AppBar(
        title: Text("Take a Note"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _annotations.length,
                itemBuilder: (context, index){
                    final item = _annotations[index];
                    return Card(
                      child: ListTile(
                        title: Text( item.title),
                        subtitle: Text("${_formatDate(item.date)} - ${item.description}"),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
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
