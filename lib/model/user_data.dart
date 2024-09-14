class UserData {
  int? id;
  int? type;
  String name;
  String contact;
  String image;
  String video;
  int? color;

  UserData({
    this.type,
    required this.name,
    required this.contact,
    required this.image,
    required this.video,
    id,
  });
}
