import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/response/owner_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/widgets/pet_info_row_widget.dart';
import 'package:intl/intl.dart' as intl;

part 'pet_res_dto.g.dart';

enum GENDER {
  @JsonValue(0)
  MALE,
  @JsonValue(1)
  FEMALE,
}

enum SPECIES {
  @JsonValue(0)
  CAT,
  @JsonValue(1)
  DOG,
}

String getSpeciesLabel({
  required BuildContext ctx,
  required SPECIES species,
}) {
  if (species == SPECIES.CAT) {
    return L10n.of(ctx).species_enum_cat;
  }
  if (species == SPECIES.DOG) {
    return L10n.of(ctx).species_enum_dog;
  }
  return '';
}

String getGenderLabel({
  required BuildContext ctx,
  required GENDER gender,
}) {
  if (gender == GENDER.MALE) {
    return L10n.of(ctx).gender_enum_male;
  }
  if (gender == GENDER.FEMALE) {
    return L10n.of(ctx).gender_enum_female;
  }
  return '';
}

abstract class _PetCommon {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final SPECIES species;
  final GENDER? gender;
  final String? dateOfBirth;
  final String? colour;
  final String? notes;
  final int? weight;
  final String? avatar;

  _PetCommon({
    required this.id,
    required this.name,
    required this.species,
    this.gender,
    this.dateOfBirth,
    this.colour,
    this.notes,
    this.weight,
    this.avatar,
  });
}

@JsonSerializable()
class PetPreviewResDto extends _PetCommon {
  final String? breed;
  final List<String?> owners;

  PetPreviewResDto({
    this.breed,
    required this.owners,
    required id,
    required name,
    required SPECIES species,
    GENDER? gender,
    dateOfBirth,
    colour,
    notes,
    weight,
    avatar
  }) : super(
          id: id,
          name: name,
          species: species,
          gender: gender,
          dateOfBirth: dateOfBirth,
          colour: colour,
          notes: notes,
          weight: weight,
    avatar: avatar,
        );

  factory PetPreviewResDto.fromJson(Map<String, dynamic> json) => _$PetPreviewResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PetPreviewResDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PetResDto extends _PetCommon {
  final StaticResDto? breed;
  final List<OwnerResDto> owners;

  PetResDto({
    this.breed,
    required this.owners,
    required id,
    required name,
    required SPECIES species,
    GENDER? gender,
    dateOfBirth,
    colour,
    notes,
    weight,
    avatar,
  }) : super(
          id: id,
          name: name,
          species: species,
          gender: gender,
          dateOfBirth: dateOfBirth,
          colour: colour,
          notes: notes,
          weight: weight,
          avatar: avatar,
        );

  factory PetResDto.fromJson(Map<String, dynamic> json) => _$PetResDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PetResDtoToJson(this);

  List<PetInfoRowWidgetProps> toPetInfoRowWidgetPropsList({
    required BuildContext ctx,
    required UserResDto user,
  }) {
    return [
      PetInfoRowWidgetProps(
        label: L10n.of(ctx).pet_info_sliver_list_screen_species_text,
        value: getSpeciesLabel(ctx: ctx, species: this.species),
      ),
      if (this.breed != null)
        PetInfoRowWidgetProps(
          label: L10n.of(ctx).pet_info_sliver_list_screen_breed_text,
          value: this.breed!.name,
        ),
      if (this.gender != null)
        PetInfoRowWidgetProps(
          label: L10n.of(ctx).pet_info_sliver_list_screen_gender_text,
          value: getGenderLabel(ctx: ctx, gender: this.gender!),
        ),
      if (this.dateOfBirth != null)
        PetInfoRowWidgetProps(
          label: L10n.of(ctx).pet_info_sliver_list_screen_date_born_text,
          value:
              '(Age: ${(Duration(days: DateTime.now().difference(DateTime.parse(this.dateOfBirth!).toLocal()).inDays).inDays / 365).toStringAsPrecision(1)}) ${intl.DateFormat('dd/MM/yyyy').format(DateTime.parse(this.dateOfBirth!).toLocal()).toString()}',
        ),
      if (this.colour != null)
        PetInfoRowWidgetProps(
          label: L10n.of(ctx).pet_info_sliver_list_screen_color_text,
          value: this.colour!,
        ),
      if (this.weight != null)
        PetInfoRowWidgetProps(
          label: L10n.of(ctx).weight,
          value: '${this.weight} (kg)',
        ),
      PetInfoRowWidgetProps(
        label: L10n.of(ctx).pet_info_sliver_list_screen_owners_text,
        value: this.owners.asMap().entries.map(
          (entry) {
            int i = entry.key;
            OwnerResDto o = entry.value;
            return '${o.firstName} ${o.lastName} ${o.id == user.id ? '(${L10n.of(ctx).pet_info_sliver_list_screen_owners_me_text})' : ''}${i != this.owners.length - 1 ? ',' : ''}${i != this.owners.length - 1 ? '\n' : ''}';
          },
        ).join(' '),
      ),
      if (this.notes != null)
        PetInfoRowWidgetProps(
          label: L10n.of(ctx).pet_info_sliver_list_screen_description_text,
          value: this.notes!,
          isRow: false,
        ),
    ];
  }
}
