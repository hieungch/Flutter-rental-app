import 'package:flutter/material.dart';
import 'package:rentalzapp/models/apartment.dart';
import 'package:rentalzapp/service/category_service.dart';
import 'package:rentalzapp/service/bedroom_service.dart';
import 'package:rentalzapp/service/furniture_service.dart';
import 'package:rentalzapp/service/apartment_service.dart';
import 'home_screen.dart';
import 'package:intl/intl.dart';

class ApartmentScreen extends StatefulWidget {
  const ApartmentScreen({Key? key}) : super(key: key);

  @override
  _ApartmentScreenState createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  ApartmentServices? _apartmentServices;
  List<Apartment>? _apartmentList;

  var _apartmentTitleController = TextEditingController();
  var _apartmentDescriptionController = TextEditingController();
  var _apartmentMoneyController = TextEditingController();
  var _apartmentReporterController = TextEditingController();
  var _apartmentDateController = TextEditingController();

  var _selectedValue;
  var _selectedBedValue;
  var _selectedFurnitureValue;
  var _categories = <DropdownMenuItem>[];
  var _bedrooms = <DropdownMenuItem>[];
  var _furnitures = <DropdownMenuItem>[];

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _loadCategories() async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }
  _loadBedrooms() async{
    var _bedroomService = BedroomService();
    var bedrooms = await _bedroomService.readBedrooms();
    bedrooms.forEach((bedroom){
      setState(() {
        _bedrooms.add(DropdownMenuItem(
          child: Text(bedroom['name']),
          value: bedroom['name'],
        ));
      });
    });
  }

  _loadFurnitures() async{
    var _furnitureService = FurnitureService();
    var furnitures = await _furnitureService.readFurnitures();
    furnitures.forEach((furniture){
      setState(() {
        _furnitures.add(DropdownMenuItem(
          child: Text(furniture['name']),
          value: furniture['name'],
        ));
      });
    });
  }

  DateTime _datetime = DateTime.now();
  _selectedApartmentDate (BuildContext context) async{
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _datetime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2200)
    );
    if (_pickedDate!= null){
      setState(() {
        _datetime = _pickedDate;
        _apartmentDateController.text = DateFormat('yyyy-mm-dd').format(_pickedDate);
      });
    }
  }
  getAllApartments() async{
    _apartmentServices = ApartmentServices();
    _apartmentList = <Apartment>[];
    var apartments = await _apartmentServices!.readApartments();
    apartments.forEach((apartment){
      setState(() {
        var model = Apartment();
        model.id = apartment['id'];
        model.title= apartment['title'];
        model.description= apartment['description'];
        model.rent= apartment['rent'];
        model.reporter= apartment['reporter'];
        model.todoDate= apartment['todoDate'];
        model.category= apartment['category'];
        model.bedroom= apartment['bedroom'];
        model.furniture= apartment['furniture'];
        model.isFinished=apartment['isFinished'];
        _apartmentList!.add(model);
      });
    });
  }
  @override
  void initState(){
    super.initState();
    _loadCategories();
    _loadBedrooms();
    _loadFurnitures();
    getAllApartments();
    //  getAllTodos(); no longer needed
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
        title: Text('Create Apartment'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column (
            children: [
              TextFormField(
                controller: _apartmentTitleController,
                decoration: InputDecoration(
                  labelText: 'Apartment name',
                  hintText: 'Enter name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter apartment name';
                  }
                  return null;
                }, //Validation
              ),
              TextFormField(
                controller: _apartmentDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Enter notes',
                ),
              ),
              TextFormField(
                controller: _apartmentMoneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rent price(USD)',
                  hintText: 'Enter price ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rent price';
                  }
                  return null;
                }, //Validation
              ),
              TextFormField(
                controller: _apartmentReporterController,
                decoration: InputDecoration(
                  labelText: 'Reporter name',
                  hintText: 'Enter reporter name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reporter name';
                  }
                  return null;
                }, //Validation
              ),
              TextFormField(
                controller: _apartmentDateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Apartment creation date',
                  prefixIcon: InkWell(
                    onTap: (){
                      _selectedApartmentDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid date';
                  }
                  return null;
                }, //Validation
              ),
              DropdownButtonFormField<dynamic>(
                value: _selectedValue,
                items: _categories,
                hint: Text('Property type'),
                onChanged: (value){
                  setState((){
                    _selectedValue = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose a category';
                  }
                  return null;
                }, //Validation
              ),
              DropdownButtonFormField<dynamic>(
                value: _selectedBedValue,
                items: _bedrooms,
                hint: Text('Bedroom type'),
                onChanged: (value){
                  setState((){
                    _selectedBedValue = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose a bed type';
                  }
                  return null;
                }, //Validation
              ),
              DropdownButtonFormField<dynamic>(
                value: _selectedFurnitureValue,
                items: _furnitures,
                hint: Text('Furniture stype'),
                onChanged: (value){
                  setState((){
                    _selectedFurnitureValue = value;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    var apartmentObject = Apartment();
                    apartmentObject.title = _apartmentTitleController.text;
                    apartmentObject.description= _apartmentDescriptionController.text;
                    apartmentObject.rent= _apartmentMoneyController.text;
                    apartmentObject.reporter= _apartmentReporterController.text;
                    apartmentObject.isFinished = 0;
                    apartmentObject.category= _selectedValue;
                    apartmentObject.bedroom= _selectedBedValue;
                    apartmentObject.furniture= _selectedFurnitureValue;
                    apartmentObject.todoDate = _apartmentDateController.text;

                    var _apartmentService = ApartmentServices();
                    var result = await _apartmentService.saveApartment(apartmentObject);
                    if ( result >0 ){
                      // _loadCategories();
                      _showSuccessSnackBar(Text('Created sucessfully'));
                      getAllApartments();
                      print(result);
                    }
                  }
                },
                child: Text('SUBMIT'),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
