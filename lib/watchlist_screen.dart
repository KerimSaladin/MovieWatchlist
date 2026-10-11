import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movies.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final titleController = TextEditingController();
  final yearController = TextEditingController();
  final genreController = TextEditingController();
  final ratingController = TextEditingController();

  List<Movie> _movies = [];
  String? _errorMessage;

  @override
  void initState(){
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTexts = prefs.getStringList('watchlist') ?? [];

    setState(() {
      _movies = savedTexts
        .map((text) => Movie.fromMap(jsonDecode(text))).toList();
    });
  }

  Future<void> _saveMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final texts = _movies.map((movie) => jsonEncode(movie.toMap())).toList();
    await prefs.setStringList('watchlist', texts);
  }

  void _addMovie(){
    final year = int.tryParse(yearController.text);
    final rating = double.tryParse(ratingController.text);

    if(titleController.text.isEmpty || year == null || rating == null){
      setState(() {
        _errorMessage = 'Enter a title, a year (number) and a rating (number)';
      });
      return;
    }

    setState(() {
      _movies.add(Movie(
        title: titleController.text, 
        year: year, 
        genre: genreController.text, 
        rating: rating));
    });

    titleController.clear();
    yearController.clear();
    genreController.clear();
    ratingController.clear();
  }

  void _removeMovie(int index){
    setState(() {
      _movies.removeAt(index);
    });
    _saveMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : const Text('My Watchlist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                    ),
                    
                    const SizedBox(width: 12,),
                    Expanded(
                      child: TextField(
                        controller: yearController,
                        decoration: const InputDecoration(labelText: 'Year'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: genreController,
                        decoration: const InputDecoration(labelText: 'Genre'),
                      ),
                    ),
                    
                    const SizedBox(width: 12,),
                    Expanded(
                      child: TextField(
                        controller: ratingController,
                        decoration: const InputDecoration(labelText: 'Rating'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: _addMovie,
                  child: const Text('Add Movie'),
                ),
                if(_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top:8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index){
                final movie = _movies[index];

                return ListTile(
                  title: Text(movie.title),
                  subtitle: Text('${movie.year} * ${movie.genre}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${movie.rating} stars'),
                      IconButton(
                        onPressed: (){ _removeMovie(index);},
                        icon: const Icon(Icons.delete)),
                    ],)
                );
              },
            )
          )
        ],
      ),
    );
  }
}