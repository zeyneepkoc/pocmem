import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocmem/screens/authenticate/sign_in.dart';
import '../../config/size_config.dart';
import '../../constants/colors/color.dart';
import '../../services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _keyRegister = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  String email = "";
  String password = "";
  String name = "";
  String surname = "";
  String passwordCheck = "";
  bool passwordObscureText = true;
  bool passwordCheckObscureText = true;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: SizeConfig.defaultSize * 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(SizeConfig.defaultSize * 45,
                        SizeConfig.defaultSize * 45),
                    bottomLeft: Radius.elliptical(SizeConfig.defaultSize * 45,
                        SizeConfig.defaultSize * 45),
                  ),
                  color: backgroundColor,
                ),
                child: Center(
                  child: Image.asset(
                    "images/notebook_icon.jpg",
                    height: SizeConfig.defaultSize * 75,
                    width: SizeConfig.defaultSize * 75,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 5,
              ),
              SizedBox(
                child: Text(
                  "PocMem",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: darkColor,
                      fontSize: SizeConfig.defaultSize * 10,
                      fontWeight: FontWeight.bold),
                ),
                width: SizeConfig.defaultSize * 120,
              ),
              Form(
                key: _keyRegister,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: SizeConfig.defaultSize * 7,
                      ),
                      TextFieldContainer(
                        hintText: "Your email",
                        icon: Icons.email_outlined,
                        onChanged: (String value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) return "Enter an email";
                        },
                        obscureText: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp('[A-Z  ]'),
                          ),
                        ],
                        height: 20,
                        width: 125,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFieldContainer(
                            hintText: "Name",
                            icon: Icons.account_circle_outlined,
                            onChanged: (String value) {
                              setState(() {
                                name = value;
                              });
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Enter a name";
                              }
                            },
                            obscureText: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[ ]'),
                              ),
                            ],
                            height: 20,
                            width: 62,
                          ),
                          SizedBox(
                            width: SizeConfig.defaultSize * 2,
                          ),
                          TextFieldContainer(
                            hintText: "Surname",
                            icon: Icons.account_circle_outlined,
                            onChanged: (String value) {
                              setState(() {
                                surname = value;
                              });
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Enter a surname";
                              }
                            },
                            obscureText: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp('[ ]'),
                              ),
                            ],
                            height: 20,
                            width: 62,
                          ),
                        ],
                      ),
                      TextFieldContainer(
                        hintText: "Password",
                        icon: Icons.lock_outline,
                        onChanged: (String value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) return "Enter a password";
                        },
                        suffixIcon: InkWell(
                          child: const Icon(
                            Icons.visibility,
                            color: darkColor,
                          ),
                          onTap: () {
                            setState(() {
                              passwordObscureText = !passwordObscureText;
                            });
                          },
                        ),
                        obscureText: passwordObscureText,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp('[ ]'),
                          ),
                        ],
                        height: 20,
                        width: 125,
                      ),
                      TextFieldContainer(
                        hintText: "Password",
                        icon: Icons.lock_outline,
                        onChanged: (String value) {
                          setState(() {
                            passwordCheck = value;
                          });
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) return "Enter a password";
                          if (password != passwordCheck) {
                            return "Does not match the entered password";
                          }
                        },
                        suffixIcon: InkWell(
                          child: const Icon(
                            Icons.visibility,
                            color: darkColor,
                          ),
                          onTap: () {
                            setState(() {
                              passwordCheckObscureText =
                                  !passwordCheckObscureText;
                            });
                          },
                        ),
                        obscureText: passwordCheckObscureText,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp('[ ]'),
                          ),
                        ],
                        height: 20,
                        width: 125,
                      ),
                      RoundedButton(
                        text: "Sign In",
                        press: () async {
                          if (_keyRegister.currentState!.validate()) {
                            _authService.registerWithEmailAndPassword(
                                ({
                                  "email": email.toString(),
                                  "password": password.toString(),
                                  "name": name.toString(),
                                  "surname": surname.toString(),
                                }),
                                context);
                          }
                        },
                        color: darkColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
