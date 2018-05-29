class Anime{
  String title;
  String posterImage;

  Anime(this.title, this.posterImage){
    if(title == null){
      throw new ArgumentError("Anime title cannot be null. "
          "Received: '$title'");
    }
    if(title == null){
      throw new ArgumentError("Anime poster image cannot be null. "
          "Received: '$posterImage'");
    }
  }

  factory Anime.fromJson(Map<String, dynamic> json){
    return new Anime(
      json['attributes']['canonicalTitle'],
      json['attributes']['posterImage']['small']
    );
  }
}