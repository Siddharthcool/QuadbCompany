import 'package:flutter/material.dart';
import 'package:fluttertest/API/api.dart';
import 'package:fluttertest/Screens/DetailsScreen.dart';
import 'package:fluttertest/Screens/SearchScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _moviesFuture;
  int _selectedIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _moviesFuture = ApiService.fetchMovies();

    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen(searchTerm: '')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrollOffset = _scrollController.hasClients ? _scrollController.offset : 0;
    double appBarOpacity = (scrollOffset / 200).clamp(0.0, 0.5);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade300.withOpacity(1 - appBarOpacity),
              Colors.black.withOpacity(1 - appBarOpacity),
            ],
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black.withOpacity(appBarOpacity),
              elevation: 0,
              expandedHeight: 80,
              floating: false,
              pinned: true,
              title: Image.asset(
                'lib/images/netflix.png',
                height: 50,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen(searchTerm: '')),
                    );
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  FutureBuilder<List<dynamic>>(
                    future: _moviesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Failed to load movies', style: TextStyle(color: Colors.white)),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No movies found', style: TextStyle(color: Colors.white)),
                        );
                      }

                      List<dynamic> movies = snapshot.data!;
                      List<dynamic> moviesWithImages = movies.where((movie) => movie['show']['image'] != null).toList();

                      return Column(
                        children: [
                          // Featured Movie Section
                          _buildFeaturedMovie(context, moviesWithImages),
                          // Movies List (Starting from 2nd movie onwards)
                          _buildMoviesList(context, moviesWithImages.sublist(1)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onNavItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMovie(BuildContext context, List<dynamic> movies) {
    if (movies.isEmpty) return SizedBox.shrink();

    var featuredMovie = movies[0];
    return Container(
      height: 500, // Increased size for featured movie box
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(featuredMovie['show']['image']['original']),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Movie Title with Poppins font
          Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: Text(
              featuredMovie['show']['name'],
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 5,
                    color: Colors.black54,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Buttons - Moved upwards
          Positioned(
            bottom: 70,  // Adjusted value here
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add play functionality here
                  },
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white),
                      Text('Play', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsScreen(featuredMovie)),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white),
                      Text('Info', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList(BuildContext context, List<dynamic> movies) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        var movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen(movie)),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie['show']['image']['medium'],
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
                      // Movie title with Poppins font
                      Text(
                        movie['show']['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        movie['show']['genres']?.join(", ") ?? 'No Genres Available',
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
              ],
            ),
          ),
        );
      },
    );
  }
}
