class ProfileModel {
  final String city;
  final String street;
  final String phone;
  final String image;

  ProfileModel({
    required this.city,
    required this.street,
    required this.phone,
    required this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      phone: json['phone'].toString(),
      image: "http://192.168.1.102:8000/" + (json['image'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'phone': phone,
      'image': image,
    };
  }
}
