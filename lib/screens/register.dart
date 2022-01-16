//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenth_week_app/styles/style.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _username = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();

  Future<void> _register(String username, String password) async {
    var _regData = await SharedPreferences.getInstance();
    _regData.setString('username', username);
    _regData.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
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
                        Text('Register', style: TextStyle(fontSize: 25)),
                        const SizedBox(height: 32),
                        TextFormField(
                            decoration: Style()
                                .textFieldInputDecoration('username (any)'),
                            textAlign: TextAlign.center,
                            onChanged: (value) => _username = value,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter your username';
                            }),
                        const SizedBox(height: 12.0),
                        TextFormField(
                            decoration: Style()
                                .textFieldInputDecoration('password (any)'),
                            textAlign: TextAlign.center,
                            obscureText: true,
                            onChanged: (value) => _password = value,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter your password';
                            }),
                        const SizedBox(height: 12.0),
                        TextFormField(
                            decoration: Style().textFieldInputDecoration(
                                'Confirm your password'),
                            textAlign: TextAlign.center,
                            obscureText: true,
                            validator: (value) {
                              if (value != _password)
                                return 'Please repeat your password';
                            }),
                        const SizedBox(height: 12.0),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _register(_username, _password);
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Register'))),
                      ],
                    ))),
                Style().yellowIcon(context, Icons.edit),
              ]))),
    );
  }
}
