import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://api.tvmaze.com';

  // Fetch all movies (this can be used for the Home screen)
  static Future<List<dynamic>> fetchMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/search/shows?q=all')); // Default query is 'all'
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Search movies based on the query term (this will be used in the Search screen)
  static Future<List<dynamic>> searchMovies(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/search/shows?q=$searchTerm'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
