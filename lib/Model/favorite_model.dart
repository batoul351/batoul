class FavoriteModel {
  final int foodId;

  FavoriteModel({required this.foodId});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(foodId: json['food_id']);
  }
}
