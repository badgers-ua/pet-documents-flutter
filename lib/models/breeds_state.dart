import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/static_res_dto.dart';

import 'app_state.dart';

class BreedsState extends AppState {
  final SPECIES? selectedSpecies;

  BreedsState({
    this.selectedSpecies,
    bool isLoading = false,
    String errorMessage = '',
    Map<SPECIES, List<StaticResDto>>? data,
  }) : super(data: data, errorMessage: errorMessage, isLoading: isLoading);
}
