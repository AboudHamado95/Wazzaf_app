class PictureModel {
  String? uId;
  String? image;

  PictureModel({
    this.uId,
    this.image,
  });
  PictureModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    image = json['image'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'image': image,
    };
  }
}
