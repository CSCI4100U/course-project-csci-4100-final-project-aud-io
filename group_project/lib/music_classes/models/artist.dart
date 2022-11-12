class Artist{
  String?  name;
  String? country;
  String? genre;
  Artist({this.name,this.country,this.genre});

  @override
  String toString(){
    return 'Artist: $name, from: $country, genre: $genre';
  }

}