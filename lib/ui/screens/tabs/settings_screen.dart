import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/dto/request/sign_out_req_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/sign-out/effects.dart';
import 'package:pdoc/ui/screens/tabs/about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/tab-settings';

  _navigateToAboutAppScreen({required BuildContext ctx}) {
    Navigator.of(ctx).pushNamed(AboutAppScreen.routeName);
  }

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
      ignoreChange: (state) => state.user.data == null,
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

        final List<Widget> _listItems = [
          ListTile(
            leading: CachedNetworkImage(
              imageUrl: user.avatar,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
              width: 40,
              height: 40,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
            trailing: IconButton(
              icon: Icon(Icons.logout),
              onPressed: vm.dispatchSignOut,
            ),
          ),
          ListTile(
            onTap: () {
              _navigateToAboutAppScreen(ctx: context);
            },
            leading: Icon(Icons.info, size: 42),
            title: Text(L10n.of(context).about_app),
            // subtitle: Text(user.email),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ];

        return ListView.builder(
          itemCount: _listItems.length,
          itemBuilder: (_, i) {
            return _listItems[i];
          },
        );
      },
    );
  }
}

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
