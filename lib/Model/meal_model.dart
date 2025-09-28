class MealModel {
  final int id;
  final String name;
  final String image;
  final int price;
  final String describe;
  final String priceReductions;
  final int discountRate;
  final int amounts;

  MealModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.describe,
    required this.priceReductions,
    required this.discountRate,
    required this.amounts,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      name: json['name'],
      image: "http://192.168.1.105:8000/" + (json['image'] ?? '').replaceAll("\\", ""),
      price: json['price'] ?? 0,
      describe: json['describe'] ?? '',
      priceReductions: json['price_reductions'] ?? 'no',
      discountRate: json['discount_rate'] ?? 0,
      amounts: json['amounts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'describe': describe,
      'price_reductions': priceReductions,
      'discount_rate': discountRate,
      'amounts': amounts,
    };
  }
}
