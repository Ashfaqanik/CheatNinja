class CustomerModel{
  String username;
  String email;
  String password;

  CustomerModel({this.username,this.email, this.password});

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map={};

    map.addAll({
      'username': username,
      'email': email,
      'password': password,
    });

    return map;
  }
}