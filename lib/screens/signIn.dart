import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenth_week_app/styles/style.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  String _username = '';
  String _password = '';

  bool _signInCheck = false;

  Future<void> _loadFields() async {
    var _regData = await SharedPreferences.getInstance();

    bool _signIn = _regData.getBool('signInCheck') ?? false;

    if (_signIn == true) {
      setState(() {
        _usernameController =
            TextEditingController(text: _regData.getString('username'));
        _passwordController =
            TextEditingController(text: _regData.getString('password'));
        _signInCheck = true;
      });
    }
  }

  Future<bool> _signIn(String username, String password) async {
    bool _signedIn = false;
    var _regData = await SharedPreferences.getInstance();
    if ((_regData.getString('username') == username) &&
        (_regData.getString('password') == password)) {
      _signedIn = true;
    } else {
      _signedIn = false;
    }
    return _signedIn;
  }

  Future<void> _signInRemember(bool signInCheck) async {
    var _regData = await SharedPreferences.getInstance();
    _regData.setBool('signInCheck', signInCheck);
  }

  Future<void> _signOut() async {
    var _regData = await SharedPreferences.getInstance();
    _regData.remove('username');
    _regData.remove('password');
    _regData.remove('signInCheck');

    setState(() {
      _usernameController.clear();
      _passwordController.clear();
      _signInCheck = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(top: 50.0),
            child: Stack(alignment: Alignment.topCenter, children: [
              Container(
                  margin: const EdgeInsets.only(top: 40, left: 60, right: 60),
                  padding: const EdgeInsets.all(20.0),
                  decoration: Style().cardContainerDecoration(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 28),
                        Text('Member Login', style: TextStyle(fontSize: 25)),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _usernameController,
                          textAlign: TextAlign.center,
                          decoration:
                              Style().textFieldInputDecoration('username'),
                          onChanged: (value) => _username = value,
                        ),
                        const SizedBox(height: 12.0),
                        TextField(
                          controller: _passwordController,
                          textAlign: TextAlign.center,
                          decoration:
                              Style().textFieldInputDecoration('password'),
                          obscureText: true,
                          onChanged: (value) => _password = value,
                        ),
                        CheckboxListTile(
                            value: _signInCheck,
                            title: const Text('Remember password'),
                            onChanged: (bool? value) => setState(() {
                                  _signInCheck = value!;
                                })),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _signIn(_usernameController.text,
                                      _passwordController.text)
                                  .then((value) {
                                if (value == true) {
                                  _signInRemember(_signInCheck);
                                  _showGreeting(
                                      context, _usernameController.text);
                                } else {
                                  Navigator.pushNamed(context, '/register');
                                }
                              });
                            },
                            child: const Text('LOG IN / SIGN UP'),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                _signOut();
                              },
                              child: const Text('SIGN OUT')),
                        ),
                      ],
                    ),
                  )),
              Style().yellowIcon(context, Icons.person),
            ])));
  }

  _showGreeting(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hello, name you are signed in!'),
        content: Text(name),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Ok'))
        ],
      ),
      barrierDismissible: false,
    );
  }
}
