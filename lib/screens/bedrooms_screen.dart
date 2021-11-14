import 'package:flutter/material.dart';
import 'package:rentalzapp/models/bedroom.dart';
import 'package:rentalzapp/service/bedroom_service.dart';

import 'home_screen.dart';

class BedroomsScreen extends StatefulWidget {
  const BedroomsScreen({Key? key}) : super(key: key);

  @override
  _BedroomsScreenState createState() => _BedroomsScreenState();
}

class _BedroomsScreenState extends State<BedroomsScreen> {
  var _bedroomNameController = TextEditingController();
  var _bedroomDescriptionController = TextEditingController();

  var _bedroom = Bedroom();
  var _bedroomService = BedroomService();

  List<Bedroom> _bedroomList = <Bedroom>[];

  var bedroom;
  var _editbedroomNameController = TextEditingController();
  var _editbedroomDescriptionController = TextEditingController();

  void initState(){
    super.initState();
    getAllBedrooms();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllBedrooms() async{
    _bedroomList = <Bedroom>[];
    var Bedrooms = await _bedroomService.readBedrooms();
    Bedrooms.forEach((bedroom){
      setState(() {
        var bedroomModel = Bedroom();
        bedroomModel.name = bedroom['name'];
        bedroomModel.description = bedroom['description'];
        bedroomModel.id = bedroom['id'];
        _bedroomList.add(bedroomModel);
      });
    });
  }

  _editBedroom(BuildContext context, bedroomId) async{
    bedroom = await _bedroomService.readBedroomsById(bedroomId);
    setState((){
      _editbedroomNameController.text = bedroom[0]['name']??'No name';
      _editbedroomDescriptionController.text =
          bedroom[0]['description']??'no description';
    });
    _editFormDialog(context);
  }

  //SHOW FORM DIALOG
  _showFormDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red,
            ),
              onPressed: ()=>Navigator.pop(context),
              child: Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.green,
            ),
              onPressed: () async{
                _bedroom.name = _bedroomNameController.text;
                _bedroom.description = _bedroomDescriptionController.text;
                var result = await _bedroomService.saveBedroom(_bedroom);
                if(result >0){
                  //print(result);
                  Navigator.pop(context);
                  getAllBedrooms();
                }
              },
              child: Text('Save'),
          ),
        ],
        title: Text('Bedrooms Form'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _bedroomNameController,
                decoration: InputDecoration(
                  hintText: 'Write a bedrooms',
                  labelText: 'Bedroom'
                ),
              ),
              TextField(
                controller: _bedroomDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description(cm)'
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  //EDIT FORM DIALOG
  _editFormDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param){
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: ()=>Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () async{
                  _bedroom.id = bedroom[0]['id'];
                  _bedroom.name = _editbedroomNameController.text;
                  _bedroom.description = _editbedroomDescriptionController.text;
                  var result = await _bedroomService.updateBedroom(_bedroom);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllBedrooms();
                    _showSuccessSnackBar(Text('Updated'));
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Bedrooms Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editbedroomNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a bedrooms',
                        labelText: 'Bedroom'
                    ),
                  ),
                  TextField(
                    controller: _editbedroomDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description(cm)'
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //DELETE FORM DIALOG
  _deleteFormDialog(BuildContext context, bedroomId){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param){
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: ()=>Navigator.pop(context),
                child: Text('NO!'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () async{

                  var result = await _bedroomService.deleteBedroom(bedroomId);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllBedrooms();
                    _showSuccessSnackBar(Text('Deleted'));
                  }
                },
                child: Text('YES!'),
              ),
            ],
            title: Text('Are you sure you want to do this?'),
          );
        });
  }

  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          elevation: 0.0,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.blue,
        ),
        title: Text('Bedrooms'),
      ),
      body: ListView.builder(
         itemCount: _bedroomList.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 16.0),
              child: Card(
                elevation: 10.0,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                        _editBedroom(context, _bedroomList[index].id);
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_bedroomList[index].name!),
                      IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _bedroomList[index].id);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      )
                    ],
                  ),
                  subtitle: Text(_bedroomList[index].description!),
                ),
              ),
            );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
