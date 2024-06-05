import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../complete_profile/complete_profile_screen.dart';
import 'package:http/http.dart' as http;

class RegisterData{
  String username = '';
  String password = '';
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegisterData registerData = RegisterData();
  String? email;
  String? password;
  // String? conform_password;
  bool remember = false;
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

  Future Register() async {
    var urlLogin = "http://10.10.30.82/yonsei/register.php";
    // print(RegisterData.username);
    final response = await http.post(
      Uri.parse(urlLogin),
      headers: {"Accept": "application/json"},
      body: {
        "username": user.text.toString(),
        "password": pass.text.toString(),
        // "username": 'founder',
        // "password": 'niner',
      },
    );
    // print(user.text.toString());
    final dataReg = json.decode(response.body);
    print(dataReg);
    if (dataReg.toString() == "Success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      print('error');
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
            controller: user,
            keyboardType: TextInputType.text,
            validator: (val) => val!.isEmpty ? "Username is required" : null,
            onSaved: (val) => registerData.username = val!,
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
            controller: pass,
            obscureText: true,
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.password],
            validator: (val) => val!.isEmpty ? "Password is required" : null,
            onSaved: (val) => registerData.password = val!,
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          //----------- Confirm Password ------------
          // const SizedBox(height: 20),
          // TextFormField(
          //   obscureText: true,
          //   onSaved: (newValue) => conform_password = newValue,
          //   onChanged: (value) {
          //     if (value.isNotEmpty) {
          //       removeError(error: kPassNullError);
          //     } else if (value.isNotEmpty && password == conform_password) {
          //       removeError(error: kMatchPassError);
          //     }
          //     conform_password = value;
          //   },
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       addError(error: kPassNullError);
          //       return "";
          //     } else if ((password != value)) {
          //       addError(error: kMatchPassError);
          //       return "";
          //     }
          //     return null;
          //   },
          //   decoration: const InputDecoration(
          //     labelText: "Confirm Password",
          //     hintText: "Re-enter your password",
          //     // If  you are using latest version of flutter then lable text and hint text shown like this
          //     // if you r using flutter less then 1.20.* then maybe this is not working properly
          //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          //   ),
          // ),
          // FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Register();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
