import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String name;
  final String image;
  final String synopsis;
  final String releaseDate;
  final String runTime;
  final String revenue;
  final String budget;

  Movie(
      {this.id,
      this.name,
      this.image,
      this.synopsis,
      this.releaseDate,
      this.runTime,
      this.revenue,
      this.budget});

  factory Movie.fromDocument(DocumentSnapshot doc) {
    return Movie(
      id: doc['id'],
      name: doc['name'],
      image: doc['image'],
      synopsis: doc['synopsis'],
      releaseDate: doc['releaseDate'],
      runTime: doc['runTime'],
      revenue: doc['revenue'],
      budget: doc['budget'],
    );
  }
}
