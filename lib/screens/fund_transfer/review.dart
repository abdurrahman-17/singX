import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/initiate_transfer/initiate_transfer_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/promo_code/promo_code_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/promo_code/promo_code_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/save_transaction/save_transaction_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/save_transaction/save_transaction_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/verify_otp/verify_otp_response.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/save_transaction_sg_request.dart';
import 'package:singx/core/models/request_response/fund_transfer/save_transaction_sg_response.dart';
import 'package:singx/core/models/request_response/login/login_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_debit_request.dart';
import 'package:singx/core/models/request_response/transaction/PromoCodeCerifyResponseSG.dart';
import 'package:singx/core/models/request_response/transaction/PromoCodeVerifyRequestSg.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/fund_transfer_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import '../../core/models/request_response/australia/fund_transfer/generate_otp/generate_otp_response.dart';

class Review extends StatelessWidget {
  const Review({Key? key, required this.reviewPageNotifier}) : super(key: key);
  final FundTransferNotifier reviewPageNotifier;

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Scrollbar(
      controller: reviewPageNotifier.scrollController,
      child: SingleChildScrollView(
        controller: reviewPageNotifier.scrollController,
        child: Form(
          key: reviewPageNotifier.reviewPageKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? getScreenWidth(context) >= 361 &&
                        getScreenWidth(context) <= 1150
                    ? getScreenWidth(context) * 0.05
                    : getScreenWidth(context) <= 800
                        ? getScreenWidth(context) * 0.03
                        : getScreenWidth(context) * 0.25 : screenSizeWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonSizedBoxHeight50(context),
                buildTransactionText(context),
                commonSizedBoxHeight10(context),
                buildTransactionCompletingText(context),
                commonSizedBoxHeight30(context),
                buildTransactionCard(context, reviewPageNotifier),
                commonSizedBoxHeight30(context),
                buildDescriptionText(context),
                commonSizedBoxHeight30(context),
                buildPurposeOfTransferText(context),
                commonSizedBoxHeight10(context),
                buildPurposeOfTransferDropDownField(context),
                if ((reviewPageNotifier.countryData == SingaporeName &&
                        (reviewPageNotifier.selectedReceiver == "HKD" ||
                            reviewPageNotifier.selectedReceiver == "IDR" ||
                            reviewPageNotifier.selectedReceiver == "MYR" ||
                            reviewPageNotifier.selectedReceiver == "PHP" ||
                            reviewPageNotifier.selectedReceiver == "THB")) ||
                    (reviewPageNotifier.countryData == AustraliaName &&
                        reviewPageNotifier.selectedReceiver != "MYR" &&
                        reviewPageNotifier.selectedReceiver != "BDT")) ...[
                  commonSizedBoxHeight30(context),
                  buildRelationshipWithSenderText(context),
                  commonSizedBoxHeight10(context),
                  buildRelationshipWithSenderDropDownField(context),
                ],
                if (((reviewPageNotifier.countryData == HongKongName ||
                            reviewPageNotifier.countryData == SingaporeName) &&
                        (reviewPageNotifier.selectedReceiver == "AUD" ||
                            reviewPageNotifier.selectedReceiver == "CAD" ||
                            reviewPageNotifier.selectedReceiver == "EUR" ||
                            reviewPageNotifier.selectedReceiver == "GBP" ||
                            reviewPageNotifier.selectedReceiver == "USD" ||
                            reviewPageNotifier.selectedReceiver == "NZD"
                        )) ||
                    (reviewPageNotifier.countryData == AustraliaName &&
                        reviewPageNotifier.selectedReceiver != "SGD" &&
                        reviewPageNotifier.selectedReceiver != "BDT" &&
                        reviewPageNotifier.selectedReceiver != "INR")) ...[
                  commonSizedBoxHeight30(context),
                  buildCommentsForReceiverText(context),
                  commonSizedBoxHeight10(context),
                  buildCommentsForReceiverTextField(
                      reviewPageNotifier, context),
                ],
                commonSizedBoxHeight50(context),
                buildPromoCodeTextField(reviewPageNotifier, context),
                Visibility(
                    visible: reviewPageNotifier.errorMessage != "",
                    child: Column(
                      children: [
                        commonSizedBoxHeight10(context),
                        Text(
                          reviewPageNotifier.errorMessage,
                          style: reviewPageNotifier.errorMessage ==
                                      'Promo Code verified' ||
                                  reviewPageNotifier.errorMessage ==
                                      "Successfully retrieved "
                              ? successMessageStyle(context)
                              : errorMessageStyle(context),
                        ),
                      ],
                    )),
                commonSizedBoxHeight60(context),
                Visibility(child: Column(
                  children: [
                    Text(reviewPageNotifier.OTPErrorMessage,style: errorMessageStyle(context)),
                    commonSizedBoxHeight10(context),
                  ],
                ),visible: reviewPageNotifier.OTPErrorMessage != ''),
                buildButtons(reviewPageNotifier, context),
                commonSizedBoxHeight100(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Transaction label
  Widget buildTransactionText(BuildContext context) {
    return buildText(
        text: S.of(context).reviewTransaction,
        fontWeight: FontWeight.w700,
        fontColor: oxfordBlue,
        fontSize: AppConstants.twenty);
  }

  // Transaction info text
  Widget buildTransactionCompletingText(BuildContext context) {
    return Column(
      children: [
        buildText(
            text: S.of(context).oneStepAwayFromTransaction,
            fontSize: AppConstants.sixteen,
            fontWeight: FontWeight.w400,
            fontColor: oxfordBlueTint400),
        commonSizedBoxHeight10(context),
      ],
    );
  }

  // Transaction Card
  Widget buildTransactionCard(BuildContext context, FundTransferNotifier fundTransferNotifier) {
    return Padding(
      padding: EdgeInsets.only(right: kIsWeb ? getScreenWidth(context) < 370 ? AppConstants.ten : AppConstants.zero : AppConstants.ten ),
      child: Card(
        elevation: AppConstants.ten,
        shape: Theme.of(context).platform == TargetPlatform.iOS
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300))
            : null,
        child: Padding(
          padding: EdgeInsets.only(
            top: kIsWeb ? isMobile(context) || getScreenWidth(context) > 800
                ? getScreenHeight(context) * 0.02
                : getScreenHeight(context) * 0.01 : isMobileSDK(context) || screenSizeHeight > 800
                ? screenSizeHeight * 0.02
                : screenSizeHeight * 0.01,
            bottom: kIsWeb ? isMobile(context) || getScreenWidth(context) > 800
                ? getScreenHeight(context) * 0.02
                : getScreenHeight(context) * 0.01 : isMobileSDK(context) || screenSizeHeight > 800
                ? screenSizeHeight * 0.02
                : screenSizeHeight * 0.01,
            left: kIsWeb ? getScreenWidth(context) < 800
                ? getScreenWidth(context) * 0.030
                : getScreenWidth(context) * 0.015 : screenSizeWidth < 800 ? screenSizeWidth * 0.030 : screenSizeWidth * 0.015,
          ),
          child: SizedBox(
            width: kIsWeb ? getScreenWidth(context) <= 1150
                ? getScreenWidth(context) * 0.90
                : getScreenWidth(context) * 0.50 : screenSizeWidth <=1150 ? screenSizeWidth * 0.90 : screenSizeWidth * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                commonSizedBoxHeight5(context),
                buildRowText(context, S.of(context).sendingToWeb, fundTransferNotifier.selectedReceiverBankController.text),
                commonSizedBoxHeight5(context),
                buildRowText(context, S.of(context).transferAmountWeb,
                    "${fundTransferNotifier.selectedSender} ${double.parse(fundTransferNotifier.sendController.text).toStringAsFixed(2)}"),
                commonSizedBoxHeight5(context),
                buildRowText(context, S.of(context).exchangeRateWeb,
                    "${fundTransferNotifier.selectedReceiver} ${double.parse(fundTransferNotifier.exchangeRateConverted)}"),
                commonSizedBoxHeight5(context),
                buildRowText(context, S.of(context).receiverWillGet,
                    "${fundTransferNotifier.selectedReceiver} ${fundTransferNotifier.recipientController.text}"),
                commonSizedBoxHeight5(context),
                buildRowText(context, S.of(context).singXFeeWeb,
                    "${fundTransferNotifier.selectedSender} ${fundTransferNotifier.singXData.toStringAsFixed(2)}"),
                commonSizedBoxHeight5(context),
                buildRowText(context, S.of(context).totalPayableAmountWeb,
                    "${fundTransferNotifier.selectedSender} ${fundTransferNotifier.totalPayable.toStringAsFixed(2)}",
                    color: orangePantone),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Description Info Text
  Widget buildDescriptionText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: S.of(context).transferMoneyToOwnAccountPleaseSelect,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppConstants.sixteen,
                  color: oxfordBlueTint400)),
          TextSpan(
              text: S.of(context).transferToOwnAccount,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppConstants.sixteen,
                  color: oxfordBlueTint400)),
          TextSpan(
              text: S.of(context).sendingMoneyForSharesMedicalExpense,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppConstants.sixteen,
                  color: oxfordBlueTint400)),
        ],
      ),
    );
  }

  // Purpose of Transfer Label
  Widget buildPurposeOfTransferText(BuildContext context) {
    return buildText(
        text: S.of(context).purposeOfTransfer,
        fontColor: oxfordBlueTint500,
        fontSize: AppConstants.sixteen);
  }

  // Purpose of Transfer dropDown
  Widget buildPurposeOfTransferDropDownField(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => CustomizeDropdown(context,
            dropdownItems: reviewPageNotifier.transferPurposeData,
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected onSelected, Iterable options) {
              return buildDropDownContainer(
                context,
                options: options,
                onSelected: onSelected,
                dropdownData: reviewPageNotifier.transferPurposeData,
                dropDownWidth: kIsWeb ? getScreenWidth(context) <= 360
                    ? getScreenWidth(context) * 0.90
                    : constraints.biggest.width : screenSizeWidth <= 360 ? screenSizeWidth * 0.90 : constraints.biggest.width,
                dropDownHeight: options.first == S.of(context).noDataFound
                    ? 150
                    : options.length < 10
                        ? options.length * 50
                        : options.length * 15,
              );
            },
            width: kIsWeb ? getScreenWidth(context) <= 1150
                ? getScreenWidth(context) * 0.90
                : getScreenWidth(context) * 0.50 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.90 : screenSizeWidth * 0.50,
            onSelected: (selection) {
              handleInteraction(context);
              reviewPageNotifier.purposeOfTransfer = selection!;
              if (reviewPageNotifier.countryData == AppConstants.AustraliaName) {
                reviewPageNotifier.transferPurposeResponseData
                    .forEach((element) {
                  if (selection == element.transferPurposeName) {
                    reviewPageNotifier.transferPurposeId =
                        element.transferPurposeId!;
                  }
                });
              } else {
                reviewPageNotifier.transferPurposeResponseDataSing
                    .forEach((element) {
                  if (selection == element.transferPurposeName) {
                    reviewPageNotifier.transferPurposeId =
                        element.transferPurposeId!;
                  }
                });
              }
            },
            onSubmitted: (selection) {
              handleInteraction(context);
              reviewPageNotifier.purposeOfTransfer = selection!;
              if (reviewPageNotifier.countryData == AppConstants.AustraliaName) {
                reviewPageNotifier.transferPurposeResponseData
                    .forEach((element) {
                  if (selection == element.transferPurposeName) {
                    reviewPageNotifier.transferPurposeId =
                        element.transferPurposeId!;
                  }
                });
              } else {
                reviewPageNotifier.transferPurposeResponseDataSing
                    .forEach((element) {
                  if (selection == element.transferPurposeName) {
                    reviewPageNotifier.transferPurposeId =
                        element.transferPurposeId!;
                  }
                });
              }
            },
            controller:
                reviewPageNotifier.selectedPurposeOfTransferController,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Select purpose of transfer';
            }
            return null;
          },
        ));
  }

  // Relationship With Sender Label
  Widget buildRelationshipWithSenderText(BuildContext context) {
    return buildText(
        text: S.of(context).relationshipWithSender,
        fontColor: oxfordBlueTint500,
        fontSize: AppConstants.sixteen);
  }

  // Relationship With Sender dropDown
  Widget buildRelationshipWithSenderDropDownField(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => CustomizeDropdown(context,
                dropdownItems: reviewPageNotifier.relationshipData,
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected onSelected, Iterable options) {
              return buildDropDownContainer(
                context,
                options: options,
                onSelected: onSelected,
                dropdownData: reviewPageNotifier.relationshipData,
                dropDownWidth: kIsWeb ? getScreenWidth(context) <= 360
                    ? getScreenWidth(context) * 0.90
                    : constraints.biggest.width : screenSizeWidth <= 360 ? screenSizeWidth * 0.90 :constraints.biggest.width,
                dropDownHeight: options.first == S.of(context).noDataFound
                    ? 150
                    : options.length < 10
                        ? options.length * 50
                        : options.length * 10,
              );
            }, onSelected: (selection) {
              handleInteraction(context);
              reviewPageNotifier.relationshipWithSender = selection;
              if (reviewPageNotifier.countryData == AppConstants.AustraliaName) {
                reviewPageNotifier.relationshipResponseData.forEach((element) {
                  if (selection == element.relationshipName) {
                    reviewPageNotifier.relationshipId = element.relationshipId!;
                  }
                });
              } else {
                reviewPageNotifier.relationshipResponseDataSing
                    .forEach((element) {
                  if (selection == element.relationshipName) {
                    reviewPageNotifier.relationshipId = element.relationshipId!;
                  }
                });
              }
            }, onSubmitted: (selection) {
              handleInteraction(context);
              reviewPageNotifier.relationshipWithSender = selection;
              if (reviewPageNotifier.countryData == AppConstants.AustraliaName) {
                reviewPageNotifier.relationshipResponseData.forEach((element) {
                  if (selection == element.relationshipName) {
                    reviewPageNotifier.relationshipId = element.relationshipId!;
                  }
                });
              } else {
                reviewPageNotifier.relationshipResponseDataSing
                    .forEach((element) {
                  if (selection == element.relationshipName) {
                    reviewPageNotifier.relationshipId = element.relationshipId!;
                  }
                });
              }
            },
                width: kIsWeb ? getScreenWidth(context) <= 1150
                    ? getScreenWidth(context) * 0.90
                    : getScreenWidth(context) * 0.50 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.90 : screenSizeWidth * 0.50,
                controller: reviewPageNotifier
                    .selectedRelationshipWithSenderController,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Select relationship with sender';
            }
            return null;
          },
        ));
  }


  // Relationship With Sender Label
  Widget buildCommentsForReceiverText(BuildContext context) {
    return buildText(
        text: S.of(context).commentsForReceiver,
        fontColor: oxfordBlueTint500,
        fontSize: AppConstants.sixteen);
  }

  // Relationship With Sender dropDown
  Widget buildCommentsForReceiverTextField(FundTransferNotifier notifier, BuildContext context) {
    return CommonTextField(
      onChanged: (val) {
        handleInteraction(context);
      },
      width: kIsWeb ? getScreenWidth(context) <= 1150
          ? getScreenWidth(context) * 0.90
          : getScreenWidth(context) * 0.50 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.90 : screenSizeWidth * 0.50,
      hintStyle: hintStyle(context),
      controller: notifier.commentsForReceiverController,
      maxHeight: AppConstants.thirty,
      suffixIcon: Tooltip(
        message: "Please enter only alphabets. No special characters",
        child: Padding(
          padding:
          EdgeInsets.only(right: AppConstants.sixteen),
          child: Icon(Icons.help),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Comments for receiver is required';
        }
        return null;
      },
    );
  }

  // Promo Code TextField
  Widget buildPromoCodeTextField(FundTransferNotifier notifier, BuildContext context) {
    return CommonTextField(
      onChanged: (val) {
        handleInteraction(context);
      },
      width: kIsWeb ? getScreenWidth(context) <= 1150
          ? getScreenWidth(context) * 0.90
          : getScreenWidth(context) * 0.50 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.90 : screenSizeWidth * 0.50,
      hintText: S.of(context).enterPromoCode,
      hintStyle: hintStyle(context),
      controller: notifier.promoCodeController,
      maxHeight: AppConstants.thirty,
      suffixIcon: Padding(
        padding:
            EdgeInsets.only(right: AppConstants.sixteen),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              notifier.errorMessage = "";
              if (notifier.promoCodeController.text == "") {
                notifier.errorMessage = S.of(context).pleaseEnterPromoCode;
              } else {
                notifier.isLoading = true;
                String emailData = '';
                SharedPreferencesMobileWeb.instance
                    .getEmail(AppConstants.email)
                    .then((value) {
                  emailData = value;
                });
                Timer.periodic(Duration(seconds: 2), (timer) {
                  if (notifier.countryData == AppConstants.AustraliaName) {
                    notifier.repository
                        .verifyPromoCode(
                            context,
                            PromoCodeVerifyRequest(
                                contactId: notifier.contactId,
                                emailId: emailData,
                                promoName: notifier.promoCodeController.text,
                                sendAmount:
                                    double.parse(notifier.sendController.text),
                                receiveAmount: double.parse(
                                    notifier.recipientController.text),
                                fromId: notifier.selectedSender,
                                toId: notifier.selectedReceiver,
                                fromCountryId: 10000011,
                                toCountryId: 10000096,
                                transferPurposeId: 31))
                        .then((value) {
                      PromoCodeVerifyResponse response =
                          value as PromoCodeVerifyResponse;
                      if (response.revisedSingxFee != null) {
                        notifier.singXData =
                            double.parse(response.revisedSingxFee!);
                      }
                      notifier.errorMessage = response.message!;
                    });
                  } else {
                    notifier.repository
                        .verifyPromoCodeSG(
                            context,
                            PromoCodeVerifyRequestSg(
                                fromCountryId: notifier.sendCurrencyId,
                                toCountryId: notifier.receiverCurrencyId,
                                promoCode: notifier.promoCodeController.text,
                                sendAmt: notifier.sendController.text,
                                receiveAmt: notifier.recipientController.text,
                                transferPurposeId: notifier.transferPurposeId))
                        .then((value) {
                      PromoCodeVerifyResponseSG response =
                          value as PromoCodeVerifyResponseSG;
                      notifier.errorMessage = response.responseData!.success!
                          ? response.responseData!.message!
                          : response.responseData!.error == null
                              ? response.responseData!.message!
                              : response.responseData!.error!;
                    });
                  }
                  timer.cancel();
                  notifier.isLoading = false;
                });
              }
            },
            child: notifier.isLoading == true
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : buildText(
                    text: 'Apply',
                    fontColor: oxfordBlueTint400,
                    fontWeight: FontWeight.w600,
                    fontSize: kIsWeb ? isMobile(context) ? AppConstants.twelve : AppConstants.fourteen :  AppConstants.twelve),
          ),
        ),
      ),
    );
  }

  // Cancel and Proceed button
  Widget buildButtons(FundTransferNotifier notifier, BuildContext context) {
    return kIsWeb ? getScreenWidth(context) < 450
        ? buttonLessThan450(context, notifier)
        : buttonGreaterThan450(context,notifier) :  screenSizeWidth  < 450
        ? buttonLessThan450(context, notifier)
        : buttonGreaterThan450(context,notifier);
  }

  Widget buttonLessThan450(BuildContext context,FundTransferNotifier notifier) {
    return Column(
      children: [
        buildButton(context,
            name: S.of(context).cancel,
            fontColor: hanBlue,
            width: kIsWeb ? getScreenWidth(context) * 0.90 : screenSizeWidth * 0.90,
            color: hanBlueTint200, onPressed: () async {
              await SharedPreferencesMobileWeb.instance
                  .getCountry(AppConstants.country)
                  .then((value) async {
                Navigator.pushNamed(context, fundTransferSelectReceiverRoute);
              });
            }),
        SizedBox(height: 10),
        buildButton(
          context,
          name: S.of(context).proceedTransactionWeb,
          fontColor: white,
          fontSize: AppConstants.fourteen,
          width: kIsWeb ? getScreenWidth(context) * 0.90 : screenSizeWidth * 0.90,
          color: hanBlue,
          onPressed: () {
            if (notifier.reviewPageKey.currentState!.validate()) {
              notifier.OTPErrorMessage = '';
              generateOTP(context,notifier);
            }
          },
        )
      ],
    );
  }

  Widget buttonGreaterThan450(BuildContext context, FundTransferNotifier notifier) {
    return commonBackAndContinueButton(context, name: S.of(context).cancel, name2: S.of(context).proceedTransactionWeb,
        widthBetween: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02,
        backWidth: kIsWeb ?  getScreenWidth(context) <= 1150
            ? getScreenWidth(context) * 0.44
            : getScreenWidth(context) * 0.24 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.44 : screenSizeWidth * 0.24,
        continueWidth: kIsWeb ? getScreenWidth(context) <= 1150
            ? getScreenWidth(context) * 0.44
            : getScreenWidth(context) * 0.24 : screenSizeWidth <= 1150 ? screenSizeWidth * 0.44 : screenSizeWidth * 0.24, onPressedContinue: () {
          if (notifier.reviewPageKey.currentState!.validate()) {
            notifier.OTPErrorMessage = '';
            generateOTP(context,notifier);
          }
        }, onPressedBack: () async {
          await SharedPreferencesMobileWeb.instance
              .getCountry(AppConstants.country)
              .then((value) async {
            Navigator.pushNamed(context, fundTransferSelectReceiverRoute);
          });
        });
  }

  // Generate OTP function
  void generateOTP(BuildContext context, FundTransferNotifier notifier) {
    if(notifier.countryData == AppConstants.AustraliaName) {
      notifier.repository.generateOtp(context, 'transfer');
      openPopUpDialog(context, notifier);
    } else {
      notifier.repository.generateOtpSG(context, 'Transaction').then((value) {
        GenerateOtpResponse res = value as GenerateOtpResponse;
        if(res.response!.success == true) {
          notifier.OTPErrorMessage = '';
          openPopUpDialog(context, notifier);
        } else {
          notifier.OTPErrorMessage = res.response!.message ?? '';
        }
      });
    }
  }

  // Transaction Card details
  Widget buildRowText(BuildContext context, name, description, {FontWeight? weight, color}) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: buildText(
                text: name,
                fontWeight: weight ?? FontWeight.w400,
                fontSize: AppConstants.sixteen,
                fontColor: color ?? oxfordBlueTint400)),
        sizedBoxWidth5(context),
        Expanded(
          flex: 2,
          child: buildText(
              text: description,
              fontWeight: weight ?? FontWeight.w400,
              fontSize: AppConstants.sixteen,
              fontColor: color ?? black),
        ),
      ],
    );
  }

  // OTP PopUp dialog
  openPopUpDialog(BuildContext context, FundTransferNotifier notifier) {
    var registerNotifier = RegisterNotifier(context, from: "View Profile");

    return showDialog(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: AppConstants.four, sigmaY: AppConstants.four),
            child: StatefulBuilder(builder: (context, setState) {
              return AppInActiveCheck(
                  context: context,
                  child: AlertDialog(
                    content: SizedBox(
                      width: AppConstants.fourHundredTwenty,
                      height: getScreenWidth(context) < 340
                          ? 340
                          : getScreenHeight(context) < 700
                              ? 300
                              : 310,
                      child: SingleChildScrollView(
                        controller: reviewPageNotifier.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildText(
                                    text: S.of(context).otpVerification,
                                    fontWeight: FontWeight.w700,
                                    fontSize: getScreenWidth(context) < 340
                                        ? AppConstants.fourteen
                                        : AppConstants.twentyTwo),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: AppConstants.twenty,
                                    color: oxfordBlueTint400,
                                  ),
                                  onPressed: () {
                                    MyApp.navigatorKey.currentState!.maybePop();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: getScreenHeight(context) * 0.02),
                            buildText(
                                text: S.of(context).enterTheOtpSendtoMobile,
                                fontSize: AppConstants.sixteen,
                                fontColor: oxfordBlueTint400),
                            SizedBox(
                                height: isWeb(context)
                                    ? getScreenHeight(context) * 0.04
                                    : getScreenHeight(context) * 0.02),
                            Form(
                              key: registerNotifier.uploadAddressFormKey,
                              child: CommonTextField(
                                  onChanged: (val) {
                                    handleInteraction(context);
                                      setState((){
                                        registerNotifier.otpMessage = '';
                                      });
                                  },
                                  controller: registerNotifier.otpController,
                                  maxLength: 6,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                                  validatorEmptyErrorText: AppConstants.otpIsRequired,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  hintText: S.of(context).enterOtpHere,
                                  hintStyle: hintStyle(context),
                                  maxWidth: AppConstants.oneHundredAndSixty,
                                  width: getScreenWidth(context),
                                  maxHeight: 50,
                                  suffixIcon: getScreenWidth(context) < 340
                                      ? null
                                      : registerNotifier.isTimer == false
                                          ? Padding(
                                              padding: px8DimenAll(context),
                                              child: TweenAnimationBuilder<
                                                      Duration>(
                                                  duration:
                                                      Duration(seconds: 120),
                                                  tween: Tween(
                                                      begin:
                                                          Duration(seconds: 120),
                                                      end: Duration.zero),
                                                  onEnd: () {
                                                    setState(() {
                                                      registerNotifier.isTimer =
                                                          true;
                                                    });
                                                  },
                                                  builder:
                                                      (BuildContext context,
                                                          Duration value,
                                                          Widget? child) {
                                                    final minutes =
                                                        value.inMinutes;
                                                    final seconds =
                                                        value.inSeconds % 60;
                                                    var sec =
                                                        seconds < 10 ? 0 : '';
                                                    return Padding(
                                                      padding:
                                                          px5DimenVerticale(
                                                              context),
                                                      child: buildText(
                                                          text:
                                                              '${S.of(context).resendIn} 0$minutes: $sec$seconds ',
                                                          fontWeight: AppFont
                                                              .fontWeightRegular,
                                                          fontColor: black),
                                                    );
                                                  }),
                                            )
                                          : TextButton(
                                              onPressed: () {
                                                if (notifier.countryData ==
                                                    AppConstants.AustraliaName) {
                                                  notifier.repository
                                                      .generateOtp(
                                                          context, 'transfer');
                                                } else {
                                                  notifier.repository
                                                      .generateOtpSG(
                                                    context, 'Transaction'
                                                  );
                                                }

                                                setState(() {
                                                  registerNotifier.isTimer =
                                                      false;
                                                  registerNotifier.otpMessage =
                                                      '';
                                                });
                                              },
                                              child: buildText(
                                                  text: S.of(context).resendOtp,
                                                  fontWeight: AppFont
                                                      .fontWeightSemiBold,
                                                  fontColor: orangePantone),
                                            )),
                            ),
                            getScreenWidth(context) > 340
                                ? SizedBox()
                                : registerNotifier.isTimer == false
                                    ? Padding(
                                        padding: px8DimenAll(context),
                                        child: TweenAnimationBuilder<Duration>(
                                            duration: Duration(seconds: 120),
                                            tween: Tween(
                                                begin: Duration(seconds: 120),
                                                end: Duration.zero),
                                            onEnd: () {
                                              setState(() {
                                                registerNotifier.isTimer = true;
                                              });
                                            },
                                            builder: (BuildContext context,
                                                Duration value, Widget? child) {
                                              final minutes = value.inMinutes;
                                              final seconds =
                                                  value.inSeconds % 60;
                                              var sec = seconds < 10 ? 0 : '';
                                              return Padding(
                                                padding:
                                                    px5DimenVerticale(context),
                                                child: buildText(
                                                    text:
                                                        '${S.of(context).resendIn} 0$minutes: $sec$seconds ',
                                                    fontWeight: AppFont
                                                        .fontWeightRegular,
                                                    fontColor: black),
                                              );
                                            }),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          if (notifier.countryData ==
                                              AppConstants.AustraliaName) {
                                            notifier.repository.generateOtp(
                                                context, 'transfer');
                                          } else {
                                            notifier.repository
                                                .generateOtpSG(context, 'Transaction');
                                          }
                                          setState(() {
                                            registerNotifier.isTimer = false;
                                            registerNotifier.otpMessage = '';
                                          });
                                        },
                                        child: Center(
                                          child: buildText(
                                              text: S.of(context).resendOtp,
                                              fontWeight:
                                                  AppFont.fontWeightSemiBold,
                                              fontColor: orangePantone),
                                        )),
                            sizedBoxHeight5(context),
                            registerNotifier.otpMessage != ""
                                ? buildText(
                                    text: registerNotifier.otpMessage,
                                    fontColor: error)
                                : isWeb(context)
                                    ? Text('')
                                    : SizedBox(),
                            isWeb(context)
                                ? sizedBoxHeight20(context)
                                : sizedBoxHeight30(context),
                            buildButton(context, onPressed: () async {
                              registerNotifier.otpMessage = '';
                              if (registerNotifier
                                  .uploadAddressFormKey.currentState!
                                  .validate()) {
                                if (notifier.countryData == AppConstants.AustraliaName) {
                                  notifier.repository
                                      .verifyOtp(context, notifier.selectedMobileNumber,
                                          registerNotifier.otpController.text)
                                      .then((value) async {
                                    VerifyOtpResponse response =
                                        value as VerifyOtpResponse;
                                    setState(() {
                                      registerNotifier.otpMessage =
                                          response.message!;
                                    });
                                    if (registerNotifier.otpMessage ==
                                        'OTP verified') {
                                      SaveTransactionResponse? response;
                                      await notifier.repository
                                          .saveTransaction(
                                        context,
                                        SaveTransactionRequest(
                                          contactId: notifier.contactId,
                                          corridorId:
                                              int.parse(notifier.corridorID),
                                          exchangeRate: double.parse(
                                              notifier.exchangeRateConverted),
                                          otherpurpose: "",
                                          promoCode:
                                              notifier.promoCodeController.text,
                                          purposeId: notifier.transferPurposeId,
                                          purposeRemarks: notifier.commentsForReceiverController.text,
                                          receiveAmount: double.parse(notifier
                                              .recipientController.text),
                                          receiverId: int.parse(
                                              notifier.selectedBankReceiverId),
                                          relationshipwithId:
                                              notifier.relationshipId== 0 ? null: notifier.relationshipId,
                                          sendAmount: double.parse(
                                              notifier.sendController.text),
                                          senderId: int.parse(
                                              notifier.selectedBankId),
                                          singxFee: notifier.singXData,
                                          grosssingxFee: notifier.singXDataOld,
                                          totalFee: notifier.singXDataOld,
                                          totalPayable: notifier.totalPayable,
                                          transfermodeFee: 0,
                                          transfermodeId: 1,
                                          wiretransfermodeId: 0,
                                          isswift: notifier.selectedReceiver == "USD" && notifier.selectedRadioTile == 2 ? true : false,
                                        ),
                                      )
                                          .then((value) async {
                                        response =
                                            value as SaveTransactionResponse?;
                                        if (response!.success == false &&
                                            response!.message != null) {
                                          MyApp.navigatorKey.currentState!.maybePop();
                                          showSnackBar(
                                              response!.message!, context);
                                        } else {
                                          notifier.referenceNumber =
                                              response!.userTxnId!;
                                          notifier.bankName =
                                              response!.bankname!;
                                          notifier.accountNumberAus =
                                              response!.accountnumber!;
                                          notifier.accountName =
                                              response!.accountname!;
                                          notifier.bsbCode = response!.bsbcode!;
                                          Map<String, dynamic> reviewData = {
                                            "userTransactionId":
                                                notifier.referenceNumber,
                                            "bankName": notifier.bankName,
                                            "accountName": notifier.accountName,
                                            "accountNumber":
                                                notifier.accountNumberAus,
                                            "bsbCode": notifier.bsbCode,
                                            "transferPurpose": notifier
                                                .selectedPurposeOfTransferController
                                                .text,
                                            "relationship": notifier
                                                .selectedRelationshipWithSenderController
                                                .text,
                                            "promoCode": notifier
                                                .promoCodeController.text,
                                          };
                                          await SharedPreferencesMobileWeb
                                              .instance
                                              .setFundTransferReviewData(
                                              AppConstants.reviewScreenData,
                                                  jsonEncode(reviewData));
                                          await notifier.repository
                                              .initiateTransferMail(
                                                  context,
                                                  InitiateTransferEmailRequest(
                                                    contactId:
                                                        notifier.contactId,
                                                    exchangeRate: notifier
                                                        .exchangeRateConverted,
                                                    receiveAmount: notifier
                                                        .recipientController
                                                        .text,
                                                    receiveCurrency: notifier
                                                        .selectedReceiver,
                                                    receiverAccountNumber: notifier
                                                        .receiverAccountNumberData,
                                                    receiverBankName: notifier
                                                        .receiverBankNameData,
                                                    receiverName: notifier
                                                        .receiverNameData,
                                                    sendAmount: notifier
                                                        .sendController.text,
                                                    sendCurrency:
                                                        notifier.selectedSender,
                                                    singxFee: notifier.singXData
                                                        .toString(),
                                                    totalPayable: notifier
                                                        .totalPayable
                                                        .toString(),
                                                    transfermodeId: 1,
                                                    userTxnId: notifier
                                                        .referenceNumber,
                                                  ));
                                          Provider.of<CommonNotifier>(context,
                                                  listen: false)
                                              .incrementCounterFund();
                                          await SharedPreferencesMobileWeb
                                              .instance
                                              .getCountry(AppConstants.country)
                                              .then((value) async {
                                            Navigator.pushNamed(context,
                                                fundTransferTransferRoute);
                                          });

                                          SharedPreferencesMobileWeb.instance
                                              .setReviewSelectedScreenData(
                                              AppConstants.reviewPage, true);
                                        }
                                      });
                                    }
                                  });
                                } else {
                                  notifier.repository
                                      .saveTransactionSG(
                                          context,
                                          SaveTransactionRequestSG(
                                              senderId: notifier.selectedBankId,
                                              receiverId: notifier
                                                  .selectedBankReceiverId,
                                              receiverRelationShip: notifier.relationshipId == 0 ? null: notifier.relationshipId.toString(),
                                              promoCode: notifier.promoCodeController.text,
                                              transferMode:
                                                  notifier.selectedAccountType,
                                              comments: notifier.commentsForReceiverController.text,
                                              sendCurrency:
                                                  notifier.selectedSender,
                                              receiveCurrency:
                                                  notifier.selectedReceiver,
                                              sendAmount:
                                                  notifier.sendController.text,
                                              receivedAmount: notifier
                                                  .recipientController.text,
                                              exchangeRate: notifier
                                                  .exchangeRateConverted,
                                              oneTimePassword: registerNotifier
                                                  .otpController.text,
                                              transferPurposeId: notifier
                                                          .transferPurposeId !=
                                                      31
                                                  ? notifier.transferPurposeId
                                                      .toString()
                                                  : "",
                                              otherPurpose:
                                                  notifier.transferPurposeId ==
                                                          31
                                                      ? "test purpose"
                                                      : ""))
                                      .then((value) async {
                                    SaveTransactionResponseSG response =
                                        value as SaveTransactionResponseSG;
                                    if (response.response!.success ==
                                        false) {
                                      setState(() {
                                        registerNotifier.otpMessage =
                                            response.response!.message!;
                                      });
                                    } else if (notifier.selectedAccountType ==
                                        '4') {
                                      await SharedPreferencesMobileWeb.instance
                                          .getUserData(AppConstants.user)
                                          .then((value) async {
                                        LoginResponse res =
                                            loginResponseFromJson(value);
                                        await SGWalletRepository()
                                            .SGWalletDebit(
                                                context,
                                                WalletDebitRequest(
                                                    contactId:
                                                        res.userinfo!.contactId,
                                                    countrycode: "sg",
                                                    currencyCode:
                                                        notifier.selectedSender,
                                                    endbal: 0,
                                                    exchangeRate: double.parse(
                                                        notifier
                                                            .exchangeRateConverted),
                                                    paymentType: "Wallet",
                                                    productTxnId: "",
                                                    sendAmount: notifier
                                                        .sendController.text,
                                                    senderId: "0",
                                                    startbal: 0,
                                                    totalPayable: notifier
                                                        .totalPayable
                                                        .toString(),
                                                    transactionFee: notifier
                                                        .singXData
                                                        .toString(),
                                                    transactionType: "Debit"))
                                            .then((value) async {
                                          CommonResponse commonResponse =
                                              value as CommonResponse;
                                          if (commonResponse.success == false) {
                                            registerNotifier.otpMessage =
                                                commonResponse.message!;
                                          } else {
                                            notifier.referenceNumber = response.response!.data!.userTxnId!;
                                            notifier.bankName =  response.response!.bankDetails![0].bankName!;
                                            notifier.accountName = response.response!.bankDetails![0].accountName!;
                                            notifier.accountNumber = response.response!.bankDetails![0].accountNumber!;
                                            notifier.bankCode = response.response!.bankDetails![0].bankCode!;
                                            notifier.branchCode = response.response!.bankDetails![0].branchCode == null?"":response.response!.bankDetails![0].branchCode!;

                                            Map<String, dynamic> reviewData = {
                                              "userTransactionId":
                                              notifier.referenceNumber,
                                              "bankName": notifier.bankName,
                                              "accountName": notifier.accountName,
                                              "accountNumber": notifier.accountNumber,
                                              "bsbCode": notifier.bsbCode,
                                              "bankCode": notifier.bankCode,
                                              "branchCode": notifier.branchCode,
                                              "transferPurpose": notifier
                                                  .selectedPurposeOfTransferController
                                                  .text,
                                              "relationship": notifier
                                                  .selectedRelationshipWithSenderController
                                                  .text,
                                              "promoCode":
                                              notifier.promoCodeController.text,
                                            };
                                            await SharedPreferencesMobileWeb.instance
                                                .setFundTransferReviewData(
                                                AppConstants.reviewScreenData,
                                                jsonEncode(reviewData));
                                            Provider.of<CommonNotifier>(context,
                                                    listen: false)
                                                .incrementCounterFund();
                                            await SharedPreferencesMobileWeb
                                                .instance
                                                .getCountry(AppConstants.country)
                                                .then((value) async {
                                              Navigator.pushNamed(context,
                                                  fundTransferTransferRoute);
                                            });

                                            SharedPreferencesMobileWeb.instance
                                                .setReviewSelectedScreenData(
                                                AppConstants.reviewPage, true);
                                          }
                                        });
                                      });
                                    } else {
                                      notifier.referenceNumber = response
                                          .response!.data!.userTxnId!;
                                      notifier.bankName =  response.response!.bankDetails![0].bankName!;
                                      notifier.accountName = response.response!.bankDetails![0].accountName!;
                                      notifier.accountNumber = response.response!.bankDetails![0].accountNumber!;
                                      notifier.bankCode = response.response!.bankDetails![0].bankCode!;
                                      notifier.branchCode = response.response!.bankDetails![0].branchCode == null?"":response.response!.bankDetails![0].branchCode!;
                                      Map<String, dynamic> reviewData = {
                                        "userTransactionId":
                                            notifier.referenceNumber,
                                        "bankName": notifier.bankName,
                                        "accountName": notifier.accountName,
                                        "accountNumber": notifier.accountNumber,
                                        "bsbCode": notifier.bsbCode,
                                        "bankCode": notifier.bankCode,
                                        "branchCode": notifier.branchCode,
                                        "transferPurpose": notifier
                                            .selectedPurposeOfTransferController
                                            .text,
                                        "relationship": notifier
                                            .selectedRelationshipWithSenderController
                                            .text,
                                        "promoCode":
                                            notifier.promoCodeController.text,
                                      };
                                      await SharedPreferencesMobileWeb.instance
                                          .setFundTransferReviewData(
                                          AppConstants.reviewScreenData,
                                              jsonEncode(reviewData));
                                      Provider.of<CommonNotifier>(context,
                                              listen: false)
                                          .incrementCounterFund();
                                      await SharedPreferencesMobileWeb.instance
                                          .getCountry(AppConstants.country)
                                          .then((value) async {
                                        Navigator.pushNamed(
                                            context, fundTransferTransferRoute);
                                      });

                                      SharedPreferencesMobileWeb.instance
                                          .setReviewSelectedScreenData(
                                          AppConstants.reviewPage, true);
                                    }
                                  });
                                }
                              }
                            },
                                width: getScreenWidth(context),
                                height: AppConstants.fortyFive,
                                name: S.of(context).verify,
                                fontColor: white,
                                color: hanBlue),
                          ],
                        ),
                      ),
                    ),
                  ));
            }),
          );
        },
        context: context);
  }

}
