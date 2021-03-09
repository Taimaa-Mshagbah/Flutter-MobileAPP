import 'package:final_project/admin/shops_page.dart';
import 'package:final_project/pages/chooseWereToLogin.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class AuthenticationPage extends StatefulWidget {
  static const namedRoute = '/authentication_page';
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUserName = '';
  String _enteredPhoneNumber = '';
  bool _isLogin = false;
  bool _isLoading = false;
  void _startAuthProcess() async {
    bool isValid = _loginFormKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _loginFormKey.currentState.save();

    try {
      setState(() {
        _isLoading = true;
      });
      var success = false;
      if (_isLogin) {
        success =
            await Provider.of<AuthenticationProvider>(context, listen: false)
                .signInVendor(_enteredEmail, _enteredPassword);
      } else {
        var position = await _determinePosition();
        if (position != null) {
          success =
              await Provider.of<AuthenticationProvider>(context, listen: false)
                  .signUpVendor(
                      _enteredEmail,
                      _enteredPassword,
                      _enteredPhoneNumber,
                      _enteredUserName,
                      position.latitude,
                      position.longitude);
        } else {
          showCustomDialog(
              'Please give us permission to get your location to proceed in your signUp process');
        }
      }

      if (success) {
        Navigator.of(context).pushReplacementNamed(ShopsPage.namedRoute);
      }
    } catch (error) {
      showCustomDialog(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  showCustomDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.red[200],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('WHAT SHE WANTS'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(ChooseLogin.namedRoute);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _loginFormKey,
              child: Center(
                child: Container(
                    child: _isLogin ? getSignInCard() : getSignUpCard()),
              ),
            ),
    );
  }

  Widget getSignUpCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                cursorColor: Colors.red[200],
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.red[200])),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a valid email please';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredEmail = newValue;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.red[200])),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredPassword = newValue;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: TextStyle(color: Colors.red[200])),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredPhoneNumber = newValue;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'User name',
                    labelStyle: TextStyle(color: Colors.red[200])
                    //  focusColor: Colors.red[200],
                    ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a user name';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredUserName = newValue;
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.red[200],
                onPressed: () {
                  _startAuthProcess();
                },
                child: Text('Sign up'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text('Already have an account?'),
                textColor: Colors.red[200],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSignInCard() {
    return Container(
        // width: MediaQuery.of(context).size.width * 0.7,
        // height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.red[200],
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage('assets/pexels-photo-1939485.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Container(
              //  mainAxisAlignment: MainAxisAlignment.center,

              child: SingleChildScrollView(
                child: Text(
                  "Sing in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.red[200]),
                      focusColor: Colors.red[200],
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid email please';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredEmail = newValue;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.red[200]),
                      focusColor: Colors.red[200],
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredPassword = newValue;
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.red[200],
                    onPressed: () {
                      _startAuthProcess();
                    },
                    child: Text('Sign in'),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text('Create an account'),
                    textColor: Colors.red[200],
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
