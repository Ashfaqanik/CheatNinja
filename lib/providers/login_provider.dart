import 'package:cheat_ninja/model/login_model.dart';
import 'package:flutter/cupertino.dart';
import '../api/api_service.dart';

class LoginProvider extends ChangeNotifier{
  ApiService _apiService;
  LoginModel _loginModel;
  bool _isLoading = false;
  bool _isLogged = false;

  get apiService => _apiService;
  get loginModel => _loginModel;
  get isLoading => _isLoading;
  get isLogged => _isLogged;

  LoginProvider(){
    resetStreams();
  }
  void resetStreams(){
    _apiService = ApiService();
  }

  set isLogged(bool val) {
    _isLogged = val;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
  set loginModel(LoginModel model) {
    model = LoginModel();
    _loginModel = model;
    notifyListeners();
  }

}