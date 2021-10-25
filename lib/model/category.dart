import 'dart:ui';

class Category{
  int categoryId;
  String categoryName;
  Images image;

  Category({this.categoryId, this.categoryName, this.image});

  Category.fromJson(Map<String,dynamic> json){
    categoryId = json['id'];
    categoryName = json['name'];
    image = json['image']!=null? new Images.fromJson(json['image']):null;
  }
}

class Images{
  String src,name;

  Images({this.src,this.name});

  Images.fromJson(Map<String,dynamic> json){
    src=json['src'];
    name=json['name'];
  }
}