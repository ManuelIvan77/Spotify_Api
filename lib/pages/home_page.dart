import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api/provider/artists_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Variable local para guardar el género seleccionado
  String genreSelected = 'rock'; 

  @override
  Widget build(BuildContext context) {
    final spotifyProvider = Provider.of<SpotifyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artistas Emergentes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 2. Fila de botones
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildGenreButton('Rock', 'rock', spotifyProvider),
                _buildGenreButton('Pop', 'pop', spotifyProvider),
                _buildGenreButton('Indie', 'indie', spotifyProvider),
                _buildGenreButton('Metal', 'metal', spotifyProvider),
                _buildGenreButton('Jazz', 'jazz', spotifyProvider),
              ],
            ),
          ),

          // 3. Listado de artistas
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
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                              child: Text(artist.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  // 4. Método para construir los botones dinámicamente
  Widget _buildGenreButton(String label, String genre, SpotifyProvider provider) {
    // Comprobamos si este botón es el seleccionado
    final isSelected = (genreSelected == genre);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Si está seleccionado es verde Spotify, si no, gris oscuro
          backgroundColor: isSelected ? const Color(0xff1DB954) : Colors.grey[800],
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          // Actualizamos el estado local para cambiar el color
          setState(() {
            genreSelected = genre;
          });
          // Llamamos al provider para cargar los datos
          provider.getEmergentArtists(genre);
        },
        child: Text(label),
      ),
    );
  }
}
