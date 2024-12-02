import 'package:adocao_animais/models/animals_list.dart';
import 'package:adocao_animais/screens/animal_details_screen.dart';
import 'package:adocao_animais/theme/theme_provider.dart';
import 'package:adocao_animais/utils/app_routes.dart';
import 'package:adocao_animais/utils/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AnimalsList>(create: (_) => AnimalsList()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<Auth>(create: (_) => Auth())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'App de Adoção',
            theme: themeProvider.themeData,
            routes: {
              AppRoutes.home: (ctx) => const FeedScreen(),
              AppRoutes.details: (ctx) => const AnimalDetailsScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
