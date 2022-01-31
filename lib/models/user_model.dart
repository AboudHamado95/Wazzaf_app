class UserModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? city;
  bool? isAdmin;

  UserModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.city,
    
    this.isAdmin,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    city = json['city'];
    isAdmin = json['isAdmin'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'isAdmin': isAdmin
    };
  }
}
