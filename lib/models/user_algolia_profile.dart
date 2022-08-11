class UserAlgoliaProfile {
  final String userName;
  final String userEmail;
  final String profilePicURL;

  UserAlgoliaProfile(this.userName, this.userEmail,this.profilePicURL);

  static UserAlgoliaProfile fromJson(Map<String, dynamic> json) {
    return UserAlgoliaProfile(json['userName'], json['userEmail'],json['profilePicURL']);
  }
}