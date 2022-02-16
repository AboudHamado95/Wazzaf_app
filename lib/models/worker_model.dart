class WorkerModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? city;
  String? literal;
  String? image;
  double? latitude;
  double? longitude;
  bool? isAdmin;

  WorkerModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.city,
    this.literal,
    this.image,
    this.latitude,
    this.longitude,
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
    latitude = json['latitude'];
    longitude = json['longitude'];
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
      'isAdmin': isAdmin,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
