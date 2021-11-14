import 'package:rentalzapp/models/category.dart';
import 'package:rentalzapp/repositories/repository.dart';

class CategoryService{
  Repository? _repository;
  
  CategoryService(){
    _repository = Repository();
  }
  
  // creating data
  saveCategory(Category category) async{
    return await _repository!.insertData('categories', category.categoryMap());
  }
  
  // read category
  readCategories() async{
    return await _repository!.readData('categories');
  }

  //read category by id
  readCategoriesById(categoryId) async {
    return await _repository!.readDataById('categories', categoryId);
  }

  //update
  updateCategory(Category category) async {
    return await _repository!.updateData('categories', category.categoryMap());
  }

  //delete
  deleteCategory(categoryId) async {
    return await _repository!.deleteData('categories',categoryId);
  }
}