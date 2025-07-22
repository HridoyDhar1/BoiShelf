class SellerModel {
  final String name;
  final String avatarPath;

  SellerModel({required this.name, required this.avatarPath});
  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {

      'name': name,

      'image_url': avatarPath,

    };
  }

  // Convert Firestore map to model
  factory SellerModel.fromMap(Map<String, dynamic> map) {
    return SellerModel(name:map['name'] ?? '', avatarPath: map['image_url'] ?? '');
  }
}
