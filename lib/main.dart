import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:primeform/models/user.dart' as app;
import 'package:primeform/screens/wrapper.dart';
import 'package:primeform/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PrimeFormApp());
}

class PrimeFormApp extends StatelessWidget {
  const PrimeFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<app.User?>.value(
      // En provider recientes, initialData es requerido
      initialData: null,
      value: AuthService().user, // Stream<app.User?>
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PrimeForm',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          fontFamily: 'Segoe UI',
          scaffoldBackgroundColor: const Color(0xFF0B0E14),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1DA1FF),
            surface: Color(0xFF0F1420),
          ),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
