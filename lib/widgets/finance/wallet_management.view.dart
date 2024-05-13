import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/constants/app_ui_settings.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/wallet.vm.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/custom_outline_button.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletManagementView extends StatefulWidget {
  const WalletManagementView({
    this.viewmodel,
    Key? key,
  }) : super(key: key);

  final WalletViewModel? viewmodel;

  @override
  State<WalletManagementView> createState() => _WalletManagementViewState();
}

class _WalletManagementViewState extends State<WalletManagementView>
    with WidgetsBindingObserver {
  WalletViewModel? mViewmodel;
  @override
  void initState() {
    super.initState();

    mViewmodel = widget.viewmodel;
    mViewmodel ??= WalletViewModel(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      mViewmodel?.initialise();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mViewmodel?.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white;
    final textColor = Utils.textColorByColor(bgColor);
    //
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => mViewmodel!,
      disposeViewModel: widget.viewmodel == null,
      builder: (context, vm, child) {
        return StreamBuilder(
          stream: AuthServices.listenToAuthState(),
          builder: (ctx, snapshot) {
            //
            if (!snapshot.hasData) {
              return UiSpacer.emptySpace();
            }
            return vm.isBusy?Center(child: LoadingShimmer()):Visibility(
              visible: !vm.isBusy,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: VStack(
                      [
                        //topup button
                        CustomButton(
                          shapeRadius: 22,
                          onPressed: vm.showAmountEntry,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                              side: BorderSide(
                                color: AppColor.primaryColor,
                                width: 2,
                              )
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: HStack(
                              [
                                "Add Money"
                                    .tr()
                                    .text
                                    .color(AppColor.primaryColor).bold
                                    .make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            ).py8(),
                          ),
                        ).wFull(context),
                        Visibility(
                          visible: AppUISettings.allowWalletTransfer,
                          child: UiSpacer.verticalSpace(space: 5),
                        ),
                        //tranfer button
                        Visibility(
                          visible: AppUISettings.allowWalletTransfer,
                          child: CustomButton(
                            shapeRadius: 22,
                            color: AppColor.primaryColor,
                            onPressed: vm.showWalletTransferEntry,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: HStack(
                                [
                                  // Icon(
                                  //   FlutterIcons.upload_fea,
                                  // ).wh(24, 24),
                                  // UiSpacer.hSpace(5),
                                  //
                                  "SEND"
                                      .tr()
                                      .text
                                      .color(Colors.white)
                                      .make(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                                alignment: MainAxisAlignment.center,
                              ).py8(),
                            ),
                          ),
                        ).wFull(context),
                        Visibility(
                          visible: AppUISettings.allowWalletTransfer,
                          child: UiSpacer.verticalSpace(space: 5),
                        ),
                        //tranfer button
                        Visibility(
                          visible: AppUISettings.allowWalletTransfer,
                          child: CustomButton(
                            shapeRadius: 22,
                            color: AppColor.primaryColor,
                            onPressed: vm.showMyWalletAddress,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: HStack(
                                [
                                  // Icon(
                                  //   FlutterIcons.download_fea,
                                  // ).wh(24, 24),
                                  // UiSpacer.hSpace(5),
                                  // //
                                  vm.busy(vm.showMyWalletAddress)?BusyIndicator(color: Colors.white,):"RECEIVE"
                                      .tr()
                                      .text
                                      .color(Colors.white)
                                      .make(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                                alignment: MainAxisAlignment.center,
                              ).py8(),
                            ),
                          ),
                        ).wFull(context),
                      ],
                    ),
                  ).expand(flex: 4),
                  VStack(
                    [
                      //
                      "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet?.balance : 0.00}"
                          .currencyFormat()
                          .text
                          .color(AppColor.primaryColor)
                          .xl3
                          .semiBold
                          .makeCentered(),
                      UiSpacer.verticalSpace(space: 5),
                      "Wallet Balance".tr().text.color(textColor).makeCentered(),
                    ],
                  ).expand(flex: 5),
                ],
              ).box
              // .color(context.theme.colorScheme.background)
                  .withRounded(value: 22)
                  .make().glassMorphic(opacity: 0.1),
            );
          },
        );
      },
    );
  }
}
