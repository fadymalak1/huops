import 'package:cached_network_image/cached_network_image.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/edit_profile.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "Edit Profile".tr(),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //
                  Stack(
                    children: [
                      //
                      model.currentUser == null
                          ? BusyIndicator()
                          : model.newPhoto == null
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white, //This will make container round
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CachedNetworkImage(
                                          imageUrl: model.currentUser?.photo ?? "",
                                          progressIndicatorBuilder:
                                              (context, imageUrl, progress) {
                                            return BusyIndicator();
                                          },
                                          errorWidget: (context, imageUrl, progress) {
                                            return Image.asset(
                                              AppImages.user,
                                            );
                                          },
                                        )
                                            .wh(100, 100)
                                            .box
                                            .roundedFull
                                            .clip(Clip.antiAlias)
                                            .make(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white, //This will make container round
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.file(
                                    model.newPhoto!,
                                    fit: BoxFit.cover,
                                  )
                                      .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                      .box
                                      .rounded
                                      .clip(Clip.antiAlias)
                                      .make(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Icon(
                          FlutterIcons.camera_ant,
                          size: 16,
                        )
                            .p8()
                            .box
                            .color(context.theme.colorScheme.background)
                            .roundedFull
                            .shadow
                            .make()
                            .onInkTap(model.changePhoto),
                      ),
                    ],
                  ).box.makeCentered(),

                  //form
                  Form(
                    key: model.formKey,
                    child: VStack(
                      [
                        //
                        "Name".tr().text.bold.color(Colors.white).lg.make(),
                        CustomTextFormField(
                          hintText: "Name".tr(),
                          textEditingController: model.nameTEC,
                          validator: FormValidator.validateName,
                        ).glassMorphic().py12(),
                        //
                        "Email".tr().text.bold.color(Colors.white).lg.make(),
                        CustomTextFormField(
                          hintText: "Email".tr(),
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: model.emailTEC,
                          validator: FormValidator.validateEmail,
                        ).glassMorphic().py12(),
                        //
                        "Phone".tr().text.bold.color(Colors.white).lg.make(),
                        CustomTextFormField(
                          prefixIcon: HStack(
                            [
                              //icon/flag
                              Flag.fromString(
                                model.selectedCountry?.countryCode ?? "us",
                                width: 20,
                                height: 20,
                              ),
                              UiSpacer.horizontalSpace(space: 5),
                              //text
                              ("+" + (model.selectedCountry?.phoneCode ?? "1"))
                                  .text
                                  .make(),
                            ],
                          ).px8().onInkTap(model.showCountryDialPicker),
                          hintText: "Phone",
                          keyboardType: TextInputType.phone,
                          textEditingController: model.phoneTEC,
                          validator: FormValidator.validatePhone,
                        ).glassMorphic().py12(),

                        //
                        CustomButton(
                          title: "Update Profile".tr(),
                          shapeRadius: 15,
                          padding: EdgeInsets.all(5),
                          loading: model.isBusy,
                          onPressed: model.processUpdate,
                        ).centered().py12(),
                      ],
                    ),
                  ).py20(),
                ],
              ).p20().scrollVertical()),
        );
      },
    );
  }
}
