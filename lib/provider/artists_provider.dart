import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// IMPORTANTE: Asegúrate de que esta ruta sea la correcta para tu archivo artist.dart
import 'package:api/models/artist.dart'; 

class SpotifyProvider extends ChangeNotifier {
  // 1. TUS CREDENCIALES ACTUALIZADAS (Plan Dúo)
  final String _clientId = '82992307cd074546ac69b22c3619ce08';
  final String _clientSecret = 'c94061db7d1d487f87ca50fe89144287';
  
  String _token = '';
  
  // 2. Lista de tipo Artist (ya no es dynamic)
  List<Artist> emergentArtists = [];

  SpotifyProvider() {
    _initialize();
  }

  _initialize() async {
    await getAccessToken();
    await getEmergentArtists('rock'); // Puedes cambiar el género aquí
  }

  Future<void> getAccessToken() async {
    final url = Uri.parse('https://accounts.spotify.com/api/token');
    final authString = base64Encode(utf8.encode('$_clientId:$_clientSecret'));

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic $authString',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['access_token'];
        print('✅ ¡Token obtenido con éxito!');
      } else {
        print('❌ Error al obtener token: ${response.body}');
      }
    } catch (e) {
      print('❌ Error de red al pedir token: $e');
    }
  }

      // Usamos el parámetro opcional posicional [ ] con el default 'rock'
Future<void> getEmergentArtists([ String genre = 'rock' ]) async {
  if (_token.isEmpty) return;

  // Limpiamos la lista para que el usuario vea el indicador de carga
  emergentArtists = [];
  notifyListeners();

  // La URL corregida y profesional
  final url = Uri.parse(
    'https://api.spotify.com/v1/search?q=genre:$genre&type=artist&limit=10'
  );

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> artistsList = data['artists']['items'];

      emergentArtists = artistsList.map((item) => Artist.fromMap(item)).toList();
      notifyListeners();
    }
  } catch (e) {
    print('❌ Error en getEmergentArtists: $e');
  }
}
}