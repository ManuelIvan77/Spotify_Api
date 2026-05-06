import 'package:flutter/material.dart';
import 'package:api/provider/artists_provider.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider
    final spotifyProvider = Provider.of<SpotifyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artistas Emergentes'),
        centerTitle: true,
      ),
      body: spotifyProvider.emergentArtists.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Cargando...
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8, // Ajusta el tamaño de la tarjeta
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
                        child: FadeInImage(
                          placeholder: const AssetImage('assets/no-image.jpg'), // Asegúrate de tener esta imagen o usa network
                          image: NetworkImage(artist.fullProfilePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          artist.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
