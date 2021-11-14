import 'package:flutter/material.dart';
import 'package:rentalzapp/helpers/drawer_navigation.dart';
import 'package:rentalzapp/models/apartment.dart';
import 'package:rentalzapp/service/apartment_service.dart';
import 'package:rentalzapp/service/category_service.dart';
import 'package:rentalzapp/service/bedroom_service.dart';
import 'package:rentalzapp/service/furniture_service.dart';
import 'apartment_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  ApartmentServices? _apartmentServices;
  List<Apartment>? _apartmentList;

  var apartment;
  var _editApartmentTitleController = TextEditingController();
  var _editApartmentDescriptionController = TextEditingController();
  var _editApartmentMoneyController = TextEditingController();
  var _editApartmentReporterController = TextEditingController();
  var _editApartmenttDateController = TextEditingController();

  var _selectedValue;
  var _selectedBedValue;
  var _selectedFurnitureValue;
  var _categories = <DropdownMenuItem>[];
  var _bedrooms = <DropdownMenuItem>[];
  var _furnitures = <DropdownMenuItem>[];

  var _apartment = Apartment();
  var _apartmentService = ApartmentServices();

  var _apartmentDateController = TextEditingController();

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

  void initState()  {
    super.initState();
    getAllApartments();
    _loadCategories();
    _loadBedrooms();
    _loadFurnitures();
    _findItem = _apartmentList;
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

  _showApartment(BuildContext context, apartmentId) async{
    apartment = await _apartmentService.readApartmentsById(apartmentId);
    setState((){
      _editApartmentTitleController.text = apartment[0]['title']??'No title';
      _editApartmentDescriptionController.text = apartment[0]['description']??'no description';
      _editApartmentMoneyController.text = apartment[0]['rent']??'no rent';
      _editApartmentReporterController.text = apartment[0]['reporter']??'no description';
      _editApartmenttDateController.text = apartment[0]['todoDate']??'no description';
      _selectedValue = apartment[0]['category'];
      _selectedBedValue = apartment[0]['bedroom'];
      _selectedFurnitureValue = apartment[0]['furniture'];
    });
    _showFormDialog(context);
  }

  _editApartment(BuildContext context, apartmentId) async{
    apartment = await _apartmentService.readApartmentsById(apartmentId);
    setState((){
      _editApartmentTitleController.text = apartment[0]['title']??'No title';
      _editApartmentDescriptionController.text = apartment[0]['description']??'no description';
      _editApartmentMoneyController.text = apartment[0]['rent']??'no rent';
      _editApartmentReporterController.text = apartment[0]['reporter']??'no description';
      _editApartmenttDateController.text = apartment[0]['todoDate']??'no description';
      _selectedValue = apartment[0]['category'];
      _selectedBedValue = apartment[0]['bedroom'];
      _selectedFurnitureValue = apartment[0]['furniture'];
    });
    _editFormDialog(context);
  }

  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
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

  // HOMESCREEN SHOW FORM
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
                  backgroundColor: Colors.blue,
                ),
                onPressed: ()=>Navigator.pop(context),
                child: Text('Back'),
              ),
            ],
            title: Text('Apartments Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    enabled: false,
                    controller: _editApartmentTitleController,
                    decoration: InputDecoration(
                        hintText: 'Write a apartments',
                        labelText: 'Apartment'
                    ),
                  ),
                  TextField(
                    enabled: false,
                    controller: _editApartmentDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'description'
                    ),
                  ),
                  TextField(
                    enabled: false,
                    controller: _editApartmentMoneyController,
                    decoration: InputDecoration(
                        hintText: 'Write new rent',
                        labelText: 'rent(USD)'
                    ),
                  ),
                  TextField(
                    enabled: false,
                    controller: _editApartmentReporterController,
                    decoration: InputDecoration(
                        hintText: 'Write new reporter',
                        labelText: 'reporter'
                    ),
                  ),
                  TextField(
                    enabled: false,
                    controller: _editApartmenttDateController,
                    decoration: InputDecoration(
                      hintText: 'Enter new date',
                      labelText: 'Date',
                      prefixIcon: InkWell(
                        onTap: (){
                          _selectedApartmentDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  DropdownButtonFormField<dynamic>(
                    value: _selectedValue,
                    items: _categories,
                    hint: Text('Property type'),
                    onChanged: null,
                  ),
                  DropdownButtonFormField<dynamic>(
                    value: _selectedBedValue,
                    items: _bedrooms,
                    hint: Text('Bedroom type'),
                    onChanged: null,
                  ),
                  DropdownButtonFormField<dynamic>(
                    value: _selectedFurnitureValue,
                    items: _furnitures,
                    hint: Text('Furniture stype'),
                    onChanged: null,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // HOMESCREEN EDIT FORM
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
                  _apartment.id = apartment[0]['id'];
                  _apartment.title = _editApartmentTitleController.text;
                  _apartment.description = _editApartmentDescriptionController.text;
                  _apartment.rent = _editApartmentMoneyController.text;
                  _apartment.reporter = _editApartmentReporterController.text;
                  _apartment.todoDate = _editApartmenttDateController.text;
                  _apartment.category = _selectedValue;
                  _apartment.bedroom = _selectedBedValue;
                  _apartment.furniture = _selectedFurnitureValue;

                  var result = await _apartmentService.updateApartment(_apartment);
                  if(result >0){
                    Navigator.pop(context);
                    getAllApartments();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
                    _showSuccessSnackBar(Text('Updated'));
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit apartments Form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editApartmentTitleController,
                    decoration: InputDecoration(
                        hintText: 'Write a apartments',
                        labelText: 'Apartment'
                    ),
                  ),
                  TextField(
                    controller: _editApartmentDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'description'
                    ),
                  ),
                  TextField(
                    controller: _editApartmentMoneyController,
                    decoration: InputDecoration(
                        hintText: 'Write new rent',
                        labelText: 'rent(USD)'
                    ),
                  ),
                  TextField(
                    controller: _editApartmentReporterController,
                    decoration: InputDecoration(
                        hintText: 'Write new reporter',
                        labelText: 'reporter'
                    ),
                  ),
                  TextField(
                    controller: _editApartmenttDateController,
                    decoration: InputDecoration(
                        hintText: 'Enter new date',
                        labelText: 'Date',
                      prefixIcon: InkWell(
                        onTap: (){
                          _selectedApartmentDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
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
                ],
              ),
            ),
          );
        });
  }

  // HOMESCREEN DELETE FORM
  _deleteFormDialog(BuildContext context, apartmentId){
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

                  var result = await _apartmentService.deleteApartment(apartmentId);
                  if(result >0){
                    //print(result);
                    Navigator.pop(context);
                    getAllApartments();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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

  List<Apartment>? _findItem;

  @override
  Widget build(BuildContext context) {
    var _textEditingController;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(30)
          ) ,
          child: Center(
            child: TextFormField(
              onChanged: (value) => onSearchTextChanged(value),
              controller: _textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'RentalZ app',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _findItem?.length,
        itemBuilder: (context,index){
          return Card(
            elevation: 10.0,
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editApartment(context, _findItem?.length);
                },

              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Text(_findItem?[index].title?? 'No title'),
                  Text(_findItem?[index].todoDate?? 'No date'),
                  IconButton(
                    onPressed: (){
                      _showApartment(context, _findItem?.length);
                    },
                    icon: Icon(Icons.visibility),
                  ),
                ],
              ),
              subtitle:Text(_findItem?[index].category?? 'No category'),
              trailing: IconButton(
                onPressed: () {
                  _deleteFormDialog(context, _findItem?.length);
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              )

            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.of(context)
            .push(MaterialPageRoute(builder: (context)=>ApartmentScreen())),
        child: Icon(Icons.add),
      ),
    );
  }

  void onSearchTextChanged(String text) {
    List<Apartment> results = [];
    if(text.isEmpty){
      results = _apartmentList!;
    } else
    {
      results = _apartmentList!.where((item)=> item.title!.toLowerCase().contains(text.toLowerCase())).toList();

    }
    setState(() {
      _findItem = results;
    });
  }
}
