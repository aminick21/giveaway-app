class LocationModel{
  final String addressLine;
  final String city;
  final String state;
  final int pinCode;
  final double lat;
  final double long;

  LocationModel({required this.city,required this.state,required  this.lat,required  this.long, required this.addressLine, required this.pinCode});

  Map<String, dynamic> toMap() {
    return {
      'address':this.addressLine,
      'city': this.city,
      'state': this.state,
      'pinCode':this.pinCode,
      'lat': this.lat,
      'long': this.long,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      addressLine :map['addressLine'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      pinCode:map['pinCode'] as int,
      lat: map['lat'] as double,
      long:map['long'] as double,
    );
  }



}
