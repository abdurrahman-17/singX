import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/fund_transfer_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/manage_receiver/manage_receivers.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class Receiver extends StatelessWidget {
  Receiver({Key? key, required this.receiverPageNotifier}) : super(key: key);
  final FundTransferNotifier receiverPageNotifier;

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Scrollbar(
      controller: receiverPageNotifier.scrollController,
      child: SingleChildScrollView(
        controller: receiverPageNotifier.scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? getScreenWidth(context) >= 361 &&
                      getScreenWidth(context) <= 1150
                  ? getScreenWidth(context) * 0.05
                  : getScreenWidth(context) <= 800
                      ? getScreenWidth(context) * 0.03
                      : getScreenWidth(context) * 0.25 : screenSizeWidth * 0.05),
          child: Form(
            key: receiverPageNotifier.receiverPageKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonSizedBoxHeight40(context),
                buildReceiverText(context),
                commonSizedBoxHeight10(context),
                buildChooseReceiverText(context),
                commonSizedBoxHeight30(context),
                buildBankAccountDropDownField(),
                commonSizedBoxHeight15(context),
                buildAddReceiverRow(receiverPageNotifier, context),
                commonSizedBoxHeight60(context),
                buildButtons(receiverPageNotifier, context),
                commonSizedBoxHeight50(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Receiver Text Label
  Widget buildReceiverText(BuildContext context) {
    return buildText(
        text: S.of(context).selectReceiver,
        fontWeight: FontWeight.w700,
        fontColor: oxfordBlue,
        fontSize: AppConstants.twenty);
  }

  // Receiver Text InfoLabel
  Widget buildChooseReceiverText(BuildContext context) {
    return buildText(
        text: S.of(context).chooseExistingReceiverOrAddNew,
        fontWeight: FontWeight.w400,
        fontColor: oxfordBlueTint400,
        fontSize: AppConstants.sixteen);
  }

  // Adding a new receiver label
  Widget buildAddReceiverRow(FundTransferNotifier notifier, BuildContext context) {
    return Row(
      children: [
        IconButton(
            hoverColor: Colors.transparent,
            icon: Icon(Icons.add),
            color: hanBlue,
            onPressed: () =>
                openBankNewAccountPopUp(notifier.dialogFormKey, context)),
        commonSizedBoxWidth10(context),
        InkWell(
            onTap: () =>
                openBankNewAccountPopUp(notifier.dialogFormKey, context),
            child: buildText(
                text: S.of(context).addaNewReceiver,
                fontColor: hanBlue,
                fontWeight: FontWeight.w700))
      ],
    );
  }

  // Back and continue button
  Widget buildButtons(FundTransferNotifier notifier, BuildContext context) {
    var buttonWidth = kIsWeb ? getScreenWidth(context) <= 1150
        ? getScreenWidth(context) * 0.44
        : getScreenWidth(context) * 0.24 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.44 : screenSizeWidth * 0.24;
    return commonBackAndContinueButton(
      context,
      widthBetween: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02,
      backWidth: buttonWidth,
      continueWidth: buttonWidth,
      onPressedBack: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(AppConstants.country)
            .then((value) async {
          Navigator.pushNamed(context, fundTransferSelectAccountRoute);
        });
      },
      onPressedContinue: () async {
        if (notifier.receiverPageKey.currentState!.validate()) {
          notifier.countryData == AppConstants.AustraliaName
              ? await notifier.getBankNameAndCountryAUS(context)
              : await notifier.getBankNameAndCountry(context);
          Map<String, dynamic> accountData = {
            "selectedReceiverBank": notifier.selectedReceiverBank,
            "receiverId": notifier.selectedBankReceiverId,
            "receiverName": notifier.receiverNameData,
            "receiverBankName": notifier.receiverBankNameData,
            "receiverAccountNumber": notifier.receiverAccountNumberData,
            "receiverCountry": notifier.receiverCountryData,
          };
          SharedPreferencesMobileWeb.instance.setFundTransferReceiverData(
              AppConstants.receiverScreenData, jsonEncode(accountData));
          Provider.of<CommonNotifier>(context, listen: false)
              .incrementCounterFund();
          await SharedPreferencesMobileWeb.instance
              .getCountry(AppConstants.country)
              .then((value) async {
            Navigator.pushNamed(context, fundTransferReviewRoute);
          });

          SharedPreferencesMobileWeb.instance
              .setReceiverSelectedScreenData(AppConstants.receiverPage, true);
        }
      },
    );
  }

  // Adding a new receiver PopUp dialog
  openBankNewAccountPopUp(key, BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AppInActiveCheck(
              context: context,
              child: AlertDialog(
                content: MouseRegion(
                  onHover: (PointerEvent event) {
                    handleInteraction(context);
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => handleInteraction(context),
                    onPanDown: (_) => handleInteraction(context),
                    onPanUpdate: (_) => handleInteraction(context),
                    child: SizedBox(
                        width: AppConstants.fiveHundredAndFifty,
                        height: AppConstants.nineHundred,
                        child: ManageReceivers(
                                navigateData: true,
                                isReceiverPopUpEnabled: true)
                            .build(context)),
                  ),
                ),
              ),
            );
          });
        },
        context: context);
  }

  // Receiver DropDown
  Widget buildBankAccountDropDownField() {
    return LayoutBuilder(
        builder: (context, constraints) => CustomizeDropdown(context,
                dropdownItems: receiverPageNotifier.receiverBankAccounts,
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected onSelected, Iterable options) {
              return buildDropDownContainer(context,
                  options: options,
                  onSelected: onSelected,
                  dropdownData: receiverPageNotifier.receiverBankAccounts,
                  dropDownHeight: options.first == S.of(context).noDataFound
                      ? AppConstants.oneHundredFifty
                      : options.length < 5
                          ? options.length * 60
                          : AppConstants.threeHundred,
                  constraints: constraints);
            }, onSelected: (selection) {
              handleInteraction(context);
              if (receiverPageNotifier.countryData == AppConstants.AustraliaName) {
                receiverPageNotifier.selectedReceiverBank = selection;
                var value = receiverPageNotifier.receiverBankAccounts
                    .indexOf(selection);
                receiverPageNotifier.selectedBankReceiverId =
                    receiverPageNotifier.receiverBankId[value];
                receiverPageNotifier.receiverAccountNumberData =
                    receiverPageNotifier.receiverBankAccountNumber[value];
                receiverPageNotifier.receiverNameData =
                    receiverPageNotifier.receiverName[value];
              } else {
                receiverPageNotifier.selectedReceiverBank = selection;
                var value = receiverPageNotifier.receiverBankAccounts
                    .indexOf(selection);
                receiverPageNotifier.selectedBankReceiverId =
                    receiverPageNotifier.receiverBankId[value];
              }
            }, onSubmitted: (selection) {
              handleInteraction(context);
              if (receiverPageNotifier.countryData == AppConstants.AustraliaName) {
                receiverPageNotifier.selectedReceiverBank = selection;
                var value = receiverPageNotifier.receiverBankAccounts
                    .indexOf(selection);
                receiverPageNotifier.selectedBankReceiverId =
                    receiverPageNotifier.receiverBankId[value];
                receiverPageNotifier.receiverAccountNumberData =
                    receiverPageNotifier.receiverBankAccountNumber[value];
                receiverPageNotifier.receiverNameData =
                    receiverPageNotifier.receiverName[value];
              } else {
                receiverPageNotifier.selectedReceiverBank = selection;
                var value = receiverPageNotifier.receiverBankAccounts
                    .indexOf(selection);
                receiverPageNotifier.selectedBankReceiverId =
                    receiverPageNotifier.receiverBankId[value];
              }
            },
                controller:
                    receiverPageNotifier.selectedReceiverBankController,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Select bank account';
            }
            return null;
          },
        ));
  }
}
