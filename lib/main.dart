import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:pocmem/models/user.dart';
import 'package:pocmem/screens/authenticate/register.dart';
import 'package:pocmem/screens/authenticate/sign_in.dart';
import 'package:pocmem/screens/home/add_memory.dart';
import 'package:pocmem/screens/home/plan_screen/add_plan.dart';
import 'package:pocmem/screens/wrapper.dart';
import 'package:pocmem/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: darkColor,
        ),
        home: const Wrapper(),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        initialRoute: '/',
        routes: {
          '/signIn': (context) => const SignIn(),
          '/register': (context) => const Register(),
          '/add_memory': (context) => const AddMemory(),
          '/add_plan': (context) => const AddPlan(),
        },
      ),
    );
  }
}
