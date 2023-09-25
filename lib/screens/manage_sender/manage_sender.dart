import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/sender_repository.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/save_sender_request.dart';
import 'package:singx/core/models/request_response/manage_sender/AddSenderAccountRequest.dart';
import 'package:singx/core/notifier/manage_sender_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher.dart';

SenderRepository senderRepository = SenderRepository();

class ManageSender extends StatelessWidget {
  final bool? navigateData;
  final bool? isSenderPopUpEnabled;
  final bool? isWalletPopUpEnabled;

  ManageSender(
      {Key? key,
      this.navigateData,
      this.isSenderPopUpEnabled = false,
      this.isWalletPopUpEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          ManageSenderNotifier(context, navigateData: navigateData!),
      child: Consumer<ManageSenderNotifier>(builder: (context, notifier, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.commonWidth = kIsWeb ? isMobile(context) ||
                  isTab(context) ||
                  getScreenWidth(context) > 800 &&
                      getScreenWidth(context) < 1100
              ? getScreenWidth(context)
              : isSenderPopUpEnabled! || isWalletPopUpEnabled!
                  ? getScreenWidth(context) / 2
                  : getScreenWidth(context) / 3 : screenSizeWidth <= 570 || screenSizeWidth > 570 && screenSizeWidth <= 800 ||
              screenSizeWidth > 800 &&
                  screenSizeWidth < 1100
              ? screenSizeWidth
              : isSenderPopUpEnabled! || isWalletPopUpEnabled!
              ? screenSizeWidth / 2
              : screenSizeWidth / 3;

          dynamicFields(notifier, context);
        });
        return AppInActiveCheck(
          context: context,
          child: Scaffold(
            backgroundColor: white,
            appBar: isSenderPopUpEnabled! || isWalletPopUpEnabled!
                ? null
                : PreferredSize(
                    preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                    child: Container(
                        color: greyShade50,
                        child: buildCustomAppBar(context, notifier)),
                  ),
            body: notifier.isAddSender
                ? GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                          thumbColor:
                          MaterialStateProperty.all(greyShade400),
                      )
                  ),
                  child: Scrollbar(
                    controller: notifier.scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: kIsWeb ? getScreenWidth(context) < 430 ? AppConstants.zero : AppConstants.five : screenSizeWidth < 430 ? AppConstants.zero : AppConstants.five,right: AppConstants.six),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonSizedBoxHeight20(context),
                          buildAddYourBankAccountText(context),
                          commonSizedBoxHeight20(context),
                          Padding(
                            padding: px16DimenHorizontal(context),
                            child: Divider(),
                          ),
                          notifier.countryName == AppConstants.AustraliaName
                              ? buildSenderTextFieldsAus(notifier, context)
                              : buildSenderTextFields(notifier, context),
                        ],
                      ),
                    ),
                  ),
                ),)
                : Padding(
                    padding: EdgeInsets.only(
                        left: kIsWeb ? getScreenWidth(context) < 400 ? AppConstants.zero : AppConstants.five : screenSizeWidth < 400 ? AppConstants.zero : AppConstants.five),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonSizedBoxHeight20(context),
                        buildHelpLinkAndButton(notifier, context),
                        commonSizedBoxHeight20(context),
                        notifier.countryName == AppConstants.australia
                            ? Expanded(
                                child: buildSenderListAus(notifier, context))
                            : Expanded(
                                child: buildSenderList(notifier, context))
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }

  // Dynamic text fields
  dynamicFields(ManageSenderNotifier notifier, context) async {
    notifier.children.clear();

    for (int i = 0; i < notifier.senderDynamicFields.length; i++) {
      if (notifier.senderDynamicFields[i].fieldType == "select" &&
          notifier.senderDynamicFields[i].label == "Account currency" &&
          notifier.countryName == AppConstants.hongKong) {
      } else if (notifier.senderDynamicFields[i].fieldType == "" ||
          notifier.senderDynamicFields[i].fieldType == "string" ||
          notifier.senderDynamicFields[i].fieldType == "numeric") {

        // If field type is string then it is TextField
        notifier.finalData.add(notifier.senderDynamicFields[i].field);

        // Adding text field in children list
        notifier.children.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxHeight10(context),
              buildText(text: notifier.senderDynamicFields[i].label),
              sizedBoxHeight10(context),
              CommonTextField(
                maxHeight: AppConstants.fifty,
                width: notifier.commonWidth,
                onChanged: (val) {
                  notifier.saveApiErrorMessage = '';
                  handleInteraction(context);
                  notifier.finalData[i] = val;
                  if (notifier.senderDynamicFields[i].label == "Account Number") {
                    notifier.accountNumberController.text = val;
                  } else if (notifier.senderDynamicFields[i].label == "Account Holder Name") {
                    notifier.accountHolderNameController.text = val;
                  }
                },
                suffixIcon:
                notifier.senderDynamicFields[i].label == "Account Number"
                    ? Padding(
                  padding: EdgeInsets.fromLTRB(AppConstants.eighteen, AppConstants.zero, AppConstants.sixteen, AppConstants.zero),
                  child: Tooltip(
                    message: AppConstants.onlyNumeric,
                    child: Icon(Icons.info),
                  ),
                )
                    : null,
                hintText: notifier.senderDynamicFields[i].label,
                inputFormatters:
                notifier.senderDynamicFields[i].label == "Account Number" &&
                    notifier.countryName == AppConstants.hongKong
                    ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ]
                    : [],
                validatorEmptyErrorText:
                notifier.senderDynamicFields[i].required == true
                    ? notifier.senderDynamicFields[i].label == "Account Holder Name"
                    ? AppConstants.enterName
                    : notifier.senderDynamicFields[i].label == "Account currency"
                    ? AppConstants.accountCurrencyCannotBlank
                    : notifier.senderDynamicFields[i].label == "Account Number"
                    ? AppConstants.accountNumberCannotBlank
                    : AppConstants.fieldRequired
                    : '',
              ),
              sizedBoxHeight10(context)
            ],
          ),
        );
      } else if (notifier.senderDynamicFields[i].fieldType == "select") {
        List<String>? displayNameList;

        // If field type is select then it is Dropdown
        if (notifier.senderDynamicFields[i] != null &&
            notifier.senderDynamicFields[i].map != null) {
          displayNameList = <String>[];
          for (int arrIndex = 0;
          arrIndex < notifier.senderDynamicFields[i].map.length;
          arrIndex++) {
            displayNameList
                .add(notifier.senderDynamicFields[i].map[arrIndex].name);
          }
        }
        notifier.finalData.add(notifier.senderDynamicFields[i].field);

        // Adding dropdown field in children list
        notifier.children.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxHeight10(context),
              buildText(text: notifier.senderDynamicFields[i].label),
              sizedBoxHeight10(context),
              Consumer<ManageSenderNotifier>(
                builder: (context, notifier, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      List<String> dropDownData = notifier.countryData ==
                          AppConstants.HongKongName
                          ? displayNameList
                          : notifier.senderDynamicFields[i].label == "Bank Name"
                          ? notifier.currencyName == "SGD"
                          ? notifier.bankNameListSGD
                          : notifier.bankNameListUSD
                          : notifier.senderDynamicFields[i].options != null
                          ? notifier.senderDynamicFields[i].options
                          : [];
                      return CustomizeDropdown(context,
                          dropdownItems: dropDownData, optionsViewBuilder:
                              (BuildContext context,
                              AutocompleteOnSelected onSelected,
                              Iterable options) {
                            return buildDropDownContainer(
                              context,
                              options: options,
                              onSelected: onSelected,
                              dropdownData: dropDownData,
                              dropDownWidth: getScreenWidth(context) > 1100 &&
                                  !isSenderPopUpEnabled! &&
                                  !isWalletPopUpEnabled!
                                  ? notifier.commonWidth
                                  : constraints.biggest.width,
                              dropDownHeight: options.first == 'No Data Found'
                                  ? AppConstants.oneHundredFifty
                                  : options.length < 7
                                  ? options.length * 55
                                  : AppConstants.twoHundred,
                            );
                          }, onSelected: (sel) async {
                            handleInteraction(context);
                            notifier.finalData[i] = sel;
                            notifier.saveApiErrorMessage = '';
                            if (notifier.senderDynamicFields[i].label ==
                                "Account currency") {
                              notifier.currencyName = sel;
                              notifier.currencySGController.text = sel;
                              notifier.bankNameController.clear();
                              if (sel == "SGD") {
                                notifier.senderFields(
                                    context: context, getCurrency: "SGD");
                              } else {
                                notifier.senderFields(
                                    context: context, getCurrency: "USD");
                              }
                              apiLoader(context);
                              Future.delayed(Duration(seconds: 3))
                                  .then((value) => Navigator.pop(context));
                            } else if (notifier.senderDynamicFields[i].label ==
                                "Bank Name") {
                              notifier.bankName = sel;
                              if (sel == "Others") {
                                notifier.isOthersFieldVisible = true;
                              } else {
                                notifier.isOthersFieldVisible = false;
                              }
                            }
                            if (notifier.senderDynamicFields[i].label ==
                                "Account currency" &&
                                notifier.countryName == AppConstants.singapore) {}
                          }, onSubmitted: (sel) async {
                            handleInteraction(context);
                            notifier.finalData[i] = sel;
                            notifier.saveApiErrorMessage = '';
                            if (notifier.senderDynamicFields[i].label ==
                                "Account currency") {
                              notifier.currencyName = sel;
                              notifier.currencySGController.text = sel;
                              if (sel == "SGD") {
                                notifier.senderFields(
                                    context: context, getCurrency: "SGD");
                              } else {
                                notifier.senderFields(
                                    context: context, getCurrency: "USD");
                              }
                              apiLoader(context);
                              Future.delayed(Duration(seconds: 3))
                                  .then((value) => Navigator.pop(context));
                            } else if (notifier.senderDynamicFields[i].label ==
                                "Bank Name") {
                              notifier.bankName = sel;
                              if (sel == "Others") {
                                notifier.isOthersFieldVisible = true;
                              } else {
                                notifier.isOthersFieldVisible = false;
                              }
                            }
                            if (notifier.senderDynamicFields[i].label ==
                                "Account currency" &&
                                notifier.countryName == AppConstants.singapore) {}
                          },
                          hintText: notifier.senderDynamicFields[i].label,
                          width: notifier.commonWidth,
                          controller: notifier.senderDynamicFields[i].label ==
                              "Account currency"
                              ? notifier.currencySGController
                              : notifier.bankNameController,
                          validation: notifier.senderDynamicFields[i].label ==
                              "Bank Name"
                              ? (val) {
                            if (val!.isEmpty || val == null) {
                              return AppConstants.selectBank;
                            }
                          }
                              : notifier.senderDynamicFields[i].label ==
                              "Account currency"
                              ? (val) {
                            if (val!.isEmpty || val == null) {
                              return AppConstants.selectAccountCurrency;
                            }
                          }
                              : null);
                    },
                  );
                },
              ),
              sizedBoxHeight10(context)
            ],
          ),
        );
        notifier.children.add(
          Consumer<ManageSenderNotifier>(
            builder: (context, notifier, child) {
              return Visibility(
                visible: notifier.isOthersFieldVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxHeight10(context),
                    buildText(text: AppConstants.otherBankName),
                    sizedBoxHeight10(context),
                    Consumer<ManageSenderNotifier>(
                      builder: (context, notifier, child) {
                        return CommonTextField(
                          maxHeight: AppConstants.fifty,
                          width: notifier.commonWidth,
                          onChanged: (val) {
                            handleInteraction(context);
                            notifier.finalData[i] = val;
                            notifier.otherBankNameController.text = val;
                          },
                          hintText: AppConstants.otherBankName,
                          validatorEmptyErrorText: AppConstants.fieldRequired,
                        );
                      },
                    ),
                    sizedBoxHeight10(context)
                  ],
                ),
              );
            },
          ),
        );
      } else if (notifier.senderDynamicFields[i].fieldType == 'checkbox') {

        // If field type is checkbox then it is checkbox

        // Adding checkbox field in children list
        notifier.children.add(Column(
          children: [
            sizedBoxHeight5(context),
            Row(children: [
              Consumer<ManageSenderNotifier>(
                  builder: (context, notifier, child) {
                    return Padding(
                      padding: px10OnlyRight(context),
                      child: SizedBox(
                        height: AppConstants.twentyTwo,
                        width: AppConstants.twentyTwo,
                        child: Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppConstants.five),
                              ),
                            ),
                          ),
                          child: Checkbox(
                            side: BorderSide(width: 1, color: checkBoxBorderColor),
                            visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                            value: notifier.isJointAccount,
                            onChanged: (bool? value) {
                              notifier.isJointAccount = !notifier.isJointAccount;
                            },
                          ),
                        ),
                      ),
                    );
                  }),
              GestureDetector(
                  onTap: () =>
                  notifier.isJointAccount = !notifier.isJointAccount,
                  child: buildText(text: notifier.senderDynamicFields[i].label))
            ]),
            sizedBoxHeight5(context)
          ],
        ));
        notifier.children.add(
            Consumer<ManageSenderNotifier>(builder: (context, notifier, child) {
              return Visibility(
                  visible: notifier.isJointAccount,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxHeight10(context),
                      buildText(text: AppConstants.jointAccountName),
                      sizedBoxHeight10(context),
                      CommonTextField(
                        width: notifier.commonWidth,
                        onChanged: (val) {
                          handleInteraction(context);
                          notifier.finalData[i] = val;
                          notifier.jointAccountNameController.text = val;
                        },
                        hintText: AppConstants.jointAccountName,
                        validatorEmptyErrorText:
                        notifier.isJointAccount == true ? AppConstants.jointAccountCannotBlank  : '',
                      ),
                      sizedBoxHeight10(context)
                    ],
                  ));
            }));
      } else {
        notifier.children.add(new ListTile(title: Text(i.toString())));
      }
    }
  }

  // help link to edit or bank delete account
  Widget helpLink(BuildContext context, ManageSenderNotifier notifier) {
    return Padding(
      padding: px16DimenLeftOnly(context),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: S.of(context).editOrDeleteBankAccount,
                style: textSpan1(context)),
            TextSpan(
                mouseCursor: SystemMouseCursors.click,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    String email = notifier.countryData == AppConstants.australia ? Uri.encodeComponent("help.au@singx.co") :Uri.encodeComponent(S.of(context).helpSingX);
                    String subject = Uri.encodeComponent("Subject");
                    String body = Uri.encodeComponent("Content");
                    Uri mail =
                        Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  },
                text: notifier.countryData == AppConstants.australia ? "help.au@singx.co"  :S.of(context).helpSingX,
                style: textSpan2Bold(context)),
          ],
        ),
      ),
    );
  }

  // AppBar
  Widget buildCustomAppBar(
      BuildContext context, ManageSenderNotifier notifier) {
    return Padding(
      padding: kIsWeb ? isMobile(context) || isTab(context)
          ? px15DimenTop(context)
          : px30DimenTopOnly(context) : screenSizeWidth <= 570 || screenSizeWidth > 570 && screenSizeWidth <= 800
          ? px15DimenTop(context)
          : px30DimenTopOnly(context),
      child: buildAppBar(
          context,
          notifier.isAddSender == false
              ? IgnorePointer(
                ignoring: (getScreenWidth(context) > 500),
                child: Tooltip(triggerMode: TooltipTriggerMode.tap,
                  message: S.of(context).manageSenders,
                child:
                Text(S.of(context).manageSenders,overflow: TextOverflow.clip,
                    style: appBarWelcomeText(context)),
              ))
              : kIsWeb ? getScreenWidth(context) > 470
                  ? Text.rich(
                    overflow: TextOverflow.clip,
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                        text: S.of(context).manageSendersOr,
                        style: appBarWelcomeText(context).copyWith(
                            color: oxfordBlueTint400,
                            overflow: TextOverflow.clip,
                            fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen : screenSizeWidth <= 570 ? getScreenWidth(context) < 450 ?AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                        children: <TextSpan>[
                          TextSpan(
                            text: S.of(context).OrAddYourAccount,
                            style: appBarWelcomeText(context).copyWith(
                                color: oxfordBlueTint400,
                                overflow: TextOverflow.clip,
                                fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen : screenSizeWidth <= 570 ? getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                          ),
                        ],
                      ),
                    )
                  : Tooltip(
                    message:S.of(context).manageSendersOr + S.of(context).OrAddYourAccount,
                    child: Text.rich(overflow: TextOverflow.clip,
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                          text: S.of(context).manageSendersOr,
                          style: appBarWelcomeText(context).copyWith(overflow: TextOverflow.clip,
                              color: oxfordBlueTint400,
                              fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen : screenSizeWidth <= 570 ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\n' + S.of(context).OrAddYourAccount,
                              style: appBarWelcomeText(context).copyWith(
                                  overflow: TextOverflow.clip,
                                  color: oxfordBlueTint400,
                                  fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen : screenSizeWidth <= 570 ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                            ),
                          ],
                        ),
                      ),
                  ) : screenSizeWidth > 470
              ? Text.rich(
            overflow: TextOverflow.clip,
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
              text: S.of(context).manageSendersOr,
              style: appBarWelcomeText(context).copyWith(
                  color: oxfordBlueTint400,
                  overflow: TextOverflow.clip,
                  fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen: screenSizeWidth <= 570 ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
              children: <TextSpan>[
                TextSpan(
                  text: S.of(context).OrAddYourAccount,
                  style: appBarWelcomeText(context).copyWith(
                      overflow: TextOverflow.clip,
                      color: oxfordBlueTint400,
                      fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen: screenSizeWidth <= 570 ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                ),
              ],
            ),
          )
              : Tooltip(
                message:S.of(context).manageSendersOr + S.of(context).OrAddYourAccount,
                child: Text.rich(
            overflow: TextOverflow.clip,
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context);
                  },
                text: S.of(context).manageSendersOr,
                style: appBarWelcomeText(context).copyWith(
                    color: oxfordBlueTint400,
                    overflow: TextOverflow.clip,
                    fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen: screenSizeWidth <= 570 ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n' + S.of(context).OrAddYourAccount,
                    style: appBarWelcomeText(context).copyWith(
                        color: oxfordBlueTint400,
                        overflow: TextOverflow.clip,
                        fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen: screenSizeWidth <= 570 ? getScreenWidth(context) < 350 ? AppConstants.thirteen :getScreenWidth(context) < 450 ? AppConstants.fifteen : AppConstants.sixteen : AppConstants.sixteen),
                  ),
                ],
            ),
          ),
              ),
          isVisible: kIsWeb ? notifier.isAddSender && getScreenWidth(context) < 360 : notifier.isAddSender && screenSizeWidth < 360,
          backCondition: notifier.isAddSender == false
              ? null
              : () {
                  Navigator.pop(context);
                },
          from: "sender"),
    );
  }

  // adding your bank account label
  Widget buildAddYourBankAccountText(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: isSenderPopUpEnabled! || isWalletPopUpEnabled!
                ? EdgeInsets.symmetric(horizontal: 8)
                : px16DimenHorizontal(context),
            child: buildText(
                text: S.of(context).addYourBankAccount,
                fontSize: AppConstants.twenty,
                fontWeight: FontWeight.w700),
          ),
        ),
        Visibility(
            visible: isSenderPopUpEnabled! || isWalletPopUpEnabled!,
            child: Padding(
              padding: EdgeInsets.only(right: kIsWeb ? isMobile(context) ? AppConstants.zero : AppConstants.sixteen : screenSizeWidth <= 570 ? AppConstants.zero : AppConstants.sixteen),
              child: CloseButton(onPressed: () => Navigator.pop(context)),
            ))
      ],
    );
  }

  // helpLink and sender button
  Widget buildHelpLinkAndButton(
      ManageSenderNotifier notifier, BuildContext context) {
    return Padding(
      padding: px16DimenHorizontal(context),
      child: getScreenWidth(context) < 680
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                helpLink(context,notifier),
                SizedBoxHeight(context, 0.02),
                Align(
                    alignment: Alignment.topRight,
                    child: buildAddSenderButton(notifier, context)),
              ],
            )
          : Row(
              children: [
                helpLink(context,notifier),
                Spacer(),
                buildAddSenderButton(notifier, context),
              ],
            ),
    );
  }

  // adding a new sender button
  Widget buildAddSenderButton(
      ManageSenderNotifier notifier, BuildContext context) {
    return buildButton(
      context,
      width: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.90
          : isMobile(context) || isTab(context)
              ? AppConstants.oneHundredEighty
              : AppConstants.twoHundredAndSeventy,
      name: S.of(context).addNewSenderWeb,
      color: hanBlue,
      fontColor: Color(0xffFFFFFF),
      onPressed: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(AppConstants.country)
            .then((value) async {
          Navigator.pushNamed(context, manageSenderNewRoute);
        });
      },
    );
  }

  // Sender TextFields for SG and HK
  Widget buildSenderTextFields(
      ManageSenderNotifier notifier, BuildContext context) {
    return Expanded(
        child: notifier.children.isNotEmpty
            ? ListView(
          controller: notifier.scrollController,
          scrollDirection: Axis.vertical,
                children: [
                  Form(
                      key: notifier.manageSenderKey,
                      child: Padding(
                        padding: isSenderPopUpEnabled! || isWalletPopUpEnabled!
                            ? EdgeInsets.only(left: 8, right: 20)
                            : EdgeInsets.symmetric(
                                horizontal: kIsWeb ? isMobile(context) || isTab(context)
                                    ? getScreenWidth(context) / 10
                                    : getScreenWidth(context) / 4.5 : screenSizeWidth <= 570 || screenSizeWidth > 570 && screenSizeWidth <= 800 ? screenSizeWidth / 10 : screenSizeWidth / 4.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            isSenderPopUpEnabled! || isWalletPopUpEnabled!
                                ? SizedBox(height: 0)
                                : commonSizedBoxHeight50(context),
                            buildText(
                                text: AppConstants.senderAddInfo,
                                fontWeight: FontWeight.w400,
                                fontColor: oxfordBlueTint400),
                             Visibility(
                               visible: notifier.countryName == AppConstants.hongKong,
                               child:  Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 commonSizedBoxHeight10(context),
                                 buildHeaderText(text: S.of(context).currencyWeb),
                                 commonSizedBoxHeight10(context),
                                 CommonTextField(
                                   onChanged: (val){
                                     handleInteraction(context);
                                   },
                                   controller: notifier.currencyController,
                                   readOnly: true,
                                   width: notifier.commonWidth,
                                 ),
                               ],),),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: notifier.children,
                            ),
                            sizedBoxHeight5(context),
                            Visibility(
                                child: Column(
                                  children: [
                                    Text(
                                        notifier.saveApiErrorMessage,style: TextStyle(color: errorTextField,
                                        fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500)),
                                    commonSizedBoxHeight20(context),
                                  ],
                                ),
                                visible: notifier.saveApiErrorMessage != ''),
                            isSenderPopUpEnabled! || isWalletPopUpEnabled!
                                ? commonSizedBoxHeight30(context)
                                : commonSizedBoxHeight50(context),
                            Container(
                              width: notifier.commonWidth,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: buildButton(
                                      context,
                                      name: S.of(context).cancel,
                                      fontColor: hanBlue,
                                      color: hanBlueTint200,
                                      onPressed: () {
                                        notifier.makeSGFieldEmpty();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  commonSizedBoxWidth20(context),

                                  Expanded(
                                      child: buildButton(
                                    context,
                                    name: S.of(context).save,
                                    fontColor: white,
                                    color: hanBlue,
                                    onPressed: () async {
                                      if (notifier.manageSenderKey.currentState!.validate()) {
                                        addingSenderAlert(context,
                                            onPressed: () async {
                                          Navigator.pop(context);

                                          bool status = await notifier.senderRepository?.addSenderSG(
                                                  context,
                                                  AddSenderAccountRequest(
                                                      accountNumber: notifier
                                                          .accountNumberController
                                                          .text,
                                                      firstName: notifier
                                                          .accountHolderNameController
                                                          .text,
                                                      jointAccount:
                                                          notifier.isJointAccount == true
                                                              ? "true"
                                                              : "false",
                                                      jointAccHolderName: notifier
                                                          .jointAccountNameController
                                                          .text,
                                                      bankName:
                                                          notifier.bankName,
                                                      sendCurrency: notifier.country_ == AppConstants.hongKong
                                                          ? notifier
                                                              .currencyController
                                                              .text
                                                          : notifier
                                                              .currencySGController.text,otherBankName : notifier.otherBankNameController.text),
                                                  isSenderPopUpEnabled:
                                                      isSenderPopUpEnabled!,
                                                  isWalletPopUpEnabled:
                                                      isWalletPopUpEnabled!).then((value) {
                                                        final result = json.decode(value.toString());
                                                        if(result['success'] == false){
                                                          notifier.saveApiErrorMessage = result['errors'][0] ?? AppConstants.somethingWentWrongMessage;
                                                        }
                                          }) ??
                                              false;
                                        });
                                      } else {
                                      }
                                    },
                                  ))
                                ],
                              ),
                            ),
                            commonSizedBoxHeight50(context),
                          ],
                        ),
                      )),
                ],
              )
            : Center(
                child: defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator(
                        radius: 30,
                      )
                    : CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
              ));
  }

  // Sender List for SG and HK
  Widget buildSenderList(
      ManageSenderNotifier notifier, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getScreenWidth(context) < 400
          ? AppConstants.zero
          : AppConstants.eight),
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              notifier.contentList.length > 0
                  ? loadListView(context, notifier)
                  : Center(
                      child: Text(
                      "No Data Found",
                      style: TextStyle(fontSize: AppConstants.eighteen),
                    )),
              if (notifier.showLoadingIndicator)
                Center(
                  child: Container(
                    color: Colors.transparent,
                    width: AppConstants.forty,
                    height: AppConstants.forty,
                    child: Align(
                      alignment: Alignment.center,
                      child: defaultTargetPlatform == TargetPlatform.iOS
                          ? CupertinoActivityIndicator(
                              radius: AppConstants.thirty,
                            )
                          : CircularProgressIndicator(
                              strokeWidth: AppConstants.three,
                            ),
                    ),
                  ),
                )
            ],
          )),
          buildNavigationListRow(context,notifier)
        ],
      ),
    );
  }

  // Pagination
  Widget buildNavigationListRow(BuildContext context, ManageSenderNotifier notifier) {
    return Column(
      children: [
        Visibility(
          visible: notifier.pageCount != 0,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      buildPagination(
                          context: context,
                          iconData: Icons.first_page,
                          isIcon: true,
                          buttonFunction: () {
                            if (notifier.pageIndex == 1) return;
                            notifier.pageIndex = 1;
                            notifier.paginationScrollController.position
                                .animateTo(
                                    notifier.paginationScrollController.position
                                        .minScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeOut);
                            onPaginated(context, notifier);
                          }),
                      sizedBoxWidth5(context),
                      buildPagination(
                          context: context,
                          iconData: Icons.keyboard_arrow_left,
                          isIcon: true,
                          buttonFunction: () {
                            if (notifier.pageIndex! <= 1) return;
                            notifier.pageIndex = (notifier.pageIndex! - 1);
                            notifier.paginationScrollController.position.jumpTo(
                                notifier.paginationScrollController.offset -
                                    AppConstants.forty);
                            onPaginated(context, notifier);
                          }),
                      SizedBox(
                        height: AppConstants.thirtyFive,
                        width: (getScreenWidth(context) < 310 ||
                                notifier.pageCount <= 1)
                            ? AppConstants.forty
                            : (getScreenWidth(context) < 350 ||
                                    notifier.pageCount <= 2)
                                ? AppConstants.eighty
                                : AppConstants.oneHundredAndTwenty,
                        child: Center(
                          child: ListView.builder(
                              controller: notifier.paginationScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: notifier.pageCount,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: buildPagination(
                                      context: context,
                                      isIcon: false,
                                      selectedPageCount: notifier.pageIndex,
                                      pageCount: (index + 1).toString(),
                                      buttonFunction: () {
                                        notifier.pageIndex = index + 1;
                                        onPaginated(context, notifier);
                                      }),
                                );
                              }),
                        ),
                      ),
                      sizedBoxWidth5(context),
                      buildPagination(
                          context: context,
                          iconData: Icons.keyboard_arrow_right,
                          isIcon: true,
                          buttonFunction: () {
                            if (notifier.pageIndex! >= notifier.pageCount)
                              return;
                            notifier.pageIndex = (notifier.pageIndex! + 1);
                            notifier.paginationScrollController.position.jumpTo(
                                notifier.paginationScrollController.offset +
                                    AppConstants.forty);
                            onPaginated(context, notifier);
                          }),
                      sizedBoxWidth5(context),
                      buildPagination(
                          context: context,
                          iconData: Icons.last_page,
                          isIcon: true,
                          buttonFunction: () {
                            if (notifier.pageIndex == notifier.pageCount)
                              return;
                            notifier.pageIndex = notifier.pageCount;
                            notifier.paginationScrollController.position
                                .animateTo(
                                    notifier.paginationScrollController.position
                                        .maxScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeIn);
                            onPaginated(context, notifier);
                          }),
                    ],
                  ),
                  if (getScreenWidth(context) > 500)
                    Text(
                        '${notifier.pageIndex!} ${"of"} ${notifier.pageCount} '
                        '${"pages"}',
                        style: blackTextStyle16(context)
                          ..copyWith(
                            fontSize: notifier.pageIndex! > 9 ||
                                    notifier.pageCount > 100
                                ? 13
                                : 16,
                          ))
                ],
              )),
        ),
        sizedBoxHeight10(context),
        if(getScreenWidth(context)<500)Align(
          alignment: Alignment.centerRight,
          child: Text(
              '${notifier.pageIndex!} ${"of"} ${notifier.pageCount} '
                  '${"pages"}',
              style: blackTextStyle16(context)..copyWith(fontSize: notifier.pageIndex! > 9 || notifier.pageCount > 100 ?13:16,)
          ),
        )
      ],
    );
  }

  // Sender List for AU
  Widget buildSenderListAus(
      ManageSenderNotifier notifier, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getScreenWidth(context) < 400
          ? AppConstants.zero
          : AppConstants.eight),
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: ThemeData().copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(
                          Colors.grey.shade400))),
              child: Padding(
                padding: EdgeInsets.all(getScreenWidth(context) < 400
                    ? AppConstants.zero
                    : AppConstants.eight),
                child: Container(
                  height: getScreenHeight(context) / 1.5,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var accountNumber =
                            notifier.contentListAus[index].accountNumber;
                        var data = notifier
                            .contentListAus[index].accountNumber!.length <= 4?accountNumber:accountNumber!
                            .substring(accountNumber.length - 4);
                        return Padding(
                          padding: EdgeInsets.all(AppConstants.eight),
                          child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: notifier.isExpanded[index]
                                      ? [
                                    BoxShadow(
                                      color: listTileexpansionColor
                                          .withOpacity(0.10),
                                      blurRadius:
                                      AppConstants.thirty,
                                      offset: Offset(AppConstants.zero, AppConstants.fifteen),
                                    ),
                                  ]
                                      : [],
                                  borderRadius: radiusAll8(context),
                                  color: white,
                                  border: Border.all(
                                      color: dividercolor,
                                      width: AppConstants.one)),
                              child: expansionTileContainer(
                                context,
                                isSender: true,
                                name: notifier
                                    .contentListPaginatedAus[index].firstName,
                                bankDetails: 'AUD account ending $data',
                                onExpansionChanged: (val) {
                                  notifier.isExpanded[index] = val;
                                },
                                accountHolderName: notifier
                                    .contentListPaginatedAus[index].firstName,
                                Country: "Australia",
                                currency: 'AUD',
                                bankName: notifier
                                    .contentListPaginatedAus[index].bankName,
                                accountNumber: notifier
                                    .contentListPaginatedAus[index].accountNumber,
                                trailing: AnimatedRotation(
                                  turns: notifier.isExpanded[index]
                                      ? 0.5
                                      : 0.0,
                                  duration: Duration(
                                      milliseconds:
                                      AppConstants.twoHundredInt),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: AppConstants.twoDouble, top: AppConstants.ten),
                                    child: Image.asset(
                                        AppImages.dropDownImage,
                                        height: AppConstants.twentyFour,
                                        width: AppConstants.twentyFour),
                                  ),
                                ),
                              )),
                        );
                      },
                      itemCount: notifier.contentListPaginatedAus.length,
                    ),
                  ),
                ),
              ),
            ),
          ),
          buildNavigationListRow(context, notifier)
        ],
      ),
    );
  }

  // Sender list view
  Widget loadListView(
      BuildContext context, ManageSenderNotifier manageSenderNotifier) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];
      if (manageSenderNotifier.contentList.isNotEmpty) {
        stackChildren.add(
          Scrollbar(
              controller: manageSenderNotifier.senderDetailsController,
              thumbVisibility: true,
              child: (ListView.custom(
                controller: manageSenderNotifier.senderDetailsController,
                childrenDelegate:
                    CustomSliverChildBuilderDelegateSender(indexBuilder),
              ))),
        );
      }

      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }

  Widget indexBuilder(BuildContext context, int index) {
    return Consumer<ManageSenderNotifier>(
        builder: (context, manageSenderNotifier, _) {
      var accountNumber = manageSenderNotifier.contentList[index].accountNumber;
      var data = accountNumber!.substring(accountNumber.length - 4);
      var countryCode =
          manageSenderNotifier.contentList[index].country == 'Singapore'
              ? 'SGD'
              : 'USD';
      return Padding(
        padding: EdgeInsets.all(AppConstants.eight),
        child: Container(
            decoration: BoxDecoration(
                boxShadow: manageSenderNotifier.isExpanded[index]
                    ? [
                        BoxShadow(
                          color: listTileexpansionColor.withOpacity(0.10),
                          blurRadius: AppConstants.thirty,
                          offset: Offset(AppConstants.zero, AppConstants.fifteen),
                        ),
                      ]
                    : [],
                borderRadius: radiusAll8(context),
                color: white,
                border:
                    Border.all(color: dividercolor, width: AppConstants.one)),
            child: expansionTileContainer(
              context,
              isSender: true,
              name: manageSenderNotifier.contentList[index].name,
              bankDetails:
                  manageSenderNotifier.countryData == AppConstants.hongKong
                      ? 'HKD account ending with $data'
                      : '$countryCode account ending with $data',
              onExpansionChanged: (val) {
                manageSenderNotifier.isExpanded[index] = val;
              },
              accountHolderName: manageSenderNotifier.contentList[index].name,
              Country: manageSenderNotifier.contentList[index].country,
              currency: manageSenderNotifier.countryName == AppConstants.HongKongName
                  ? 'HKD'
                  : countryCode,
              bankName: manageSenderNotifier.contentList[index].bankName,
              accountNumber:
                  manageSenderNotifier.contentList[index].accountNumber,
              trailing: AnimatedRotation(
                turns: manageSenderNotifier.isExpanded[index] ? 0.5 : 0.0,
                duration: Duration(milliseconds: AppConstants.twoHundredInt),
                child: Padding(
                  padding: EdgeInsets.only(right: AppConstants.twoDouble, top: AppConstants.ten),
                  child: Image.asset(AppImages.dropDownImage,
                      height: AppConstants.twentyFour,
                      width: AppConstants.twentyFour),
                ),
              ),
            )),
      );
    });
  }

  // Sender TextFields for AU
  Widget buildSenderTextFieldsAus(
      ManageSenderNotifier notifier, BuildContext context,
      {bool? isPopUp}) {
    var senderRepo = notifier.senderRepository;
    return isPopUp == true
        ? buildSenderFields(notifier, context, true, senderRepo)
        : Expanded(
            child: buildSenderFields(notifier, context, false, senderRepo));
  }

  // Sender Form for AU
  Widget buildSenderFields(ManageSenderNotifier notifier, BuildContext context,
      bool isPopUp, senderRepo) {
    return ListView(
      controller: notifier.scrollController,
      scrollDirection: Axis.vertical,
      children: [
        Form(
            key: notifier.manageSenderKey,
            child: Padding(
              padding: isSenderPopUpEnabled! || isWalletPopUpEnabled!
                  ? EdgeInsets.only(left: AppConstants.twoDouble, right: AppConstants.twenty)
                  : EdgeInsets.symmetric(
                      horizontal: kIsWeb ? isMobile(context) || isTab(context)
                          ? getScreenWidth(context) / 10
                          : getScreenWidth(context) / 4.5 : screenSizeWidth <= 570 || screenSizeWidth > 570 && screenSizeWidth <= 800 ? screenSizeWidth / 10 : screenSizeWidth / 4.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isSenderPopUpEnabled! || isWalletPopUpEnabled!
                      ? SizedBox(height: 0)
                      : commonSizedBoxHeight50(context),
                  Visibility(
                    visible: isPopUp,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 8,
                                child: buildText(
                                  text: S.of(context).addYourBankAccount,
                                  fontWeight: FontWeight.w700,
                                  fontSize: kIsWeb ? getScreenWidth(context) <= 440
                                      ? AppConstants.sixteen
                                      : AppConstants.twentyFour : screenSizeWidth <= 440 ? AppConstants.sixteen : AppConstants.twentyFour,
                                )),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon:  Icon(
                                  Icons.close,
                                  size: AppConstants.twenty,
                                  color: oxfordBlueTint400,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        commonSizedBoxHeight20(context),
                      ],
                    ),
                  ),
                  buildText(
                      text: S.of(context).addOnlyOneBankAccount,
                      fontWeight: FontWeight.w400,
                      fontColor: oxfordBlueTint400),
                  commonSizedBoxHeight20(context),
                  buildHeaderText(text: S.of(context).currencyWeb),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: notifier.currencyController,
                    readOnly: true,
                    width: notifier.commonWidth,
                  ),
                  commonSizedBoxHeight20(context),
                  buildHeaderText(text: S.of(context).fullNameOfAccountHolder),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: notifier.accountHolderNameController,
                    width: notifier.commonWidth,
                    keyboardType: TextInputType.text,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    validatorEmptyErrorText: 'Name is required',
                  ),
                  commonSizedBoxHeight20(context),
                  buildJointAccountTextAndCheckbox(context,
                      value: notifier.isJointAccount, onChanged: (bool? value) {
                    notifier.isJointAccount = !notifier.isJointAccount;
                  }, onTap: () {
                    notifier.isJointAccount = !notifier.isJointAccount;
                  }),
                  buildVisibilityTextField(context,
                      visible: notifier.isJointAccount,
                      jointAccountNameController:
                          notifier.jointAccountNameController,
                      width: notifier.commonWidth),
                  commonSizedBoxHeight20(context),
                  buildHeaderText(text: S.of(context).bankNameWeb),
                  commonSizedBoxHeight10(context),
                  LayoutBuilder(
                      builder: (context, constraints) => CustomizeDropdown(
                              context,
                              dropdownItems: senderRepo!.bankNames,
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected onSelected,
                                  Iterable options) {
                            return buildDropDownContainer(
                              context,
                              options: options,
                              onSelected: onSelected,
                              dropdownData: senderRepo!.bankNames,
                              dropDownWidth: kIsWeb ? getScreenWidth(context) > 1100 &&
                                      !isSenderPopUpEnabled! &&
                                      !isWalletPopUpEnabled!
                                  ? notifier.commonWidth
                                  : constraints.biggest.width : constraints.biggest.width,
                              dropDownHeight: options.first == S.of(context).noDataFound
                                  ? AppConstants.oneHundredFifty
                                  : options.length < 10
                                      ? options.length * 60
                                      : AppConstants.oneHundredEighty,
                            );
                          }, onSelected: (val) async {
                            handleInteraction(context);
                            var value =
                                senderRepo.bankNames.indexOf(val.toString());

                            notifier.bankId = senderRepo.bankId[value];

                            await senderRepo.senderBankId(
                                context, notifier.bankId);
                            notifier.branchId = senderRepo.branchId[0];
                          }, onSubmitted: (val) async {
                            handleInteraction(context);
                            var value =
                                senderRepo.bankNames.indexOf(val.toString());

                            notifier.bankId = senderRepo.bankId[value];

                            await senderRepo.senderBankId(
                                context, notifier.bankId);
                            notifier.branchId = senderRepo.branchId[0];
                          },
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return AppConstants.bankNameRequired;
                            }
                            return null;
                          },
                              controller: notifier.bankNameController,
                              width: notifier.commonWidth)),
                  commonSizedBoxHeight20(context),
                  buildHeaderText(text: 'BSB Code'),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: notifier.bsbCodeController,
                    width: notifier.commonWidth,
                    keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    validatorEmptyErrorText: AppConstants.bsbCodeRequired,
                  ),
                  commonSizedBoxHeight20(context),
                  buildHeaderText(text: S.of(context).accountNumberWeb),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: notifier.accountNumberController,
                    width: isPopUp ? 500 : notifier.commonWidth,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9-a-zA-Z]")),
                    ],
                    validatorEmptyErrorText: AppConstants.accountNumberRequired,
                  ),
                  sizedBoxHeight10(context),
                  Visibility(
                      child: Column(
                        children: [
                          Text(
                               notifier.saveApiErrorMessage,style: TextStyle(color: errorTextField,
                              fontSize: 11.5,fontWeight: FontWeight.w500)),
                          commonSizedBoxHeight20(context),
                        ],
                      ),
                      visible: notifier.saveApiErrorMessage != ''),
                  commonSizedBoxHeight50(context),
                  Container(
                    width: isPopUp ? 500 : notifier.commonWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: buildButton(
                            context,
                            name: S.of(context).cancel,
                            fontColor: hanBlue,
                            color: hanBlueTint200,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        commonSizedBoxWidth20(context),
                        Expanded(
                            child: buildButton(
                              context,
                              name: S.of(context).save,
                              fontColor: white,
                              color: hanBlue,
                              onPressed: () async {
                                if (notifier.manageSenderKey.currentState!
                                    .validate()) {
                                  addingSenderAlert(context,onPressed: () async {
                                    Navigator.pop(context);
                                    await senderRepo.senderFieldSave(
                                        SaveSenderRequest(
                                            accountNumber:
                                            notifier.accountNumberController.text,
                                            bankId: int.parse(notifier.bankId),
                                            branchId: int.parse(notifier.branchId),
                                            bsbOrAbaCode:
                                            notifier.bsbCodeController.text,
                                            contactId: notifier.contactId,
                                            countryId: notifier.countryId,
                                            firstName: notifier
                                                .accountHolderNameController.text,
                                            jointAcctHolderName: notifier
                                                .jointAccountNameController.text,
                                            createdBy: 1000000024),
                                        context, isSenderPopUpEnabled:
                                    isSenderPopUpEnabled!,
                                        isWalletPopUpEnabled:
                                        isWalletPopUpEnabled!);

                                  });
                                 } else {}
                              },
                            ))
                      ],
                    ),
                  ),
                  commonSizedBoxHeight50(context),
                ],
              ),
            ))
      ],
    );
  }

  // pagination function
  onPaginated(BuildContext context,ManageSenderNotifier manageSenderNotifier)async{

  if(manageSenderNotifier.countryData == AppConstants.AustraliaName){
    manageSenderNotifier.contentListPaginatedAus = [];
    Timer.periodic(Duration(milliseconds: 80), (timer){
      manageSenderNotifier.pageCount = (manageSenderNotifier.contentListAus.length / 10).ceil();
      int start = (manageSenderNotifier.pageIndex! -1) * 10;
      int end = start + 10;
      if (end > manageSenderNotifier.contentListAus.length) {
        end = manageSenderNotifier.contentListAus.length;
      }
      manageSenderNotifier.isExpanded = List.filled(manageSenderNotifier.contentListAus.length, false, growable: true);
      manageSenderNotifier.contentListPaginatedAus =  manageSenderNotifier.contentListAus.sublist(start, end);
      timer.cancel();
    });
  }else{
    manageSenderNotifier.url = '?page=${manageSenderNotifier.pageIndex!-1}&size=10&filter=';
    manageSenderNotifier.senderListApi(context);
    manageSenderNotifier.showLoadingIndicator = true;
  }
  }

  // sender list header label
  Widget buildHeaderText({text}) {
    return buildText(text: text, fontSize: AppConstants.sixteen, fontColor: oxfordBlueTint500);
  }

