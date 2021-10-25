import 'dart:convert';
import 'dart:io';
import 'package:cheat_ninja/api/config.dart';
import 'package:cheat_ninja/model/category.dart';
import 'package:cheat_ninja/model/customer.dart';
import 'package:cheat_ninja/model/login_model.dart';
import 'package:dio/dio.dart';
import '../model/product.dart';
class ApiService {

  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.key + ':' + Config.secret),
    );
    bool ret = false;

    try {
      var response = await Dio().post(
          Config.url + Config.customerUrl,
          data: model.toJson(),
          options: new Options(
              headers: {
                HttpHeaders.authorizationHeader: 'Basic $authToken',
                HttpHeaders.contentTypeHeader: "application/json",
              }
          ));
      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    return ret;
  }

  Future<List<Product>> getProducts(int categoryId) async {
    List<Product> data = List<Product>();

    try {
      String url = Config.url + Config.productUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}&category=$categoryId";
      var response = await Dio().get(
          url, options: new Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json",}
      ));
      if (response.statusCode == 200) {
        data = (response.data as List).map((i) => Product.fromJson(i)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }
  Future<List<Category>> getCategories() async {
    List<Category> data = List<Category>();

    try {
      String url = Config.url + Config.categoriesUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(
          url, options: new Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json",}
      ));
      if (response.statusCode == 200) {
        data = (response.data as List).map((i) => Category.fromJson(i)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<LoginModel> loginCustomer(String username, String password) async {
    LoginModel model;
    try {
      var response = await Dio().post(
          Config.tokenUrl,
          data: {
            //"email": email,
            "username": username,
            "password": password,
          },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/x-www-form-urlencoded",
              }

          ));
      if (response.statusCode == 200) {
        model = LoginModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return model;
  }

}