import '/models/product.dart';
import '/providers/user_data_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '/views/Screens/login_screen.dart';
import '/providers/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/views/Screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => UserDataProvider()),
        Provider(create: (_) => AuthenticationProvider(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationProvider>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(create: (_) => ProductListProvider())
      ],
      child: MaterialApp(
        title: 'Applore',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

//This a Authentication Wrapper for check watching the user login and signup state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firebaseUser = context.watch<User?>();
    if (_firebaseUser == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
