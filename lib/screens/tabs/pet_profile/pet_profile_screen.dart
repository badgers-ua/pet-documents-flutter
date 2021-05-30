import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/app_state.dart';
import 'package:pdoc/models/dto/request/remove_owner_req_dto.dart';
import 'package:pdoc/models/dto/response/pet_res_dto.dart';
import 'package:pdoc/models/dto/response/user_res_dto.dart';
import 'package:pdoc/screens/add_edit_pet_screen.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_chat_sliver_list_screen.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_events_sliver_list_screen.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_info_sliver_list_screen.dart';
import 'package:pdoc/screens/tabs/pet_profile/pet_profile_tab_screen.dart';
import 'package:pdoc/store/index.dart';
import 'package:pdoc/store/pet/actions.dart';
import 'package:pdoc/store/pet/effects.dart';
import 'package:pdoc/store/remove-owner/effects.dart';
import 'package:pdoc/widgets/add_owner_dialog_widget.dart';
import 'package:pdoc/widgets/confirmation_dialog_widget.dart';
import 'package:pdoc/widgets/modal_select_widget.dart';

class PetProfileScreenProps {
  final String petId;

  PetProfileScreenProps({
    required this.petId,
  });
}

class PetProfileScreen extends StatefulWidget {
  static const routeName = '/pet-profile';

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  int _currentTabIndex = 0;

