class Product{
  int id;
  String name;
  String price;
  String dateCreated;
  List<Categories> categories;
  List<Images> images;
  String stockStatus;

  Product({this.id, this.name, this.price,this.dateCreated,this.categories, this.images,this.stockStatus});

  Product.fromJson(Map<String,dynamic> json){
    id=json['id'];
    name=json['name'];
    price=json['price'];
    dateCreated=json['date_created'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    stockStatus=json['stock_status'];
  }
}
class Images{
  String src;

  Images({this.src});

  Images.fromJson(Map<String,dynamic> json){
    src = json['src'];
  }
}
class Categories{
  String id;
  String name;
  Categories({this.id,this.name});

  Categories.fromJson(Map<String,dynamic> json){
    name = json['name'];
  }
}