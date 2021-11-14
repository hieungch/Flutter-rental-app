class Furniture{
  int? id;
  String? name;
  String? description;

  furnitureMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }
}