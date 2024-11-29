import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic movie;

  DetailsScreen(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          movie['show']['name'],
          style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Thumbnail
              movie['show']['image'] != null
                  ? Container(
                      width: double.infinity, // Full width of the screen
                      height: 300, // Set the height for the thumbnail
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        color: Colors.black, // Background color
                        image: DecorationImage(
                          image: NetworkImage(movie['show']['image']['original'] ?? ''),
                          fit: BoxFit.contain, // Show full image without cropping
                        ),
                      ),
                    )
                  : Icon(Icons.error, color: Colors.white),
              SizedBox(height: 16),

              // Movie Title
              Text(
                movie['show']['name'],
                style: GoogleFonts.robotoCondensed(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),

              // Movie Genres
              Text(
                'Genres: ${movie['show']['genres'].join(', ')}',
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),

              // Watch in Languages Section
              Text(
                'Watch in: ${movie['show']['language'] ?? 'N/A'}',
                style: GoogleFonts.ptSerif(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 16),

              // Movie Summary/Description
              Text(
                'Description:',
                style: GoogleFonts.merriweather(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                movie['show']['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? // Remove HTML tags
                    'No description available.',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
