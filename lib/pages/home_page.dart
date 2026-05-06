import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api/provider/artists_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider para redibujar la lista cuando cambien los datos
    final spotifyProvider = Provider.of<SpotifyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artistas Emergentes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. BARRA DE BOTONES (GÉNEROS)
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _GenreButton(label: 'Rock', genre: 'rock'),
                _GenreButton(label: 'Pop', genre: 'pop'),
                _GenreButton(label: 'Indie', genre: 'indie'),
                _GenreButton(label: 'Metal', genre: 'metal'),
                _GenreButton(label: 'Jazz', genre: 'jazz'),
              ],
            ),
          ),

          // 2. LISTADO DE ARTISTAS
          Expanded(
            child: spotifyProvider.emergentArtists.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: spotifyProvider.emergentArtists.length,
                    itemBuilder: (context, index) {
                      final artist = spotifyProvider.emergentArtists[index];
                      return Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                artist.fullProfilePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(artist.name, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget pequeño para cada botón (para no repetir código)
class _GenreButton extends StatelessWidget {
  final String label;
  final String genre;

  const _GenreButton({required this.label, required this.genre});

  @override
  Widget build(BuildContext context) {
    // Usamos listen: false porque el botón no necesita redibujarse 
    // cuando la lista de artistas cambia, solo necesita disparar la acción.
    final spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () => spotifyProvider.getEmergentArtists(genre),
        child: Text(label),
      ),
    );
  }
}