// Joint account label and checkbox
  Widget buildJointAccountTextAndCheckbox(BuildContext context,
      {bool? value, void Function(bool?)? onChanged, void Function()? onTap}) {
    return Row(
      children: [
        SizedBox(
          height: AppConstants.twentyTwo,
          width: AppConstants.eighteen,
          child: Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.five),
                ),
              ),
            ),
            child: Checkbox(
              side: const BorderSide(width: 1, color: fieldBorderColorNew),
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        commonSizedBoxWidth10(context),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: buildText(
                text: S.of(context).jointAccountWeb, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

// joint account TextField
  Widget buildVisibilityTextField(BuildContext context,
      {visible, jointAccountNameController, double? width}) {
    return Visibility(
        visible: visible,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonSizedBoxHeight30(context),
            buildHeaderText(text: S.of(context).jointAccountHolderName),
            commonSizedBoxHeight10(context),
            CommonTextField(
              onChanged: (val) {
                handleInteraction(context);
              },
              controller: jointAccountNameController,
              width: width!,
              validatorEmptyErrorText: AppConstants.nameIsRequired,
              minLengthErrorText: AppConstants.enterValidName,
              isMinimumLengthText: true,
            ),
          ],
        ));
  }

}

class CustomSliverChildBuilderDelegateSender extends SliverChildBuilderDelegate
    with ChangeNotifier {
  CustomSliverChildBuilderDelegateSender(builder) : super(builder);

  @override
   int get childCount => senderRepository.contentCount;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    return true;
  }

  @override
  bool shouldRebuild(
      covariant CustomSliverChildBuilderDelegateSender oldDelegate) {
    return true;
  }
}
