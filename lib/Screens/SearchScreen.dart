import 'package:flutter/material.dart';
import 'package:fluttertest/API/api.dart';

class SearchScreen extends StatefulWidget {
  final String searchTerm;
  SearchScreen({required this.searchTerm});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<dynamic>> _searchResults;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchTerm;
    _searchResults = ApiService.searchMovies(widget.searchTerm); // Fetch movies based on search term
  }

  // Handle search input change
  void _onSearchChanged() {
    setState(() {
      _searchResults = ApiService.searchMovies(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Search Movies',
          style: TextStyle(color: Colors.white),
        ),
      ),
      resizeToAvoidBottomInset: true, // Allow space when keyboard appears
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search bar input field with light gray background
              TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.black),  // Text color is black
                decoration: InputDecoration(
                  hintText: 'Search Movies...',
                  hintStyle: TextStyle(color: Colors.black54),  // Hint text color
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[300],  // Set the background color of the search bar to light gray
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,  // Remove border
                  ),
                ),
                onChanged: (text) {
                  _onSearchChanged(); // Update search results when text changes
                },
              ),
              SizedBox(height: 10), // Space between search bar and results

              // FutureBuilder for fetching search results
              FutureBuilder<List<dynamic>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Failed to load movies', style: TextStyle(color: Colors.white)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
                  }

                  List<dynamic> movies = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,  // Ensures the ListView only takes the space it needs
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      var movie = movies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black, // Set background to black
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  movie['show']['image'] != null ? movie['show']['image']['medium'] : '',
                                  width: 100,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, color: Colors.white);
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie['show']['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      movie['show']['genres'] != null && movie['show']['genres'].isNotEmpty
                                          ? movie['show']['genres'].join(", ")
                                          : 'No Genres Available',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Language: ${movie['show']['language'] ?? 'N/A'}',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                              // Play button in the corner
                              IconButton(
                                icon: Icon(Icons.play_arrow, color: Colors.white),
                                onPressed: () {
                                  // Implement play functionality if needed
                                  print("Play clicked for ${movie['show']['name']}");
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
