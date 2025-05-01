import 'package:firebase_auth_and_firestore/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';


//Screens
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/wrapper_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/login/login_screen.dart';

//Routes
import 'presentation/screens/register_peets/register_peet_screen.dart';
import 'presentation/screens/register_person/register_person_screen.dart';
import 'routes/app_routes.dart';

// Providers
import 'presentation/providers/person_provider.dart';
import 'presentation/providers/mascota_provider.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/mascota_services.dart';
import 'services/person_services.dart';

// navigatorKey global para el AuthProvider
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthServices())),
        ChangeNotifierProvider(
          create: (context) => MascotaProvider(MascotaService()),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonaProvider(PersonaServices()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: "Firebase auth+ fireStore",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),

        // 🔹 Configuración de localización
        supportedLocales: [
          Locale('es', 'ES'), // Español
          Locale('en', 'US'), // Inglés (Opcional)
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // // Para soporte en iOS
        ],
        routes: {
          AppRoutes.homeScreen: (context) => const HomeScreen(),
          AppRoutes.startLogin: (context) => const LoginScreen(),
          AppRoutes.registerPerson: (context) => RegistroPersonaScreen(),
          AppRoutes.registerPeet: (context) => RegistroMascotaScreen(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}
