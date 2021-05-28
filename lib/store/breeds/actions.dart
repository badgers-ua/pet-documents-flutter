import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';

import '../index.dart';

class LoadBreeds extends AppAction {}

class LoadBreedsSuccess extends AppAction {
  final Map<SPECIES, List<StaticResDto>> payload;

  LoadBreedsSuccess({required this.payload});
}

class LoadBreedsFailure extends AppAction {
  final String payload;

  LoadBreedsFailure({required this.payload});
}

class SetSelectedSpecies extends AppAction {
  final SPECIES payload;

  SetSelectedSpecies({required this.payload});
}

class ClearBreedsState extends AppAction {
}
