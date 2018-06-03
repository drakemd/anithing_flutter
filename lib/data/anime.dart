import 'package:anithing/data/genre.dart';

class Anime{
  String id;
  String title;
  String posterImage;
  String coverImage;
  String rating;
  String summary;
  List<String> genres;

  Anime(this.id, this.title, this.posterImage, this.coverImage, this.rating, this.summary, this.genres){
    if(title == null){
      throw new ArgumentError("Anime title cannot be null. "
          "Received: '$title'");
    }
    if(posterImage == null){
      throw new ArgumentError("Anime poster image cannot be null. "
          "Received: '$posterImage'");
    }
  }

  factory Anime.fromJson(Map<String, dynamic> jsonData, Map<String, Genre> genreList){

    List<String> genres = [];

    for(var value in jsonData['relationships']['genres']['data']){
      genres.add(genreList[value['id']].name);
    }

    return new Anime(
      jsonData['id'],
      jsonData['attributes']['canonicalTitle'],
      jsonData['attributes']['posterImage']['small'],
      jsonData['attributes']['coverImage'] != null ? jsonData['attributes']['coverImage']['original'] : "N/A",
      jsonData['attributes']['averageRating'],
      jsonData['attributes']['synopsis'],
      genres
    );
  }
}