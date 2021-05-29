import 'package:dio/dio.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/user/actions.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import '../../constants.dart';
import '../index.dart';

Function loadUserThunk = () => (Store<RootState> store) async {
      store.dispatch(LoadUser());
      try {
        final response = await Dio().authenticatedDio().get('${Api.baseUrl}/profile');
        final UserResDto resDto = UserResDto.fromJson(response.data);

        store.dispatch(LoadUserSuccess(payload: resDto));
      } catch (e) {
        final String errorMsg = (e as DioError).response!.data["message"];

        print('Refresh Token Error: $errorMsg');

        store.dispatch(LoadUserFailure(payload: errorMsg));
      }
    };
