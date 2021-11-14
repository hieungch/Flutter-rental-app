import 'package:rentalzapp/models/apartment.dart';
import 'package:rentalzapp/repositories/repository.dart';

class ApartmentServices{
  Repository? _repository;

  ApartmentServices(){
    _repository = Repository();
  }
  saveApartment(Apartment apartment)async{
    return await _repository!.insertData('apartments', apartment.apartmentMap());
  }

  //read apartment
  readApartments()async{
    return await _repository!.readData('apartments');
  }

  readApartmentsById(apartmentId) async {
    return await _repository!.readDataById('Apartments', apartmentId);
  }

  //update
  updateApartment(Apartment apartment) async {
    return await _repository!.updateData('apartments', apartment.apartmentMap());
  }

  //delete
  deleteApartment(apartmentId) async {
    return await _repository!.deleteData('apartments',apartmentId);
  }

}