import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/notifications.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      viewModelBuilder: () => NotificationsViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePageWithoutNavBar(
          showAppBar: true,
          showLeadingAction: true,
          title: "Notifications".tr(),
          body: SafeArea(
            child: CustomListView(
              dataSet: model.notifications,
              emptyWidget: EmptyState(
                title: "No Notifications".tr(),
                description:
                    "You dont' have notifications yet. When you get notifications, they will appear here"
                        .tr(),
              ),
              itemBuilder: (context, index) {
                //
                final notification = model.notifications[index];
                return
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children:[

                    //title
                    Row(children: [
                      "${notification.title}"
                          .text
                          .bold
                          .fontFamily(GoogleFonts.nunito().fontFamily!)
                          .make(),
                      Spacer(),
                      notification.read??true?SizedBox():CircleAvatar(
                        radius: 3,
                        backgroundColor: AppColor.primaryColor,
                      )
                    ],),

                    //body
                    "${notification.body}"
                        .text
                        .maxLines(1)
                        .overflow(TextOverflow.ellipsis)
                        .fontFamily(GoogleFonts.nunito().fontFamily!)
                        .make(),
                    //time
                    Row(children: [
                      Spacer(),
                      notification.formattedTimeStamp.text.medium
                          .color(Colors.grey).sm
                          .fontFamily(GoogleFonts.nunito().fontFamily!)
                          .make(),
                    ],)
                  ],
                )
                    .p12()
                    .box
                    .make().glassMorphic(opacity:notification.read??true?0:0.1)
                    .onTap(() {
                  model.showNotificationDetails(notification);
                });
              },
              // separatorBuilder: (context, index) => UiSpacer.divider(),
            ).p12(),
          ),
        );
      },
    );
  }
}
