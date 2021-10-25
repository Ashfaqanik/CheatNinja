class LoginModel{
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;

  LoginModel({this.success, this.statusCode, this.code, this.message, this.data});

  LoginModel.fromJson(Map<String,dynamic> json){
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    data = json['data'].length>0&&statusCode==200? new Data.fromJson(json['data']):null;
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    if(this.data!=null){
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
class Data{
  String token;
  int id;
  String email;
  String username;
  String nicename;

  Data({this.token, this.id,this.email,this.username,this.nicename});

  Data.fromJson(Map<String,dynamic> json){
    token = json['token'];
    id = json['id'];
    email = json['email'];
    username = json['username'];
    nicename = json['nicename'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['nicename'] = this.nicename;
    return data;
  }
}