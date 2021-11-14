import 'package:flutter/material.dart';
import 'package:rentalzapp/models/category.dart';
import 'package:rentalzapp/service/category_service.dart';
import 'home_screen.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = <Category>[];

  var category;
  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();

  void initState(){
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async{
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoriesById(categoryId);
    setState((){
      _editcategoryNameController.text = category[0]['name']??'No name';
      _editcategoryDescriptionController.text =
          category[0]['description']??'no description';
    });
    _editFormDialog(context);
  }

  //ADD FORM DIALOG
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
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;
                var result = await _categoryService.saveCategory(_category);
                if(result >0){
                  //print(result);
                  Navigator.pop(context);
                  getAllCategories();
                }
              },
              child: Text('Save'),
          ),
        ],
        title: Text('Properties Form'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write a categories',
                  labelText: 'Category'
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'description'
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
                  _category.id = category[0]['id'];
                  _category.name = _editcategoryNameController.text;
                  _category.description = _editcategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(Text('Updated'));
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editcategoryNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a categories',
                        labelText: 'Category'
                    ),
                  ),
                  TextField(
                    controller: _editcategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'description'
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //DELETE FORM DIALOG
  _deleteFormDialog(BuildContext context, categoryId){
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

                  var result = await _categoryService.deleteCategory(categoryId);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllCategories();
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
        title: Text('Property type'),
      ),
      body: ListView.builder(
         itemCount: _categoryList.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 16.0),
              child: Card(
                elevation: 10.0,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                        _editCategory(context, _categoryList[index].id);
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_categoryList[index].name!),
                      IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      )
                    ],
                  ),
                  subtitle: Text(_categoryList[index].description!),
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
