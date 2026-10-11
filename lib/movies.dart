import 'package:flutter/foundation.dart';

class Movie{
  final String title;
  final int year;
  final String genre;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
  });

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'year': year,
      'genre': genre,
      'rating': rating,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map){
    return Movie(
      title: map['title'],
      year: map['year'],
      genre: map['genre'],
      rating: (map['rating'] as num).toDouble(),
    );
  }
}