  SpeedDial petActionButtons({
    required BuildContext ctx,
    required _PetProfileScreenViewModel vm,
  }) {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.menu,
      backgroundColor: Theme.of(ctx).accentColor,
      foregroundColor: Theme.of(context).bottomAppBarColor,
      activeIcon: Icons.close,
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0,
      children: [
        SpeedDialChild(
          child: Icon(Icons.edit),
          label: L10n.of(ctx).pet_profile_screen_edit_pet_fab_button_text,
          onTap: () {
            Navigator.of(ctx).pushNamed(AddEditPetScreen.routeName);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add),
          label: L10n.of(ctx).add_owner,
          onTap: () {
            _showAddOwnerDialog(ctx: ctx, pet: vm.pet!);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.person_remove),
          label: L10n.of(ctx).remove_owner,
          onTap: () {
            _showRemoveOwnerModalSelect(ctx: ctx, vm: vm);
          },
        ),
        // SpeedDialChild(
        //   child: Icon(Icons.keyboard_voice),
        //   backgroundColor: Colors.green,
        //   label: 'Delete pet',
        //   labelStyle: TextStyle(fontSize: 18.0),
        //   onTap: () => print('THIRD CHILD'),
        //   onLongPress: () => print('THIRD CHILD LONG PRESS'),
        // ),
      ],
    );
  }

  Future<void> _showAddOwnerDialog({
    required BuildContext ctx,
    required PetResDto pet,
  }) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddOwnerDialogWidget(
          pet: pet,
        );
      },
    );
  }

  void _showRemoveOwnerModalSelect({
    required BuildContext ctx,
    required _PetProfileScreenViewModel vm,
  }) async {
    final widget = ModalSelectWidget(
      title: L10n.of(ctx).remove_owner,
      options: vm.removeOwnerOptions,
    );

    if (Platform.isIOS) {
      final ModalSelectOption? modalSelectOption =
          await showCupertinoModalBottomSheet(
        context: ctx,
        builder: (_) => widget,
      );

      if (modalSelectOption == null) {
        return;
      }

      _showRemoveOwnerConfirmationDialog(
        ctx: ctx,
        vm: vm,
        selectedOwner: modalSelectOption,
      );

      return;
    }

    final ModalSelectOption? modalSelectOption =
        await showMaterialModalBottomSheet(
      context: ctx,
      builder: (_) => widget,
    );

    if (modalSelectOption == null) {
      return;
    }

    _showRemoveOwnerConfirmationDialog(
      ctx: ctx,
      vm: vm,
      selectedOwner: modalSelectOption,
    );
  }

  Future<void> _showRemoveOwnerConfirmationDialog({
    required BuildContext ctx,
    required _PetProfileScreenViewModel vm,
    required ModalSelectOption selectedOwner,
  }) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmationDialogWidget(
          title: L10n.of(context).remove_owner,
          content: L10n.of(context).remove_owner_warning(selectedOwner.label, vm.pet!.name),
          enabled: true,
          onSubmit: () {
            vm.dispatchLoadRemoveOwnerThunk(
              ctx: ctx,
              petId: vm.pet!.id,
              ownerId: selectedOwner.value,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final PetProfileScreenProps props =
        ModalRoute.of(context)!.settings.arguments as PetProfileScreenProps;

    return StoreConnector<RootState, _PetProfileScreenViewModel>(
      onDispose: (store) {
        store.dispatch(ClearPetState());
      },
      onInit: (store) {
        store.dispatch(loadPetThunk(ctx: context, petId: props.petId));
      },
      converter: (store) {
        final AppState<PetResDto> petState = store.state.pet;
        final AppState<UserResDto> userState = store.state.user;
        return _PetProfileScreenViewModel(
          removeOwnerOptions: petState.data == null
              ? []
              : petState.data!.owners
                  .map(
                    (e) => ModalSelectOption(
                        label: '${e.firstName} ${e.lastName}',
                        value: e.id),
                  )
                  .toList(),
          pet: petState.data,
          isLoadingPet: petState.isLoading,
          user: userState.data,
          isLoadingUser: userState.isLoading,
          dispatchLoadRemoveOwnerThunk: ({
            required BuildContext ctx,
            required String ownerId,
            required String petId,
          }) =>
              store.dispatch(
            loadRemoveOwnerThunk(
              ctx: ctx,
              request: RemoveOwnerReqDto(ownerId: ownerId),
              petId: petId,
            ),
          ),
        );
      },
      builder: (context, _PetProfileScreenViewModel vm) {
        if (vm.isLoadingPet || vm.isLoadingUser) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Builder(builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context)!;
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                setState(() {
                  _currentTabIndex = tabController.index;
                });
              }
            });
            return Scaffold(
              body: Scrollbar(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverAppBar(
                          title: Text(vm.pet!.name),
                          pinned: true,
                          snap: true,
                          floating: true,
                          expandedHeight: 200,
                          forceElevated: innerBoxIsScrolled,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(color: Colors.black),
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.7),
                                        BlendMode.dstATop,
                                      ),
                                    ),
                                  ),
                                ),
                                imageUrl:
                                    'https://www.thesprucepets.com/thmb/DvxumVXUoBY2q0k3VVnOFRRz-dw=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/facts-about-black-cats-554102-hero-7281a22d75584d448290c359780c2ead.jpg',
                              ),
                            ),
                          ),
                          bottom: TabBar(
                            tabs: [
                              Tab(
                                  text: L10n.of(context)
                                      .pet_profile_screen_info_tab_text),
                              // TODO: [FEATURE] Chat
                              // Tab(
                              //     text: L10n.of(context)
                              //         .pet_profile_screen_chat_tab_text),
                              Tab(
                                  text: L10n.of(context)
                                      .pet_profile_screen_events_tab_text),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      PetProfileTabScreen(
                        child: PetInfoSliverListScreen(
                          // TODO: pet == null when token expired?
                          petRowList: vm.pet!.toPetInfoRowWidgetPropsList(
                            ctx: context,
                            user: vm.user!,
                          ),
                        ),
                      ),
                      // TODO: [FEATURE] Chat
                      // PetProfileTabScreen(child: PetChatSliverListScreen()),
                      PetProfileTabScreen(child: PetEventsSLiverListScreen()),
                    ],
                  ),
                ),
              ),
              floatingActionButton: _currentTabIndex == 0
                  ? petActionButtons(ctx: context, vm: vm)
                  : null,
            );
          }),
        );
      },
    );
  }
}

class _PetProfileScreenViewModel {
  final bool isLoadingPet;
  final bool isLoadingUser;
  final PetResDto? pet;
  final UserResDto? user;
  final List<ModalSelectOption> removeOwnerOptions;
  final dispatchLoadRemoveOwnerThunk;

  _PetProfileScreenViewModel({
    required this.isLoadingPet,
    required this.isLoadingUser,
    required this.pet,
    required this.user,
    required this.removeOwnerOptions,
    required this.dispatchLoadRemoveOwnerThunk,
  });
}
