class RatingModel {
  String? uId;
  double? rate;

  RatingModel({
    this.uId,
    this.rate,
  });
  RatingModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    rate = json['rate'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'rate': rate,
    };
  }
}
