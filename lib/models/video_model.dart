class VideoModel {
  String? uId;
  String? videoLink;

  VideoModel({
    this.uId,
    this.videoLink,
  });
  VideoModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    videoLink = json['videoLink'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'videoLink': videoLink,
    };
  }
}
