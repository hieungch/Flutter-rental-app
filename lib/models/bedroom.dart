class Bedroom{
  int? id;
  String? name;
  String? description;

  bedroomMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }
}