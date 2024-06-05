import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../login_success/login_success_screen.dart';
import 'package:http/http.dart' as http;

class LoginData{
  String username = '';
  String password = '';
}

enum LoginStatus{notSignIn, signIn}

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  LoginData loginData = LoginData();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  
  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
  
  void ceklogin() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }


  Future login() async {
    var urlLogin = "http://192.168.238.143/yonsei/login.php";
    print(loginData.username);
    final response = await http.post(
      Uri.parse(urlLogin),
      headers: {"Accept": "application/json"},
      body: {
        "username": loginData.username,
        "password": loginData.password,
        // "username": 'founder',
        // "password": 'niner',
      },
    );
    final datalogin = json.decode(response.body);
    print(datalogin);
    if (datalogin.toString() == "Success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()
        ),
      );
    } else {
      print('eror');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (val) => val!.isEmpty ? "Username is required" : null,
            onSaved: (val) => loginData.username = val!,
            decoration: const InputDecoration(
              labelText: "Username",
              hintText: "Enter Username",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            keyboardType: TextInputType.text,
            autofillHints: [AutofillHints.password],
            validator: (val) => val!.isEmpty ? "Password is required" : null,
            onSaved: (val) => loginData.password = val!,
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ceklogin();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
