import 'dart:async';
import 'dart:io';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/fund_transfer_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Transaction extends StatelessWidget {
  Transaction({Key? key, required this.transactionPageNotifier})
      : super(key: key);
  final FundTransferNotifier transactionPageNotifier;

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildTransactionWidgets(context, transactionPageNotifier);
  }

  Widget buildTransactionWidgets(
      BuildContext context, FundTransferNotifier fundTransferNotifier) {
    return Scrollbar(
      controller: transactionPageNotifier.scrollController,
      child: SingleChildScrollView(
        controller: transactionPageNotifier.scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isWeb(context)
                  ? getScreenWidth(context) * 0.02
                  : getScreenWidth(context) * 0.05,
              vertical: getScreenHeight(context) * 0.02),
          child: isTab(context) || isMobile(context)
              ? Column(
                  children: [
                    Visibility(
                        child: buildDocumentsUpload(
                            context, fundTransferNotifier,
                            left: AppConstants.zero),
                        visible: fundTransferNotifier.isDocumentNeedUpload),
                    buildExpansionContainerList(context, fundTransferNotifier,
                        left: AppConstants.zero),
                    sizedBoxHeight20(context),
                    buildDetailContainer(context, fundTransferNotifier,
                        height: getScreenWidth(context) < 370
                            ? AppConstants.fiveHundredAndFifty
                            : AppConstants.fourHundredFifty),
                    sizedBoxHeight20(context),
                    buildBackButton(context),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Visibility(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: AppConstants.thirty),
                                child: buildDocumentsUpload(
                                    context, fundTransferNotifier,
                                    left: AppConstants.zero),
                              ),
                              visible:
                                  fundTransferNotifier.isDocumentNeedUpload),
                          buildExpansionContainerList(
                              context, fundTransferNotifier,
                              height: fundTransferNotifier.countryData ==
                                      AppConstants.AustraliaName
                                  ? getScreenHeight(context) / 1.4
                                  : getScreenHeight(context) / 1.2),
                        ],
                      ),
                    ),
                    SizedBox(width: getScreenWidth(context) * 0.01),
                    Expanded(
                      child: Column(
                        children: [
                          buildDetailContainer(context, fundTransferNotifier)
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  // Copy Icon
  Widget buildCopyIcon(
      BuildContext context, FundTransferNotifier fundTransferNotifier, bool showValue,
      {String? CopyText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: IconButton(
          tooltip: fundTransferNotifier.uenCopied == false
              ? S.of(context).clickToCopy
              : S.of(context).copiedText,
          icon:
              Image.asset(AppImages.documentCopy, height: AppConstants.twenty),
          onPressed: () {
            Clipboard.setData(ClipboardData(
                    text:
                        CopyText!.isEmpty ? AppConstants.walletCode : CopyText))
                .then(
              (value) {
                fundTransferNotifier.uenCopied = true;
                fundTransferNotifier.accountNumberCopied = false;
                fundTransferNotifier.referenceCopied = false;
                fundTransferNotifier.accountNameCopied = false;
                fundTransferNotifier.bsbCodeCopied = false;
              },
            );
          }),
    );
  }

  // Quick Link label
  Widget buildQuickLinkText(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: buildText(
            text: S.of(context).quickLinksToBanking,
            fontWeight: FontWeight.w400,
            fontColor: oxfordBlueTint400));
  }

  // QR code
  Widget buildQRCodeContainer(BuildContext context) {
    return Container(
      height: AppConstants.twoHundred,
      width: AppConstants.twoHundred,
      color: dividercolor,
      child: Image.asset(AppImages.remitQrCode),
    );
  }

  // UEN Number Textfield
  Widget buildUENNumberTextField(
      BuildContext context, FundTransferNotifier fundTransferNotifier, ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
            text: S.of(context).UENNumberWeb,
            fontSize: AppConstants.sixteen,
            fontColor: oxfordBlueTint400),
        SizedBoxHeight(context, 0.01),
        Container(
          width: AppConstants.twoHundredandFifty,
          height: AppConstants.forty,
          decoration: BoxDecoration(
              border: Border.all(color: fieldBorderColorNew),
              borderRadius: BorderRadius.circular(AppConstants.five)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.all(AppConstants.eight),
                  child: buildText(
                      text: AppConstants.transactionUENNumber,
                      fontSize: AppConstants.sixteen,
                      fontColor: black)),
              buildCopyIcon(context, fundTransferNotifier,fundTransferNotifier.uenCopied,
                  CopyText: AppConstants.transactionUENNumber)
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRTGSTransfer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppConstants.twenty),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBoxHeight(context, 0.01),
          Text.rich(
            TextSpan(
                text: AppConstants.RTGSTransferInfo,
                style: TextStyle(color: black, fontSize: AppConstants.eighteen),
                children: <TextSpan>[
                  TextSpan(
                      text: AppConstants.helpAU,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppConstants.sixteen,
                        color: hanBlue,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  TextSpan(text: AppConstants.avoidDelay)
                ]),
          ),
          SizedBoxHeight(context, 0.01),
        ],
      ),
    );
  }

  Widget buildPayIdTransfer(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: AppConstants.twenty),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildText(
                text: "Pay to our email address via PayID: ",
                fontWeight: FontWeight.w400,
                fontSize: AppConstants.sixteen,
                fontColor: black),
            SizedBoxHeight(context, 0.015),
            GestureDetector(
              onTap: () async {
                String email = Uri.encodeComponent(AppConstants.walletUrl);
                String subject = Uri.encodeComponent("");
                String body = Uri.encodeComponent("");
                Uri mail =
                    Uri.parse("mailto:$email?subject=$subject&body=$body");
                if (await launchUrl(mail)) {
                  //email app opened
                } else {
                  //email app is not opened
                }
              },
              child: buildText(
                  text: AppConstants.walletUrl,
                  fontWeight: FontWeight.w700,
                  fontSize: AppConstants.sixteen,
                  fontColor: hanBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFPS(BuildContext context, int? index,
      FundTransferNotifier fundTransferNotifier) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: AppConstants.twenty),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text:
                      'With FPS, You can now send money instantly to us using our email address: ',
                  style:
                      TextStyle(color: black, fontSize: AppConstants.eighteen),
                  children: [
                    WidgetSpan(
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String email = Uri.encodeComponent(
                                AppConstants.financeTeamUrl);
                            String subject = Uri.encodeComponent("");
                            String body = Uri.encodeComponent("");
                            Uri mail = Uri.parse(
                                "mailto:$email?subject=$subject&body=$body");
                            if (await launchUrl(mail)) {
                              //email app opened
                            } else {
                              //email app is not opened
                            }
                          },
                          child: Text(
                            AppConstants.financeTeamUrl,
                            style: findOutMoreTextStyle(context),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: AppConstants.eight),
                          child: buildCopyIcon(context, fundTransferNotifier,fundTransferNotifier.uenCopied,
                              CopyText: AppConstants.financeTeamUrl),
                        )
                      ],
                    ),)
                  ],),
            ),
            sizedBoxHeight20(context),
            Text.rich(
              TextSpan(
                  text: 'Click ',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlue),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'here',
                        style: findOutMoreTextStyle(context),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            fundTransferNotifier.selectedTile = 0;
                          }),
                    TextSpan(
                        text: ' if you are unable to access FPS',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: AppConstants.sixteen,
                            color: oxfordBlue))
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRowText(name, description, BuildContext context,
      {FontWeight? weight, color, FundTransferNotifier? fundTransferNotifier, bool? isBank,bool? isToolChange}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: buildText(
            text: name,
            fontWeight: weight ?? FontWeight.w400,
            fontSize: AppConstants.sixteen,
            fontColor: color ?? black,
          ),
        ),
        SizedBoxWidth(context, 0.01),
        (name == "Reference Number" || name == "Account Name" || (name == "Account Number" && isBank == true)|| (name == "BSB Code" && isBank == true)) && description != ''
            ? Expanded(
                flex: 2,
                child: Wrap(
                  children: [
                    buildText(
                      text: description ?? '',
                      fontWeight: weight ?? FontWeight.w400,
                      fontSize: AppConstants.sixteen,
                      fontColor: color ?? black,
                    ),
                    sizedBoxWidth3(context),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Tooltip(
                        message:
                        (name == "Reference Number" ? fundTransferNotifier!.referenceCopied == true :  name == "Account Name" ? fundTransferNotifier!.accountNameCopied  == true: (name == "Account Number" && isBank == true)? fundTransferNotifier!.accountNumberCopied  == true: (name == "BSB Code" && isBank == true) ? fundTransferNotifier!.bsbCodeCopied  == true: fundTransferNotifier!.uenCopied  == true)
                            ? S.of(context).copiedText
                            : S.of(context).clickToCopy,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              fundTransferNotifier.referenceCopied = false;
                              fundTransferNotifier.accountNameCopied = false;
                              fundTransferNotifier.accountNumberCopied = false;
                              fundTransferNotifier.bsbCodeCopied = false;
                              fundTransferNotifier.uenCopied = false;
                              name == "Reference Number" ? fundTransferNotifier.referenceCopied = true :  name == "Account Name" ? fundTransferNotifier.accountNameCopied  = true: (name == "Account Number" && isBank == true)? fundTransferNotifier.accountNumberCopied  = true: (name == "BSB Code" && isBank == true) ? fundTransferNotifier.bsbCodeCopied = true: fundTransferNotifier.uenCopied  = true;
                              await Clipboard.setData(
                                ClipboardData(text: description),
                              );
                            },
                            child: Image.asset(
                              AppImages.documentCopy,
                              height: AppConstants.fifteen,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
            : Expanded(
                flex: 2,
                child: buildText(
                    text: description ?? '',
                    fontWeight: weight ?? FontWeight.w400,
                    fontSize: AppConstants.sixteen,
                    fontColor: color ?? black),
              ),
      ],
    );
  }

  // Back Button
  Widget buildBackButton(BuildContext context) {
    return buildButton(context,
        width: AppConstants.twoHundred,
        name: AppConstants.backToDashboard,
        fontColor: hanBlue,
        color: hanBlueTint200, onPressed: () async {
      SharedPreferencesMobileWeb.instance
          .removeParticularKey(AppConstants.accountScreenData);
      SharedPreferencesMobileWeb.instance
          .removeParticularKey(AppConstants.receiverScreenData);
      SharedPreferencesMobileWeb.instance
          .removeParticularKey(AppConstants.reviewScreenData);
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, dashBoardRoute, (route) => false);
      });

      Provider.of<CommonNotifier>(context, listen: false).updateData(1);
      SharedPreferencesMobileWeb.instance
          .setAccountSelectedScreenData(AppConstants.accountPage, false);
      SharedPreferencesMobileWeb.instance
          .setReceiverSelectedScreenData(AppConstants.receiverPage, false);
      SharedPreferencesMobileWeb.instance
          .setReviewSelectedScreenData(AppConstants.reviewPage, false);
    });
  }

  // Expansion Tile
  Widget buildExpansionList(
      BuildContext context, FundTransferNotifier fundTransferNotifier,
      {String? title,
      String? subtitle,
      int? index,
      onExpansionChanged,
      Key? key,
      required bool initiallyExpanded,
      isExpandedTile}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radiusAll8(context),
        color: white,
        border:
            Border.all(color: Colors.grey.shade200, width: AppConstants.one),
      ),
      child: ExpansionTile(
        key: key,
        initiallyExpanded: initiallyExpanded,
        title: buildText(
            text: title ?? '',
            fontWeight: FontWeight.w800,
            fontSize: AppConstants.sixteen),
        subtitle: buildText(text: subtitle ?? ''),
        trailing: Padding(
          padding: EdgeInsets.only(
              right: AppConstants.twoDouble, top: AppConstants.ten),
          child: Image.asset(AppImages.dropDownImage,
              height: AppConstants.twentyFour, width: AppConstants.twentyFour),
        ),
        onExpansionChanged: onExpansionChanged,
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.eight),
            child: Divider(color: dottedLineColor),
          ),
          SizedBoxHeight(context, 0.01),
          fundTransferNotifier.countryData == AppConstants.AustraliaName
              ? Visibility(
                  visible: fundTransferNotifier.countryData ==
                          AppConstants.AustraliaName
                      ? index == 0
                      : false,
                  child: buildPayIdTransfer(context))
              : fundTransferNotifier.countryData == AppConstants.HongKongName
                  ? Visibility(
                      visible: index == 1 ? true : false,
                      child: buildFPS(context, index, fundTransferNotifier))
                  : Visibility(
                      visible: index == 0,
                      child: buildQRCodeContainer(context)),
          fundTransferNotifier.countryData == AppConstants.AustraliaName ||
                  fundTransferNotifier.countryData == AppConstants.HongKongName
              ? SizedBox()
              : Visibility(
                  visible: index == 1,
                  child:
                      buildUENNumberTextField(context, fundTransferNotifier)),
          Visibility(
            visible: fundTransferNotifier.countryData ==
                    AppConstants.AustraliaName
                ? index == 1
                : fundTransferNotifier.countryData == AppConstants.HongKongName
                    ? index == 0
                    : index == 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: AppConstants.twenty),
                    child: buildText(
                        text: S.of(context).onlineBanking,
                        fontWeight: FontWeight.w700,
                        fontSize: AppConstants.twenty,
                        fontColor: oxfordBlue)),
                SizedBoxHeight(context, 0.01),
                Padding(
                    padding: EdgeInsets.only(left: AppConstants.twenty),
                    child: buildText(
                        text:
                            S.of(context).alternativelyYouCanSendPaymentToSingX,
                        fontWeight: FontWeight.w400,
                        fontSize: AppConstants.sixteen,
                        fontColor: oxfordBlueTint400)),
                SizedBoxHeight(context, 0.025),
                Padding(
                  padding: EdgeInsets.all(AppConstants.eight),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: dividercolor),
                        color: white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: getScreenWidth(context) * 0.01,
                          top: getScreenHeight(context) * 0.01),
                      child: Column(
                        children: [
                          buildRowText(S.of(context).bankName,
                              fundTransferNotifier.bankName, context),
                          SizedBox(
                              height: getScreenWidth(context) < 400
                                  ? AppConstants.ten
                                  : AppConstants.twelve),
                          buildRowText(S.of(context).accountName,
                              fundTransferNotifier.accountName, context,fundTransferNotifier: fundTransferNotifier, isToolChange: fundTransferNotifier.accountNameCopied),
                          SizedBox(
                              height: getScreenWidth(context) < 400
                                  ? AppConstants.ten
                                  : AppConstants.twelve),
                          buildRowText(
                              S.of(context).accountNumber,
                              fundTransferNotifier.countryData ==
                                      AppConstants.AustraliaName
                                  ? fundTransferNotifier.accountNumberAus
                                      .toString()
                                  : fundTransferNotifier.accountNumber
                                      .toString(),
                              context,fundTransferNotifier: fundTransferNotifier, isBank: true, isToolChange: fundTransferNotifier.accountNumberCopied),
                          fundTransferNotifier.countryData ==
                                  AppConstants.hongKong
                              ? SizedBox(
                                  height: getScreenWidth(context) < 400
                                      ? AppConstants.ten
                                      : AppConstants.twelve)
                              : SizedBox(),
                          fundTransferNotifier.countryData ==
                                  AppConstants.hongKong
                              ? buildRowText(
                                  S.of(context).bankCode,
                                  fundTransferNotifier.bankCode.toString(),
                                  context)
                              : SizedBox(),
                          fundTransferNotifier.countryData ==
                                  AppConstants.hongKong
                              ? SizedBox(
                                  height: getScreenWidth(context) < 400
                                      ? AppConstants.ten
                                      : AppConstants.twelve)
                              : SizedBox(),
                          fundTransferNotifier.countryData ==
                                  AppConstants.hongKong
                              ? buildRowText(
                                  S.of(context).branchCode,
                                  fundTransferNotifier.branchCode.toString(),
                                  context)
                              : SizedBox(),
                          SizedBox(
                              height: getScreenWidth(context) < 400
                                  ? AppConstants.ten
                                  : AppConstants.twelve),
                          fundTransferNotifier.bsbCode != ''
                              ? buildRowText(S.of(context).bSBCode,
                                  fundTransferNotifier.bsbCode, context,fundTransferNotifier: fundTransferNotifier, isBank: true, isToolChange: fundTransferNotifier.bsbCodeCopied)
                              : SizedBox(),
                          SizedBox(height: getScreenHeight(context) * 0.02)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
              visible: fundTransferNotifier.countryData ==
                  AppConstants.AustraliaName,
              child: Visibility(
                  visible: index == 2 ? true : false,
                  child: buildRTGSTransfer(context))),
          SizedBoxHeight(context, 0.03),
          fundTransferNotifier.countryData == AppConstants.HongKongName ||
                  fundTransferNotifier.countryData == AppConstants.australia
              ? Text('')
              : Visibility(
                  visible: index == 2,
                  child: Column(
                    children: [
                      buildQuickLinkText(context),
                      Container(
                        height: 70,
                        width: double.infinity,
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: fundTransferNotifier.scrollController,
                          child: ListView.separated(
                            controller: fundTransferNotifier.scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: index == 0 &&
                                            getScreenWidth(context) > 1000
                                        ? getScreenWidth(context) * 0.08
                                        : AppConstants.twenty,
                                    bottom: AppConstants.twenty,
                                    right: AppConstants.ten),
                                child: GestureDetector(
                                    onTap: () => launchUrlString(
                                        AppConstants.bankLink[index]),
                                    child: Image.asset(
                                        AppConstants.bankImages[index],
                                        height: AppConstants.thirty,
                                        width: AppConstants.eighty)),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBoxWidth(context, 0.05);
                            },
                            itemCount: 6,
                          ),
                        ),
                      ),
                      SizedBoxHeight(context, 0.03)
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildExpansionContainerList(
      BuildContext context, FundTransferNotifier fundTransferNotifier,
      {double? height, double? left}) {
    return Container(
      height: height,
      child: Padding(
        padding: EdgeInsets.only(
            left: left ?? AppConstants.thirty, top: AppConstants.twenty),
        child: SingleChildScrollView(
          controller: transactionPageNotifier.scrollController,
          child: Padding(
            padding: EdgeInsets.only(right: AppConstants.eighteen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    text: S.of(context).chooseYourPaymentMethod,
                    fontSize: AppConstants.eighteen,
                    fontWeight: FontWeight.w800),
                SizedBoxHeight(context, 0.03),
                buildKRWImportantInfo(context, fundTransferNotifier),
                SizedBoxHeight(context, 0.03),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: Key(fundTransferNotifier.selectedTile.toString()),
                  itemCount: fundTransferNotifier.countryData ==
                          AppConstants.AustraliaName
                      ? 3
                      : fundTransferNotifier.countryData ==
                              AppConstants.HongKongName
                          ? 2
                          : 3,
                  itemBuilder: (context, index) {
                    return buildExpansionList(
                      context,
                      fundTransferNotifier,
                      key: Key(index.toString()),
                      initiallyExpanded:
                          index == fundTransferNotifier.selectedTile,
                      index: index,
                      title: fundTransferNotifier.countryData ==
                              AppConstants.AustraliaName
                          ? fundTransferNotifier.titlesAus[index]
                          : fundTransferNotifier.countryData ==
                                  AppConstants.HongKongName
                              ? fundTransferNotifier.titlesHKG[index]
                              : fundTransferNotifier.titles[index],
                      subtitle: fundTransferNotifier.countryData ==
                              AppConstants.AustraliaName
                          ? fundTransferNotifier.subTitlesAus[index]
                          : fundTransferNotifier.countryData ==
                                  AppConstants.HongKongName
                              ? fundTransferNotifier.subTitlesHKG[index]
                              : fundTransferNotifier.subTitles[index],
                      onExpansionChanged: (val) {
                        if (val) {
                          fundTransferNotifier.selectedTile = index;
                        } else {
                          fundTransferNotifier.selectedTile = -1;
                        }
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBoxHeight(context, 0.03);
                  },
                ),
                sizedBoxHeight20(context),
                buildAUDInfo(context, fundTransferNotifier),
                buildHongKongAUDInfo(context, fundTransferNotifier),
                Visibility(
                  visible: isWeb(context),
                  child: Column(
                    children: [
                      sizedBoxHeight30(context),
                      Center(child: buildBackButton(context))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAUDInfo(
      BuildContext context, FundTransferNotifier fundTransferNotifier) {
    return Visibility(
      visible: fundTransferNotifier.countryData == AppConstants.singapore &&
          fundTransferNotifier.selectedReceiver == "AUD",
      child: Container(
        width: getScreenWidth(context),
        padding: EdgeInsets.all(AppConstants.fifteen),
        decoration: BoxDecoration(color: orangePantone.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: AppConstants.transferSGD10000,
                style: blackTextStyle16(context),
                children: <TextSpan>[
                  TextSpan(
                    text: AppConstants.operationSingxUrl,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String email =
                            Uri.encodeComponent(AppConstants.operationSingxUrl);
                        String subject = Uri.encodeComponent("");
                        String body = Uri.encodeComponent("");
                        Uri mail = Uri.parse(
                            "mailto:$email?subject=$subject&body=$body");
                        if (await launchUrl(mail)) {
                          //email app opened
                        } else {
                          //email app is not opened
                        }
                      },
                    style: hanBlueTextStyle16(context),
                  ),
                ],
              ),
            ),
            sizedBoxHeight10(context),
            Text(
              AppConstants.recentPayable,
              style: blackTextStyle16(context),
            ),
            sizedBoxHeight10(context),
            Text(
              AppConstants.bankStatement,
              style: blackTextStyle16(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHongKongAUDInfo(
      BuildContext context, FundTransferNotifier fundTransferNotifier) {
    return Visibility(
      visible:fundTransferNotifier.selectedSender == "HKD" &&
          fundTransferNotifier.selectedReceiver == "AUD",
      child: Container(
        width: getScreenWidth(context),
        padding: EdgeInsets.all(AppConstants.fifteen),
        decoration: BoxDecoration(color: orangePantone.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: AppConstants.transferHKD10000,
                style: blackTextStyle16(context),
                children: <TextSpan>[
                  TextSpan(
                    text: AppConstants.financeTeamUrl,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String email =
                        Uri.encodeComponent(AppConstants.operationSingxUrl);
                        String subject = Uri.encodeComponent("");
                        String body = Uri.encodeComponent("");
                        Uri mail = Uri.parse(
                            "mailto:$email?subject=$subject&body=$body");
                        if (await launchUrl(mail)) {
                          //email app opened
                        } else {
                          //email app is not opened
                        }
                      },
                    style: hanBlueTextStyle16(context),
                  ),
                ],
              ),
            ),
            sizedBoxHeight10(context),
            Text(
              AppConstants.recentPayable,
              style: blackTextStyle16(context),
            ),
            sizedBoxHeight10(context),
            Text(
              AppConstants.bankStatement,
              style: blackTextStyle16(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKRWImportantInfo(
      BuildContext context, FundTransferNotifier fundTransferNotifier) {
    return Visibility(
      visible: fundTransferNotifier.countryData == AppConstants.singapore &&
          fundTransferNotifier.selectedReceiver == "KRW",
      child: Container(
        width: getScreenWidth(context),
        padding: EdgeInsets.all(AppConstants.ten),
        decoration: BoxDecoration(color: Color(0xfffff2cc)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.importantNote,
              style: ImpNoteTextStyle16(context),
            ),
            sizedBoxHeight10(context),
            Text(
              AppConstants.koreaNote,
              style: ImpNoteTextStyle16(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailContainer(
      BuildContext context, FundTransferNotifier notifier,
      {double? height}) {
    return Padding(
      padding: EdgeInsets.only(
          right: isWeb(context) ? AppConstants.zero : AppConstants.eighteen),
      child: Container(
        height: height ?? getScreenHeight(context) / 1.2,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
        child: Padding(
          padding: EdgeInsets.only(
              left: AppConstants.twenty, top: AppConstants.twenty),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                  text: AppConstants.transferDetails,
                  fontWeight: FontWeight.w800,
                  fontSize: AppConstants.eighteen),
              SizedBoxHeight(context, 0.02),
              buildRowText(S.of(context).referenceNumberWeb,
                  notifier.referenceNumber, context,
                  fundTransferNotifier: notifier, isToolChange: notifier.referenceCopied),
              buildRowText(
                  AppConstants.sendAmount,
                  "${notifier.selectedSender} ${double.parse(notifier.sendController.text).toStringAsFixed(2)}",
                  context),
              buildRowText(
                  S.of(context).exchangeRateWeb,
                  "${notifier.selectedReceiver} ${double.parse(notifier.exchangeRateConverted)}",
                  context),
              buildRowText(
                  AppConstants.receiveAmount,
                  "${notifier.selectedReceiver} ${double.parse(notifier.recipientController.text).toStringAsFixed(2)}",
                  context),
              buildRowText(
                  AppConstants.singxFee,
                  "${notifier.selectedSender} ${notifier.singXData.toStringAsFixed(2)}",
                  context),
              buildRowText(
                  AppConstants.totalPayment,
                  "${notifier.selectedSender} ${notifier.totalPayable.toStringAsFixed(2)}",
                  context,
                  color: orangePantone),
              SizedBoxHeight(context, 0.05),
              buildText(
                  text: AppConstants.receiverDetails,
                  fontWeight: FontWeight.w800,
                  fontSize: AppConstants.eighteen),
              SizedBoxHeight(context, 0.02),
              buildRowText(
                  S.of(context).name, notifier.receiverNameData, context),
              buildRowText(S.of(context).countryWeb,
                  "${notifier.receiverCountryData}", context),
              buildRowText(S.of(context).bankName,
                  notifier.receiverBankNameData, context),
              buildRowText(S.of(context).accountNumber,
                  notifier.receiverAccountNumberData, context),
              Visibility(
                  visible: notifier.bsbCode.isNotEmpty && notifier.countryData != AppConstants.AustraliaName,
                  child: buildRowText(
                      S.of(context).bSBCode, notifier.bsbCode, context))
            ],
          ),
        ),
      ),
    );
  }

  // Additional Documents
  Widget buildDocumentsUpload(
      BuildContext context, FundTransferNotifier notifier,
      {double? left}) {
    return Padding(
      padding: EdgeInsets.only(
          left: left ?? AppConstants.thirty, right: AppConstants.eight),
      child: Container(
        padding: px20DimenAll(context),
        decoration: BoxDecoration(
          borderRadius: radiusAll15(context),
          color: fieldBackWhitegroundColor,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.08),
              blurRadius: AppConstants.twenty,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(
              text: AppConstants.additionalDetail,
              fontSize: AppConstants.eighteen,
              fontWeight: FontWeight.w800,
            ),
            sizedBoxHeight10(context),
            buildText(
              text: AppConstants.additionalDocument,
              fontWeight: FontWeight.w400,
              fontSize: AppConstants.sixteen,
              fontColor: oxfordBlueTint400,
            ),
            sizedBoxHeight10(context),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppConstants.fundDocument,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlue,
                    ),
                  ),
                  TextSpan(
                    text: AppConstants.monthlyIncome,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlueTint400,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '(Check our ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlueTint400,
                    ),
                  ),
                  TextSpan(
                    text: AppConstants.faq,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString(AppConstants.australiaSupportURL);
                      },
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppConstants.sixteen,
                      color: hanBlue,
                    ),
                  ),
                  TextSpan(
                    text: AppConstants.listOfDoc,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlueTint400,
                    ),
                  ),
                ],
              ),
            ),
            sizedBoxHeight10(context),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppConstants.note,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlue,
                    ),
                  ),
                  TextSpan(
                    text: AppConstants.ignoreAlreadyProvided,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlueTint400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBoxHeight(context, 0.02),
            kIsWeb
                ? buildDragAndDropBox(notifier, context)
                : buildDragAndDropBoxMobile(notifier, context),
            Visibility(
                visible: notifier.isFileAddedVerification,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxHeight(context, 0.01),
                    buildText(
                        text: S
                            .of(context)
                            .noFilesUploadedPleaseUploadAtLeastOneValidDocument,
                        fontColor: errorTextField,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.5)
                  ],
                )),
            sizedBoxHeight10(context),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppConstants.emailTheDocument,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppConstants.sixteen,
                      color: oxfordBlueTint400,
                    ),
                  ),
                  TextSpan(
                    text: AppConstants.helpAU,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String email = Uri.encodeComponent(AppConstants.helpAU);
                        String subject = Uri.encodeComponent("");
                        String body = Uri.encodeComponent("");
                        Uri mail = Uri.parse(
                            "mailto:$email?subject=$subject&body=$body");
                        if (await launchUrl(mail)) {
                          //email app opened
                        } else {
                          //email app is not opened
                        }
                      },
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppConstants.sixteen,
                      color: hanBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drag and DropBox
  Widget buildDragAndDropBox(
      FundTransferNotifier notifier, BuildContext context) {
    return Center(
      child: buildDropFilesBox(
        context: context,
        isFileAdded: notifier.isFileAdded,
        loading: notifier.isFileLoading,
        progressValue: notifier.progressValue,
        file: notifier.file,
        onDroppedFile: (file) async {
          notifier.file = file;
          notifier.isFileAdded = true;
          updateProgress(notifier);
          notifier.transactionFileUpload(notifier.file!.path,
              notifier.file!.name, 1, notifier.referenceNumber, context);
        },
        onIconClosePressUpload: () {
          notifier.isFileAdded = false;
          notifier.isFileLoading = true;
          notifier.progressValue = 0.0;
        },
        onIconClosePressFinish: () {
          notifier.isFileAdded = false;
          notifier.isFileLoading = true;
          notifier.progressValue = 0.0;
        },
      ),
    );
  }

  // Drag and DropBox Mobile
  Widget buildDragAndDropBoxMobile(
      FundTransferNotifier notifier, BuildContext context) {
    return buildDropFilesBoxMobile(
      context: context,
      isFileAdded: notifier.isFileAdded,
      loading: notifier.isFileLoading,
      progressValue: notifier.progressValue,
      file: notifier.platformFile,
      fileImage: notifier.files,
      size: notifier.size,
      onTap: () => selectFile(notifier, context),
      onIconClosePressUpload: () {
        notifier.isFileAdded = false;
        notifier.isFileLoading = true;
        notifier.progressValue = 0.0;
      },
      onIconClosePressFinish: () {
        notifier.isFileAdded = false;
        notifier.isFileLoading = true;
        notifier.progressValue = 0.0;
      },
    );
  }

  // DropBox Progress updating function
  void updateProgress(FundTransferNotifier notifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      notifier.progressValue += 0.1;
      if (!notifier.isFileAdded) {
        t.cancel();
      }
      if (notifier.progressValue.toStringAsFixed(1) == '1.0') {
        notifier.isFileLoading = false;
        t.cancel();
        return;
      }
    });
  }

  // Picking File in Mobile
  selectFile(FundTransferNotifier notifier, BuildContext context) async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
    if (file != null) {
      notifier.files = File(file.files.single.path!);
      var sizeInBytes = notifier.files!.lengthSync();
      var sizeInKb = sizeInBytes / 1024;
      var sizeInMb = sizeInKb / 1024;
      final kb = notifier.files!.lengthSync() / 1024;
      var sizeLimit = 5120;
      if (kb > sizeLimit) {
        //SnackBar(content: Text('Upload file less than 5MB'));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Upload file less than 5MB"),
          duration: Duration(seconds: 3),

        ));
      } else {
        notifier.size = sizeInMb > 1
            ? '${sizeInMb.toStringAsFixed(2)} MB'
            : '${sizeInKb.toStringAsFixed(2)} KB';
        notifier.platformFile = file.files.first;
        updateProgress(notifier);
        notifier.isFileAdded = true;
        notifier.transactionFileUpload(
            notifier.files!.path,
            notifier.files!
                .path
                .split("/")
                .last,
            1,
            notifier.referenceNumber,
            context);
      }
    }
  }
}
