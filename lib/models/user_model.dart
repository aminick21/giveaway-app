class UserModel {

  final String id;
  final String email;
  final String name;
  final String mobileNumber;
  final String imageUrl;
  final double rating;
  final int peopleRated;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.mobileNumber,
    required this.imageUrl,
    required this.rating,
    required this.peopleRated,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'name': this.name,
      'mobileNumber': this.mobileNumber,
      'imageUrl': this.imageUrl,
      'rating': this.rating,
      'peopleRated': this.peopleRated,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      mobileNumber: map['mobileNumber'] as String,
      imageUrl: map['imageUrl'] as String,
      rating: map['rating'] as double,
      peopleRated: map['peopleRated'] as int,
      createdAt: map['createdAt'] as DateTime,
      updatedAt: map['updatedAt'] as DateTime,
    );
  }

}
