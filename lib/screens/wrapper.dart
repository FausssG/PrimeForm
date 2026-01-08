import 'package:flutter/material.dart';
import 'package:primeform/screens/authenticate/sign-in.dart';
import 'package:primeform/screens/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:primeform/models/user.dart' as app;

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final app.User? user = Provider.of<app.User?>(context);

    if (user == null) {
      return const SignIn(); // ajustá al nombre real de tu screen de login
    }
    return Dashboard();
  }
}
