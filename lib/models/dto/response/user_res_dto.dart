import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/models/dto/response/owner_res_dto.dart';

part 'user_res_dto.g.dart';

@JsonSerializable()
class UserResDto extends OwnerResDto {
  UserResDto({
    @JsonKey(name: '_id')
    id,
    email,
    firstName,
    lastName,
  }) : super(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );

  factory UserResDto.fromJson(Map<String, dynamic> json) =>
      _$UserResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserResDtoToJson(this);
}
