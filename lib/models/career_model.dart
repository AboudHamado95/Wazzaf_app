class CareerModel {
  String? name;
  String? image;

  CareerModel({
    this.name,
    this.image,
  });
  CareerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}
