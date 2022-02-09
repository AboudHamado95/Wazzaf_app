class WorkerModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? city;
  String? literal;
  String? image;
  bool? isAdmin;

  WorkerModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.city,
    this.literal,
    this.image,
    this.isAdmin,
  });
  WorkerModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    city = json['city'];
    literal = json['literal'];
    image = json['image'];
    isAdmin = json['isAdmin'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'literal': literal,
      'image': image,
      'isAdmin': isAdmin
    };
  }
}
