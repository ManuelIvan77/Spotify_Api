import 'package:api/pages/home_page.dart';
import 'package:api/provider/artists_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // Ahora sí llamamos a AppState para que cargue el Provider
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
   return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpotifyProvider(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja
      title: 'Artistas Emergentes',
      theme: ThemeData.dark(), // Estilo oscuro tipo Spotify
      // CAMBIO AQUÍ: Llamamos a tu clase HomePage
      home: const HomePage(), 
    );
  }
}
