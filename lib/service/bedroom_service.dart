import 'package:rentalzapp/models/bedroom.dart';
import 'package:rentalzapp/repositories/repository.dart';

class BedroomService{
  Repository? _repository;

  BedroomService(){
    _repository = Repository();
  }
  
  // creating data
  saveBedroom(Bedroom bedroom) async{
    return await _repository!.insertData('bedrooms', bedroom.bedroomMap());
  }
  
  // read Bedroom
  readBedrooms() async{
    return await _repository!.readData('bedrooms');
  }

  //read bedroom by id
  readBedroomsById(bedroomId) async {
    return await _repository!.readDataById('bedrooms', bedroomId);
  }

  //update
  updateBedroom(Bedroom bedroom) async {
    return await _repository!.updateData('bedrooms', bedroom.bedroomMap());
  }

  //delete
  deleteBedroom(bedroomId) async {
    return await _repository!.deleteData('categories',bedroomId);
  }
}