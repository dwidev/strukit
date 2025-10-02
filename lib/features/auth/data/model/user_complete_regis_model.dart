import 'dart:convert';

class DraftCompleteProfileModel {
  final String name;
  final String genderCode;
  final int age;
  final int distance;
  final String lookingForCode;
  final List<String> interestsCodes;
  final List<String> photosBytes;

  DraftCompleteProfileModel({
    required this.name,
    this.genderCode = '',
    this.age = 25,
    this.distance = 10,
    this.lookingForCode = '',
    this.interestsCodes = const [],
    this.photosBytes = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'genderCode': genderCode,
      'age': age,
      'distance': distance,
      'lookingForCode': lookingForCode,
      'interestsCodes': interestsCodes,
      'photosBytes': photosBytes,
    };
  }

  factory DraftCompleteProfileModel.fromMap(Map<String, dynamic> map) {
    return DraftCompleteProfileModel(
      name: map['name'] as String,
      genderCode: map['genderCode'] as String,
      age: map['age'] as int,
      distance: map['distance'] as int,
      lookingForCode: map['lookingForCode'] as String,
      interestsCodes: List<String>.from((map['interestsCodes'] ?? <String>[])),
      photosBytes: List<String>.from((map['photosBytes'] ?? <String>[])),
    );
  }

  String toJson() => json.encode(toMap());

  factory DraftCompleteProfileModel.fromJson(String source) =>
      DraftCompleteProfileModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
