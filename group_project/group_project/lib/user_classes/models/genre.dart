class Genre {
  int? id;
  String? genre;

  Genre({this.id, this.genre});

  Genre.fromMap(Map map){
    this.id = map['id'];
    this.genre = map['genre'];
  }

  Map<String,Object?> toMap(){
    return {
      'id': this.id,
      'genre': this.genre
    };
  }

  String toString(){
    return 'Genre[id: $id], genre: $genre';
  }
}