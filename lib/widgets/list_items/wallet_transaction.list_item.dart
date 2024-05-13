import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/string.dart';
import 'package:huops/models/wallet_transaction.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class WalletTransactionListItem extends StatelessWidget {
  const WalletTransactionListItem(this.walletTransaction, {Key? key})
      : super(key: key);

  final WalletTransaction walletTransaction;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        UiSpacer.verticalSpace(space: 5),
        HStack(
          [
            "${walletTransaction.status.isEmpty ? 'Error' : walletTransaction.status}"
                .tr()
                .allWordsCapitilize()
                .text
                .medium
                .sm
                .color(AppColor.getStausColor(walletTransaction.status))
                .make()
                .expand(),
            ("${walletTransaction.isCredit == 1 ? '+' : '-'} " +
                    "${AppStrings.currencySymbol} ${walletTransaction.amount}"
                        .currencyFormat())
                .text
                .medium
                .color(walletTransaction.isCredit == 1 ? Colors.green : Colors.green)
                .make()
          ],
        ),
        //
        HStack(
          [
            "${walletTransaction.reason}".tr().text.sm.color(Colors.white).make().expand(),
            "${DateFormat.MMMd(translator.activeLocale.languageCode).format(walletTransaction.createdAt)}"
                .text.color(Colors.white)
                .light
                .make()
          ],
        ),
      ],
    )
        .p8()
        .box
        .outerShadow
        .withRounded(value: 5)
        .clip(Clip.antiAlias)
        .make().glassMorphic(opacity: 0.1)
        .px20();
  }
}
