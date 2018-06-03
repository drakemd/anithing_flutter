class Genre{
  String id;
  String name;

  Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json){
    return new Genre(
        json['id'],
        json['attributes']['name']
    );
  }
}