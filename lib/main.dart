import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screens
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/wrapper_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/login/login_screen.dart';

//Routes
import 'routes/app_routes.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Firebase auth+ fireStore",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
      
        routes: {
          AppRoutes.homeScreen: (context) => const HomeScreen(),
          AppRoutes.startLogin: (context) => const LoginScreen(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}
