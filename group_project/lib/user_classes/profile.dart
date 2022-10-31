class Profile{
  String? userID;
  String? userName;

  //private, not in constructor
  String? _password;
  String? phoneNum;
  String? country;
  String? city;

  Profile({this.userName,this.phoneNum,this.country,this.city});

  String? get password => _password;

  set password(password){
    _password = password;
  }
}