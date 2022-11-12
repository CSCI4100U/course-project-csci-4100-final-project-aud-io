class Artist{
  String?  name;
  String? country;
  String? genre;
  Artist({this.name,this.country,this.genre});


  //The typing here is mandatory! If you do not
  //specify Map<String,Object?>, everything breaks


  String toString(){
    return 'Artist: $name, from: $country, genre: $genre';
  }

}