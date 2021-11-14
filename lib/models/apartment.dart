class Apartment{
  int? id;
  String? title;
  String? description;
  String? rent;
  String? reporter;
  String? todoDate;
  String? category;
  String? bedroom;
  String? furniture;
  int? isFinished;


  apartmentMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['rent'] = rent;
    mapping['reporter'] = reporter;
    mapping['todoDate'] = todoDate;
    mapping['category'] = category;
    mapping['bedroom'] = bedroom;
    mapping['furniture'] = furniture;
    mapping['isFinished'] = isFinished;
    return mapping;
  }
}