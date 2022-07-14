import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  final String? name;
  final String? image;
  //added more information from the API
  final String? status;
  final String? species;
  final String? gender;

  Character(this.name, this.image, this.status, this.species, this.gender);

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
