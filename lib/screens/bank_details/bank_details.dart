import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/bankDetails_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BankDetailsNotifier(),
      child: Consumer<BankDetailsNotifier>(
          builder: (context, bankDetailsNotifier, _) {
        return PageScaffold(
          appbar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: Padding(
              padding: isMobile(context) || isTab(context)
                  ? px15DimenTop(context)
                  : px30DimenTopOnly(context),
              child: buildAppbar(context),
            ),
          ),
          color: bankDetailsBackground,
          title: S.of(context).bankDetails,
          body: SingleChildScrollView(
            primary: true,
            child: Padding(
              padding: px20DimenAll(context),
              child: Column(
                children: [
                  buildRemittanceAndWallet(context, bankDetailsNotifier),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Appbar
  Widget buildAppbar(BuildContext context) {
    return buildAppBar(
      context,
      Text(S.of(context).bankDetails, style: appBarWelcomeText(context)),
    );
  }

  // Remittance & Wallet QR code
  Widget buildRemittanceAndWallet(
      BuildContext context, BankDetailsNotifier bankDetailsNotifier) {
    return isWeb(context)
        ? Row(
            children: [
              buildBankDetailsCard(
                  context,
                  name: S.of(context).remittance,
                  bankDetailsNotifier,
                  image: AppImages.remitQrCode,
                  uenNumber: AppConstants.uenNumber,
                  copiedValid: bankDetailsNotifier.copiedRemittance,),
              sizedBoxwidth20(context),
              Visibility(
                  visible:
                      bankDetailsNotifier.countryData == AppConstants.singapore,
                  child: buildBankDetailsCard(
                      context,
                      name: S.of(context).wallet,
                      bankDetailsNotifier,
                      image: AppImages.walletQrCode,
                      uenNumber: AppConstants.uenNumber,
                      copiedValid: bankDetailsNotifier.copiedWallet,)),
            ],
          )
        : Column(children: [
            buildBankDetailsCard(
                context,
                name: S.of(context).remittance,
                bankDetailsNotifier,
                image: AppImages.remitQrCode,
                uenNumber: AppConstants.uenNumber,
                copiedValid: bankDetailsNotifier.copiedRemittance),
            sizedBoxHeight30(context),
            Visibility(
                visible:
                    bankDetailsNotifier.countryData == AppConstants.singapore,
                child: buildBankDetailsCard(
                    context,
                    name: S.of(context).wallet,
                    bankDetailsNotifier,
                    image: AppImages.walletQrCode,
                    uenNumber: bankDetailsNotifier.uenNumberWallet,
                    copiedValid: bankDetailsNotifier.copiedWallet)),
          ]);
  }

  // Bank Detail Card
  Widget buildBankDetailsCard(
      BuildContext context, BankDetailsNotifier bankDetailsNotifier,
      {name, image, uenNumber, copiedValid}) {
    return Container(
      width: getScreenWidth(context) < 800
          ? getScreenWidth(context) * 0.9
          : getScreenWidth(context) < 1060
              ? getScreenWidth(context) * 0.46
              : getScreenWidth(context) <= 1100
                  ? getScreenWidth(context) * 0.35
                  : getScreenWidth(context) <= 1200
                      ? getScreenWidth(context) * 0.36
                      : getScreenWidth(context) <= 1300
                          ? getScreenWidth(context) * 0.37
                          : getScreenWidth(context) <= 1400
                              ? getScreenWidth(context) * 0.38
                              : getScreenWidth(context) * 0.39,
      padding: px25DimenAll(context),
      decoration: bankDetailsContainerStyle(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible:
                  bankDetailsNotifier.countryData == AppConstants.singapore,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: fairexchangeStyle(context)),
                  sizedBoxHeight30(context),
                  Text(S.of(context).payNowQRcode,
                      style: payNowQrCodeStyle(context)),
                  sizedBoxHeight15(context),
                  Image.asset(
                    image,
                    height: AppConstants.twoHundred,
                    width: AppConstants.twoHundred,
                  ),
                  sizedBoxHeight35(context),
                  Text(S.of(context).payNowUENnumber,
                      style: payNowQrCodeStyle(context)),
                  sizedBoxHeight5(context),
                  Container(
                    width: AppConstants.twoHundredandFifty,
                    padding: px15DimenHorizontaland10Vertical(context),
                    decoration: BoxDecoration(
                      borderRadius: radiusAll5(context),
                      border: Border.all(color: fieldBorderColorNew),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name == S.of(context).wallet? bankDetailsNotifier.uenNumberWallet :uenNumber,
                          style: labels14(context),
                        ),
                        sizedBoxWidth10(context),
                        Tooltip(
                          message: copiedValid == true
                              ? S.of(context).copiedText
                              : S.of(context).clickToCopy,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {

                                if (name == S.of(context).remittance) {
                                  bankDetailsNotifier.copiedRemittance = true;
                                  bankDetailsNotifier.copiedWallet = false;
                                } else {
                                  bankDetailsNotifier.copiedWallet = true;
                                  bankDetailsNotifier.copiedRemittance = false;
                                }
                                await Clipboard.setData(
                                  ClipboardData(text: name == S.of(context).wallet? bankDetailsNotifier.uenNumberWallet :uenNumber),
                                );
                              },
                              child: Image.asset(
                                AppImages.documentCopy,
                                height: AppConstants.fifteen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  sizedBoxHeight30(context),
                ],
              )),
          Text(S.of(context).bankTransfer, style: payNowQrCodeStyle(context)),
          sizedBoxHeight15(context),
          buildDetailsRow(context,
              title: S.of(context).bankNameWeb,
              description: bankDetailsNotifier.countryData ==
                      AppConstants.australia
                  ? AppConstants.bankName
                  : name == S.of(context).wallet
                      ? "${bankDetailsNotifier.bankNameWallet} (${bankDetailsNotifier.bankCodeWallet})"
                      : "${bankDetailsNotifier.bankName} (${bankDetailsNotifier.bankCode})"),
          sizedBoxHeight15(context),
          buildDetailsRow(context,
              title: S.of(context).accountNameWeb,
              description:
                  bankDetailsNotifier.countryData == AppConstants.australia
                      ? AppConstants.accountName
                      : name == S.of(context).wallet
                          ? bankDetailsNotifier.acNameWallet
                          : bankDetailsNotifier.acName),
          sizedBoxHeight15(context),
          buildDetailsRow(context,
              title: S.of(context).accountNumberWeb,
              description:
                  bankDetailsNotifier.countryData == AppConstants.australia
                      ? accountNumber
                      : name == S.of(context).wallet
                          ? bankDetailsNotifier.acNumberWallet
                          : bankDetailsNotifier.acNumber),
          Visibility(
            visible: bankDetailsNotifier.countryData == AppConstants.australia,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxHeight15(context),
                buildDetailsRow(context,
                    title: S.of(context).bSBCode, description: AppConstants.bsbCode)
              ],
            ),
          ),
          Visibility(
            visible: bankDetailsNotifier.countryData == AppConstants.hongKong,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxHeight15(context),
                buildDetailsRow(context,
                    title: S.of(context).bankCode,
                    description: bankDetailsNotifier.bankCode),
                sizedBoxHeight15(context),
                buildDetailsRow(context,
                    title: S.of(context).branchCode,
                    description: bankDetailsNotifier.branchCode)
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Details Row
  Widget buildDetailsRow(context, {title, description}) {
    return Row(
      children: [
        Expanded(
          flex: AppConstants.oneInt,
          child: Text(title, style: exchangeRateHeadingTextStyle(context)),
        ),
        sizedBoxWidth10(context),
        Expanded(
          flex: AppConstants.two,
          child: Text(description??"", style: blackTextStyle16(context)),
        ),
      ],
    );
  }
}
