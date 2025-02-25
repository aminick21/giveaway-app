class CategoryModel{
  final String name;
  final String image;
  CategoryModel({required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'image': this.image,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }
}


