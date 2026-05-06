import 'dart:convert';

class Artist {
  Artist({
    required this.name,
    required this.images,
  });

  String name;
  List<dynamic> images;

  // Este es el truco para que tu HomePage funcione
  String get fullProfilePath {
    if (images.isNotEmpty) {
      return images[0]['url']; // Toma la primera foto de Spotify
    }
    return 'https://imgur.com'; // Foto por defecto
  }

  factory Artist.fromMap(Map<String, dynamic> json) => Artist(
    name: json["name"],
    images: json["images"] ?? [],
  );
}
