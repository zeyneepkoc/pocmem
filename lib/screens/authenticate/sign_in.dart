import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/services/auth.dart';
import 'package:pocmem/constants/colors/color.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
  }

  final _keySignIn = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String email = "";
  String password = "";
  bool passwordObscureText = true;

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
                  bottomRight: Radius.elliptical(
                      SizeConfig.defaultSize * 45, SizeConfig.defaultSize * 45),
                  bottomLeft: Radius.elliptical(
                      SizeConfig.defaultSize * 45, SizeConfig.defaultSize * 45),
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
              key: _keySignIn,
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
                      icon: Icons.mail_rounded,
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (value) {
                        if (value.toString().isEmpty) return "Enter an email";
                      },
                      obscureText: false,
                      controller: _controllerEmail,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp('[A-Z  ]'),
                        ),
                      ],
                      height: 20,
                      width: 125,
                    ),
                    TextFieldContainer(
                      hintText: "Password",
                      icon: Icons.lock,
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
                      controller: _controllerPassword,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp('[ ]'),
                        ),
                      ],
                      height: 20,
                      width: 125,
                    ),
                    /*SizedBox(
                      width: SizeConfig.defaultSize * 120,
                      child: InkWell(
                        child: Text(
                          "Şifreni mi unuttun?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.defaultSize * 5.3,
                          ),
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: SizeConfig.defaultSize * 15,
                    ),
                    RoundedButton(
                      text: "Log In",
                      press: () async {
                        if (_keySignIn.currentState!.validate()) {
                          _authService.signInWithEmailAndPassword(
                              email, password, context);
                        }
                      },
                      color: darkColor,
                      textColor: Colors.white,
                    ),
                    RoundedButton(
                      text: "Sign In",
                      press: () {
                        Navigator.pushNamed(context, "/register");
                        setState(() {
                          _controllerEmail.clear();
                          _controllerPassword.clear();
                        });
                      },
                      color: lightColor,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  Function() press;
  final Color? color;
  final Color? textColor;
  RoundedButton(
      {Key? key,
      required this.text,
      required this.press,
      required this.color,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.defaultSize * 5),
      width: SizeConfig.defaultSize * 110,
      height: SizeConfig.defaultSize * 20,
      child: TextButton(
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: SizeConfig.defaultSize * 9,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(27),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? Function(String?) validator;
  final Widget? suffixIcon;
  TextEditingController? controller = TextEditingController();
  bool obscureText;
  List<TextInputFormatter> inputFormatters;
  int height, width;
  TextFieldContainer({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.suffixIcon,
    required this.obscureText,
    required this.inputFormatters,
    required this.height,
    required this.width,
    required this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.defaultSize * 5),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        cursorColor: darkColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: darkColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
        inputFormatters: inputFormatters,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultSize * 7,
      ),
      width: SizeConfig.defaultSize * width,
      height: SizeConfig.defaultSize * height,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 20),
      ),
    );
  }
}
