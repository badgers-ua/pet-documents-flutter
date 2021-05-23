// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_res_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerResDto _$OwnerResDtoFromJson(Map<String, dynamic> json) {
  return OwnerResDto(
    userId: json['userId'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String?,
    familyName: json['familyName'] as String?,
    givenName: json['givenName'] as String?,
  );
}

Map<String, dynamic> _$OwnerResDtoToJson(OwnerResDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
    };
