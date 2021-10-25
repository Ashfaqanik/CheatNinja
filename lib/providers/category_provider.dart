import 'dart:async';
import 'package:cheat_ninja/api/api_service.dart';
import 'package:cheat_ninja/model/category.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier{
  ApiService _apiService;
  List<Category> _categoryList;
  int count=0;
  int _length;
  bool _isLoading = false;
  bool _isLogged = false;

  get apiService => _apiService;
  List<Category> get allCategories => _categoryList;
  get categoryLength=>_length;
  get isLoading => _isLoading;
  get isLogged => _isLogged;

  ProductProvider(){
    resetStreams();
  }
  void resetStreams(){
    _apiService = ApiService();
    _categoryList = List<Category>();
  }

  set isLogged(bool val) {
    _isLogged = val;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }



   Future<void> fetchCategories()async{
    List<Category> categoryModel =await _apiService.getCategories();
    if(categoryModel.length>0){
      _categoryList.addAll(categoryModel);
    }
    _length=categoryModel.length;
    notifyListeners();
  }

  Future<void> fetchData()async{
    if(count==0){
      resetStreams();
      fetchCategories();
      count++;
      print('count:$count');
    }else{
      Future.delayed(Duration(minutes: 10), () async {
        resetStreams();
        fetchCategories();
        fetchData();
      });
    }
  }

}