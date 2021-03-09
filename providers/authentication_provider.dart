import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  String _idToken;
  String _userId;
  DateTime _expiryDate;

  String get idToken {
    return _idToken;
  }

  Future<void> logoutUser() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();
    _idToken = prefs.getString('idToken');
    if (_idToken != null) {
      var milliSecondsSinceEpoch = prefs.getInt('expiryDate');
      _expiryDate = DateTime.fromMillisecondsSinceEpoch(milliSecondsSinceEpoch);
      _userId = prefs.getString('userId');
      if (DateTime.now().isBefore(_expiryDate)) {
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> saveAuthDataAndUserData(
    double latitude,
    double longitude,
    String phoneNumber,
    String userName,
    String email,
    String userId,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('idToken', _idToken);
    await prefs.setString('userId', _userId);
    var milliSecondsSinceEpoch = _expiryDate.microsecondsSinceEpoch;
    await prefs.setInt('expiryDate', milliSecondsSinceEpoch);

    await saveUserInDataBase(
        latitude, longitude, phoneNumber, userName, email, userId);
  }

  Future<void> saveAuthData() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('idToken', _idToken);
    await prefs.setString('userId', _userId);
    var milliSecondsSinceEpoch = _expiryDate.microsecondsSinceEpoch;
    await prefs.setInt('expiryDate', milliSecondsSinceEpoch);
  }

  Future<void> saveAuthDataAndVendorData(
    double latitude,
    double longitude,
    String phoneNumber,
    String userName,
    String email,
    String userId,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('idToken', _idToken);
    await prefs.setString('userId', _userId);
    var milliSecondsSinceEpoch = _expiryDate.microsecondsSinceEpoch;
    await prefs.setInt('expiryDate', milliSecondsSinceEpoch);

    await saveVendorInDataBase(
        latitude, longitude, phoneNumber, userName, email, userId);
  }

  Future<bool> saveUserInDataBase(
    double latitude,
    double longitude,
    String phoneNumber,
    String userName,
    String email,
    String userId,
  ) async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/users/$userId.json?auth=$_idToken';

    var res = await http.patch(
      url,
      body: json.encode(
        {
          'latitude': latitude,
          'longitude': longitude,
          'phoneNumber': phoneNumber,
          'userName': userName,
          'email': email,
        },
      ),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveVendorInDataBase(
    double latitude,
    double longitude,
    String phoneNumber,
    String userName,
    String email,
    String userId,
  ) async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/vendor/$userId.json?auth=$_idToken';

    var res = await http.patch(
      url,
      body: json.encode(
        {
          'latitude': latitude,
          'longitude': longitude,
          'phoneNumber': phoneNumber,
          'userName': userName,
          'email': email,
        },
      ),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signInUser(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDm1YqJahaqceGwXU-8xodlXb-xgSgDNCU';

    try {
      var res = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      print(jsonResult);
      if (jsonResult.containsKey('error')) {
        String errorMessage = '';
        print(jsonResult['error']);
        switch (jsonResult['error']['message']) {
          case 'INVALID_EMAIL':
            errorMessage = 'Please use a valid email';
            break;
          case 'EMAIL_NOT_FOUND':
            errorMessage =
                'Email is not found, please use a registered email or register a new one';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'The password entered is incorrect';
            break;
          case 'USER_DISABLED':
            errorMessage =
                'This user has been disabled, please enable it before signIn';
            break;
        }
        throw Exception(errorMessage);
      } else {
        _idToken = jsonResult['idToken'];
        _userId = jsonResult['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(jsonResult['expiresIn'])));
        await saveAuthData();
        notifyListeners();
        return true;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> signInVendor(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDm1YqJahaqceGwXU-8xodlXb-xgSgDNCU';

    try {
      var res = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      print(jsonResult);
      if (jsonResult.containsKey('error')) {
        String errorMessage = '';
        print(jsonResult['error']);
        switch (jsonResult['error']['message']) {
          case 'INVALID_EMAIL':
            errorMessage = 'Please use a valid email';
            break;
          case 'EMAIL_NOT_FOUND':
            errorMessage =
                'Email is not found, please use a registered email or register a new one';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'The password entered is incorrect';
            break;
          case 'USER_DISABLED':
            errorMessage =
                'This user has been disabled, please enable it before signIn';
            break;
        }
        throw Exception(errorMessage);
      } else {
        _idToken = jsonResult['idToken'];
        _userId = jsonResult['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(jsonResult['expiresIn'])));
        await saveAuthData();
        notifyListeners();
        return true;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> signUpUser(String email, String password, String phoneNumber,
      String username, double lat, double lon) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDm1YqJahaqceGwXU-8xodlXb-xgSgDNCU';
    try {
      var res = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      if (jsonResult.containsKey('error')) {
        String errorMessage = '';
        print(jsonResult['error']);
        switch (jsonResult['error']['message']) {
          case 'EMAIL_EXISTS':
            errorMessage = 'This email already registered';
            break;
          case 'INVALID_EMAIL':
            errorMessage = 'Please use a valid email';
            break;
          case 'EMAIL_NOT_FOUND':
            errorMessage =
                'Email is not found, please use a registered email or register a new one';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'The password entered is incorrect';
            break;
          case 'USER_DISABLED':
            errorMessage =
                'This user has been disabled, please enable it before signIn';
            break;
        }
        throw Exception(errorMessage);
      } else {
        _idToken = jsonResult['idToken'];
        _userId = jsonResult['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(jsonResult['expiresIn'])));
        await saveAuthDataAndUserData(
            lat, lon, phoneNumber, username, email, _userId);
        notifyListeners();
        return true;
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> signUpVendor(String email, String password, String phoneNumber,
      String username, double lat, double lon) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDm1YqJahaqceGwXU-8xodlXb-xgSgDNCU';
    try {
      var res = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      if (jsonResult.containsKey('error')) {
        String errorMessage = '';
        print(jsonResult['error']);
        switch (jsonResult['error']['message']) {
          case 'EMAIL_EXISTS':
            errorMessage = 'This email already registered';
            break;
          case 'INVALID_EMAIL':
            errorMessage = 'Please use a valid email';
            break;
          case 'EMAIL_NOT_FOUND':
            errorMessage =
                'Email is not found, please use a registered email or register a new one';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'The password entered is incorrect';
            break;
          case 'USER_DISABLED':
            errorMessage =
                'This user has been disabled, please enable it before signIn';
            break;
        }
        throw Exception(errorMessage);
      } else {
        _idToken = jsonResult['idToken'];
        _userId = jsonResult['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(jsonResult['expiresIn'])));
        await saveAuthDataAndVendorData(
            lat, lon, phoneNumber, username, email, _userId);
        notifyListeners();
        return true;
      }
    } catch (error) {
      throw (error);
    }
  }
}
