class FavGenre {
  int? id;
  String? genre;

  FavGenre({this.id, this.genre});

  FavGenre.fromMap(Map map){
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
    return 'FavGenre[id: $id], genre: $genre';
  }
}