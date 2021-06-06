import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/request/sign_out_req_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/sign-out/effects.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _SettingsScreenViewModel>(
      converter: (store) {
        return _SettingsScreenViewModel(
          isLoadingUser: store.state.user.isLoading,
          user: store.state.user.data,
          error: store.state.user.errorMessage.isNotEmpty,
          dispatchSignOut: () => store.dispatch(loadSignOutThunk(
            ctx: context,
            request: SignOutReqDto(deviceToken: store.state.deviceToken.data!.deviceToken),
          )),
        );
      },
      builder: (context, _SettingsScreenViewModel vm) {
        if (vm.isLoadingUser) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vm.error) {
          return Center(child: L10n.of(context).something_went_wrong);
        }

        final UserResDto user = vm.user!;

        return ListView(
          children: [
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: user.avatar,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: Icon(Icons.logout),
                onPressed: vm.dispatchSignOut,
              ),
            ),
          ],
        );
      },
    );
  }
}

// TODO: send you feedback to developer

class _SettingsScreenViewModel {
  final dispatchSignOut;
  final UserResDto? user;
  final bool isLoadingUser;
  final bool error;

  _SettingsScreenViewModel({
    required this.dispatchSignOut,
    required this.user,
    required this.isLoadingUser,
    required this.error,
  });
}
