import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getuser => _user;
  Future<void> refreshuser() async{
    User user = await _authMethods.getUserDetails(); 
    _user = user;
    notifyListeners();
  }
}