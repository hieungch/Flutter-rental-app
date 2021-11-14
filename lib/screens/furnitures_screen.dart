import 'package:flutter/material.dart';
import 'package:rentalzapp/models/furniture.dart';
import 'package:rentalzapp/service/furniture_service.dart';

import 'home_screen.dart';

class FurnituresScreen extends StatefulWidget {
  const FurnituresScreen({Key? key}) : super(key: key);

  @override
  _FurnituresScreenState createState() => _FurnituresScreenState();
}

class _FurnituresScreenState extends State<FurnituresScreen> {
  var _furnitureNameController = TextEditingController();
  var _furnitureDescriptionController = TextEditingController();

  var _furniture = Furniture();
  var _furnitureService = FurnitureService();

  List<Furniture> _furnitureList = <Furniture>[];

  var furniture;
  var _editfurnitureNameController = TextEditingController();
  var _editfurnitureDescriptionController = TextEditingController();

  void initState(){
    super.initState();
    getAllFurnitures();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllFurnitures() async{
    _furnitureList = <Furniture>[];
    var Furnitures = await _furnitureService.readFurnitures();
    Furnitures.forEach((furniture){
      setState(() {
        var furnitureModel = Furniture();
        furnitureModel.name = furniture['name'];
        furnitureModel.description = furniture['description'];
        furnitureModel.id = furniture['id'];
        _furnitureList.add(furnitureModel);
      });
    });
  }

  _editFurniture(BuildContext context, furnitureId) async{
    furniture = await _furnitureService.readFurnituresById(furnitureId);
    setState((){
      _editfurnitureNameController.text = furniture[0]['name']??'No name';
      _editfurnitureDescriptionController.text =
          furniture[0]['description']??'no description';
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
                _furniture.name = _furnitureNameController.text;
                _furniture.description = _furnitureDescriptionController.text;
                var result = await _furnitureService.saveFurniture(_furniture);
                if(result >0){
                  //print(result);
                  Navigator.pop(context);
                  getAllFurnitures();
                }
              },
              child: Text('Save'),
          ),
        ],
        title: Text('Furnitures Form'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _furnitureNameController,
                decoration: InputDecoration(
                  hintText: 'Write a furniture type',
                  labelText: 'Furniture'
                ),
              ),
              TextField(
                controller: _furnitureDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description'
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
                  _furniture.id = furniture[0]['id'];
                  _furniture.name = _editfurnitureNameController.text;
                  _furniture.description = _editfurnitureDescriptionController.text;
                  var result = await _furnitureService.updateFurniture(_furniture);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllFurnitures();
                    _showSuccessSnackBar(Text('Updated'));
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit furniture Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editfurnitureNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a furniture',
                        labelText: 'Furniture'
                    ),
                  ),
                  TextField(
                    controller: _editfurnitureDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //DELETE FORM DIALOG
  _deleteFormDialog(BuildContext context, furnitureId){
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

                  var result = await _furnitureService.deleteFurniture(furnitureId);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllFurnitures();
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
        title: Text('Furnitures'),
      ),
      body: ListView.builder(
         itemCount: _furnitureList.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 16.0),
              child: Card(
                elevation: 10.0,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                        _editFurniture(context, _furnitureList[index].id);
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_furnitureList[index].name!),
                      IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _furnitureList[index].id);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      )
                    ],
                  ),
                  subtitle: Text(_furnitureList[index].description!),
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
