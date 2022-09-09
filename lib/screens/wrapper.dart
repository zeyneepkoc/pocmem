import 'package:flutter/material.dart';
import 'package:pocmem/models/user.dart';
import 'package:pocmem/screens/authenticate/welcome.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel?>(context);

    if (_user == null) {
      return const Welcome();
    } else {
      return const Home();
    }
  }
}
