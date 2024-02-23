class CategoryModel{
  String? name, categoryId;
  List<String>? exercises;

  static CategoryModel toObject(map){
    CategoryModel model = CategoryModel();
    model.name = map['name'] ?? "";
    model.categoryId = map['categoryId'] ?? "";
    model.exercises = [];
    List list = (map['exercises'] ?? []);
    for (var element in list) {
      model.exercises!.add(element.toString());
    }
    return model;
  }

  Map<String, dynamic> getMap(){
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['categoryId'] = categoryId;
    List<dynamic> list = [];
    exercises!.forEach((element) {
      list.add(element);
    });
    map['exercises'] = list;

    return map;
  }
}