import 'package:cheat_ninja/api/api_service.dart';
import 'package:cheat_ninja/model/product.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier{
  ApiService _apiService;
  List<Product> _productList;
  int _length;
  bool _isLoading = false;
  bool _isLogged = false;

  get apiService => _apiService;
  List<Product> get allProducts => _productList;
  get productLength=>_length;
  get isLoading => _isLoading;
  get isLogged => _isLogged;

  ProductProvider(){
    resetStreams();
  }
  void resetStreams(){
    _apiService = ApiService();
    _productList = List<Product>();
  }

  set isLogged(bool val) {
    _isLogged = val;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> fetchProducts(int categoryId)async{
    List<Product> itemModel =await _apiService.getProducts(categoryId);
    if(itemModel.length>0){
      _productList.addAll(itemModel);
    }
    _length=itemModel.length;
    notifyListeners();
  }

}