import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api/provider/artists_provider.dart';
// Asegúrate de importar el modelo Artist
import 'package:api/models/artist.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String genreSelected = 'rock'; 

  @override
  Widget build(BuildContext context) {
    final spotifyProvider = Provider.of<SpotifyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ARTISTAS DE ${genreSelected.toUpperCase()}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildGenreSelector(spotifyProvider),

          Expanded(
            child: spotifyProvider.emergentArtists.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Color(0xff1DB954)))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1, 
                    ),
                    itemCount: spotifyProvider.emergentArtists.length,
                    itemBuilder: (context, index) {
                      // Aquí el objeto ya es de tipo Artist
                      final artist = spotifyProvider.emergentArtists[index];
                      return _ArtistCard(artist: artist);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreSelector(SpotifyProvider provider) {
    final List<String> genres = ['rock', 'pop', 'indie', 'metal', 'jazz', 'electro', 'trap'];

    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = genreSelected == genre;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(genre.toUpperCase()),
              selected: isSelected,
              selectedColor: const Color(0xff1DB954), 
              onSelected: (bool selected) {
                if (selected) {
                  setState(() => genreSelected = genre);
                  provider.getEmergentArtists(genre);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _ArtistCard extends StatelessWidget {
  // CAMBIO CLAVE: Usamos el modelo Artist en lugar de dynamic
  final Artist artist; 
  
  const _ArtistCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          SizedBox.expand(
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(artist.fullProfilePath),
              fit: BoxFit.cover,
            ),
          ),

          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 12,
            left: 10,
            right: 10,
            child: Text(
              artist.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                shadows: [Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 2))]
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
