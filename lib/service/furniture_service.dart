import 'package:rentalzapp/models/furniture.dart';
import 'package:rentalzapp/repositories/repository.dart';

class FurnitureService{
  Repository? _repository;

  FurnitureService(){
    _repository = Repository();
  }
  
  // creating data
  saveFurniture(Furniture furniture) async{
    return await _repository!.insertData('furnitures', furniture.furnitureMap());
  }
  
  // read furniture
  readFurnitures() async{
    return await _repository!.readData('furnitures');
  }

  //read furniture by id
  readFurnituresById(furnitureId) async {
    return await _repository!.readDataById('furnitures', furnitureId);
  }

  //update
  updateFurniture(Furniture furniture) async {
    return await _repository!.updateData('furnitures', furniture.furnitureMap());
  }

  //delete
  deleteFurniture(furnitureId) async {
    return await _repository!.deleteData('categories',furnitureId);
  }
}