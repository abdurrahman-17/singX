import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/models/request_response/sing_pass_url/sing_pass_url_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/dashboard_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/manage_receiver/manage_receivers.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
import 'package:singx/utils/common/web_view.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class DashBoardIncompleteVersion extends StatelessWidget {
  const DashBoardIncompleteVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DashboardNotifier(context),
      child: Consumer<DashboardNotifier>(
        builder: (context, dashboardNotifier, _) {
          return PageScaffold(
            color: bankDetailsBackground,
            scrollController: dashboardNotifier.scrollController,
            appbar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: Padding(
                padding: isMobile(context) || isTab(context)
                    ? px15DimenTop(context)
                    : px30DimenTopOnly(context),
                child: buildAppBar(
                  context,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IgnorePointer(
                        ignoring: (getScreenWidth(context) > 500),
                        child: Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message: dashboardNotifier.name,
                          child: Text(
                             dashboardNotifier.name != " "
                                ? dashboardNotifier.name != null ? getScreenWidth(context) < 460 && dashboardNotifier.name!.length > 6 ? '${AppConstants.dashboardWelcome}' :  'Welcome, ${dashboardNotifier.name ?? ''}': AppConstants.welcomeUser
                                : AppConstants.welcomeUser,
                            style: TextStyle(
                              fontFamily: AppConstants.manrope,
                              overflow: TextOverflow.clip,
                              fontSize: getScreenWidth(context) <= 355
                                  ? AppConstants.sixteen
                                  : getScreenWidth(context) <= 385
                                      ? AppConstants.twenty
                                      : AppConstants.twentyFour,
                              fontWeight: FontWeight.w700,
                              color: oxfordBluelight,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        dashboardDateFormatter(),
                        style: TextStyle(
                          fontFamily: AppConstants.manrope,
                          fontSize: AppConstants.fourteen,
                          fontWeight: FontWeight.w400,
                          color: oxfordBlueTint400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(content: Text(AppConstants.doubleTapToLogOut),duration: Duration(seconds: 3),),
              child: SingleChildScrollView(
                controller: dashboardNotifier.scrollController,
                child: Column(
                  children: [
                    sizedBoxHeight20(context),
                    Visibility(
                        child: buildAlertGetVerified(context, dashboardNotifier),
                        visible: dashboardNotifier.getVerified),
                    Visibility(
                        child: buildCouldNotVerified(context, dashboardNotifier),
                        visible: dashboardNotifier.error.isNotEmpty && dashboardNotifier.selectedCountryData == AppConstants.singapore) ,
                    Visibility(
                        child: buildCouldNotVerifiedAus(context, dashboardNotifier),
                        visible: dashboardNotifier.error.isNotEmpty && dashboardNotifier.selectedCountryData == AppConstants.australia),
                    Visibility(
                        child: buildCouldNotVerifiedHK(context, dashboardNotifier),
                        visible: dashboardNotifier.error.isNotEmpty && dashboardNotifier.selectedCountryData == AppConstants.hongKong),
                    Visibility(
                        child: sizedBoxHeight20(context),
                        visible: dashboardNotifier.error.isNotEmpty),
                    Padding(
                      padding: px20DimenHorizontal(context),
                      child: buildSendMoney(context, dashboardNotifier),
                    ),
                    sizedBoxHeight30(context),
                  ],
                ),
              ),
            ),
            title: AppConstants.dashboardV1,
          );
        },
      ),
    );
  }

  Widget buildCouldNotVerifiedAus(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      width: double.infinity,
        margin: px15DimenHorizontal(context),
        padding: px15DimenAll(context),
        decoration: webAlertContainerStyle(context),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headingText(context, dashboardNotifier),
              style: alertbodyTextStyleBold(context),
            ),
            sizedBoxHeight15(context),
            Text(secondaryText(context, dashboardNotifier),style: blackTextStyle16(context),),
            sizedBoxHeight15(context),
            if(dashboardNotifier.error == "10000014")Text(AppConstants.customerServiceInfo,style: blackTextStyle16(context),),
            sizedBoxHeight15(context),
            Visibility(
              visible: dashboardNotifier.error == "10000004" || dashboardNotifier.error == "10000005"|| dashboardNotifier.error == "10000013" || dashboardNotifier.error == "10000014" ? false : true,
              child: buildButton(  context,name: "Proceed",fontColor: white,
                  color: hanBlue,width: getScreenWidth(context)<690?150:null,height: getScreenWidth(context)<690?50:null,
                  onPressed:  (){
                      if(dashboardNotifier.error == "10000000"){
                        Navigator.pushNamed(context, personalDetailsAustraliaRoute);
                      } else if(dashboardNotifier.error == "10000001" || dashboardNotifier.error == "10000003"){
                        Navigator.pushNamed(context, digitalVerificationAustralia);
                      } else if(dashboardNotifier.error == "10000002"){
                        Navigator.pushNamed(context, nonDigitalVerificationAustralia);
                      } else if(dashboardNotifier.error == "10000004" || dashboardNotifier.error == "10000005" || dashboardNotifier.error == "10000013" || dashboardNotifier.error == "10000014"){
                        Provider.of<CommonNotifier>(context, listen: false)
                            .updateUserVerifiedBool = false;
                        Navigator.pushNamed(context, dashBoardRoute);
                      }
                  }),
            )
          ],
        )
    );
  }

  String headingText(BuildContext context, DashboardNotifier dashboardNotifier){
    String title = "";
    if(dashboardNotifier.error == "10000000" || dashboardNotifier.error == "10000001" || dashboardNotifier.error == "10000002" || dashboardNotifier.error == "10000003"){
      title = "Can’t wait to get started? You’re almost there!";
    }else if(dashboardNotifier.error == "10000004" || dashboardNotifier.error == "10000005" || dashboardNotifier.error == "10000013" || dashboardNotifier.error == "10000014" ){
      title = "Application Status";
    }
      return title;
  }

  String secondaryText(BuildContext context, DashboardNotifier dashboardNotifier){
    String title = "";
    if(dashboardNotifier.error == "10000000" || dashboardNotifier.error == "10000001" || dashboardNotifier.error == "10000002"){
      title = "Before you can start transferring money overseas, please complete your online application.";
    }else if(dashboardNotifier.error == "10000003" || dashboardNotifier.error == "10000004" || dashboardNotifier.error == "10000005"){
      title = "We are reviewing your application. This usually takes upto 1 business day. We will notify you via email once the account is activated.";
    }else if(dashboardNotifier.error == "10000013"){
      title = "Thank you for registering with us. We were unable to process your application, our customer service representative will reach out to you with more details.";
    }else if(dashboardNotifier.error == "10000013"){
      title = "Thank you for registering. We have captured your details.";
    }
      return title;
  }

  Widget buildAlertGetVerified(BuildContext context, DashboardNotifier dashboardNotifier) {
    return ListView.separated(
        separatorBuilder: ((context, index) {
          return sizedBoxHeight10(context);
        }),
        shrinkWrap: true,
        itemCount: dashboardNotifier.notificationData.length,
        itemBuilder: (context, index) {
          return Visibility(
              visible: dashboardNotifier.topVerifyValidation,
              child: Container(
                margin: px20DimenAll(context),
                padding: px12And15DimenAll(context),
                decoration: webAlertContainerStyle(context),
                child: Row(
                  children: [
                    sizedBoxHeight15(context),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dashboardNotifier.notificationData[index].title
                                .toString(),
                            style: walletGridTextStyle2(context),
                          ),
                          sizedBoxHeight10(context),
                          Text(
                            dashboardNotifier.notificationData[index].body
                                .toString(),
                            style: alertbodyTextStyle14(context),
                          ),
                        ],
                      ),
                    ),
                    sizedBoxWidth5(context),
                    IconButton(
                      onPressed: () {
                        dashboardNotifier.topVerifyValidation = false;
                      },
                      icon: Icon(
                        Icons.clear,
                        color: clearIconColor,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget buildCouldNotVerified(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      margin: px15DimenHorizontal(context),
      padding: px15DimenAll(context),
      decoration: webAlertContainerStyle(context),
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: dashboardNotifier.error != applicationComplete,
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: orangeColor.withOpacity(0.8),
                      size: AppConstants.twenty,
                    ),
                    sizedBoxWidth10(context)
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  dashboardNotifier.error == applicationComplete
                      ? thankYouForRegisteringWithUs
                      : dashboardNotifier.error == profile
                      ? completeYourRegistration
                      : cantWaitToGetStartedYour,
                  style: alertbodyTextStyleBold(context),
                ),
              ),
              Visibility(
                  child: sizedBoxHeight15(context),
                  visible: dashboardNotifier.error != applicationComplete),
            ],
          ),
          Visibility(
              visible: dashboardNotifier.error == applicationComplete ||
                  dashboardNotifier.error == profile
                  ? false
                  : true,
              child: sizedBoxHeight15(context)),
          Text(
            dashboardNotifier.error == kyc
                ? AppConstants.beforeYouStartTransfer
                : "",
            style: blackTextStyle16(context),
          ),
          Visibility(
              visible: dashboardNotifier.error == applicationComplete ||
                  dashboardNotifier.error == profile
                  ? false
                  : true,
              child: sizedBoxHeight15(context)),
          Visibility(
            visible: dashboardNotifier.error != applicationComplete,
            child: Text(
              dashboardNotifier.error == profile
                  ? AppConstants.quickAccount
                  : AppConstants.profileCompleted,
              style: greyTextStyleBold(context),
            ),
          ),
          Visibility(
            visible: dashboardNotifier.error == profile,
            child: sizedBoxHeight15(context),
          ),
          Visibility(
            visible: dashboardNotifier.error==profile,
            child: buildButton(context,name: 'Login to MyInfo',fontColor: white,
                color: hanBlue,
                width: getScreenWidth(context)<690?150:null,height: getScreenWidth(context)<690?50:null,
                onPressed: (){
                  contactRepository.singPassUrl(context).then((value) {
                    SingPassUrl singPassUrl = value as SingPassUrl;
                    if (kIsWeb) {
                      html.openLink('${singPassUrl.url}');
                    } else {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                  WebViewMobile(
                                    SingXUrl: singPassUrl.url,
                                    AppId: singPassUrl.id,
                                    from: AppConstants.singpass,
                                  )));
                    }
                  });
                }),
          ),
          sizedBoxHeight15(context),
          Text(dashboardNotifier.error==applicationComplete?thankYouYourApplicationIsComplete:dashboardNotifier.error==profile?AppConstants.dontHaveMyInfo:AppConstants.identityDocument,style: greyTextStyleBold(context),),
          Visibility(
                visible: dashboardNotifier.error != applicationComplete,
                child: Column(
                  children: [
                    sizedBoxHeight15(context),
                    buildButton(context,
                        name: S.of(context).proceed,
                        fontColor: white,
                        color: hanBlue,
                        width: getScreenWidth(context) < 690 ? 150 : null,
                        height: getScreenWidth(context) < 690 ? 50 : null,
                        onPressed: dashboardNotifier.error == kyc
                            ? () async {
                                await SharedPreferencesMobileWeb.instance
                                    .getCountry(country)
                                    .then((value) async {
                                  Navigator.pushNamed(
                                      context, verificationMethodRoute);
                                });
                              }
                            : () async {
                                await SharedPreferencesMobileWeb.instance
                                    .getCountry(country)
                                    .then((value) async {
                                  Navigator.pushNamed(
                                      context, personalDetailsRoute);
                                });
                              })
                  ],
                )),
          ],
      )
    );
  }

  Widget buildCouldNotVerifiedHK(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      margin: px15DimenHorizontal(context),
      padding: px15DimenAll(context),
      decoration: webAlertContainerStyle(context),
      child:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: dashboardNotifier.error == applicationComplete ||
                          dashboardNotifier.error == HK_OTP
                      ? false
                      : true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: orangeColor.withOpacity(0.8),
                        size: AppConstants.twenty,
                      ),
                      sizedBoxWidth10(context)
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    dashboardNotifier.error == HK_OTP ||
                            dashboardNotifier.error == applicationComplete
                        ? thankYouForRegisteringWithUs
                        : cantWaitToGetStartedYour,
                    style: alertbodyTextStyleBold(context),
                  ),
                ),
                Visibility(
                    visible: dashboardNotifier.error != applicationComplete,
                    child: sizedBoxHeight15(context)),
              ],
            ),
            sizedBoxHeight15(context),
            Visibility(
              visible: dashboardNotifier.error == HK_OTP ||
                      dashboardNotifier.error == applicationComplete
                  ? false
                  : true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppConstants.beforeYouStart,
                      style: blackTextStyle16(context)),
                  sizedBoxHeight15(context),
                  Text(
                      "1. Profile ${dashboardNotifier.error != profile ? " - Complete" : ""}",
                      style: greyTextStyleBold(context)),
                  Text(
                      "2. Identity Document Upload${dashboardNotifier.error == HKStep2 ? " - Incomplete" : dashboardNotifier.error == HKStep3 ? " - Complete" : ""}",
                      style: greyTextStyleBold(context)),
                  sizedBoxHeight5(context),
                  Text(
                      "3. Additional Details${dashboardNotifier.error == HKStep2 || dashboardNotifier.error == HKStep3 ? " - Incomplete" : ""}",
                      style: greyTextStyleBold(context)),
                  sizedBoxHeight5(context),
                  Text(
                      "4. Mobile Verification${dashboardNotifier.error == HKStep2 || dashboardNotifier.error == HKStep3 ? " - Incomplete" : ""}",
                      style: greyTextStyleBold(context)),
                ],
              ),
            ),
            sizedBoxHeight15(context),
            Visibility(
                visible: dashboardNotifier.error == HK_OTP ||
                    dashboardNotifier.error == applicationComplete,
                child: Text(
                  dashboardNotifier.error == applicationComplete
                      ? YourApplicationIsCurrentlyUnderReviewByOur
                      : YouAreOneStepAway,
                  style: greyTextStyleBold(context),
                )),
            sizedBoxHeight15(context),
            Visibility(
              visible: dashboardNotifier.error != applicationComplete,
              child: buildButton(context,
                  name: dashboardNotifier.error == HKStep2 ||
                          dashboardNotifier.error == HKStep3
                      ? S.of(context).proceed
                      : S.of(context).continues,
                  fontColor: white,
                  color: hanBlue,
                  width: getScreenWidth(context) < 690 ? 150 : null,
                  height: getScreenWidth(context) < 690 ? 50 : null,
                  onPressed: dashboardNotifier.error == profile
                      ? () async {
                          Navigator.pushNamed(
                              context, registerHongKongHomeScreen);
                        }
                      : dashboardNotifier.error == HKStep2
                          ? () async {
                              Navigator.pushNamed(
                                  context, uploadHKIDProofRoute);
                            }
                          : dashboardNotifier.error == HKStep3
                              ? () async {
                                  Navigator.pushNamed(
                                      context, additionalDetailsRoute);
                                }
                              : dashboardNotifier.error == HK_OTP
                                  ? () async {
                                      Navigator.pushNamed(
                                          context, additionalDetailsRouteOtp);
                                    }
                                  : () async {
                                      await SharedPreferencesMobileWeb.instance
                                          .getCountry(country)
                                          .then((value) async {
                                        Navigator.pushNamed(
                                            context, personalDetailsRoute);
                                      });
                                    }),
            )
          ],
        ));
  }

  Widget buildSendMoney(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      width: AppConstants.fiveHundredAndFifty,
      child: Column(
        children: [
          sendMoneyCommon(
            context,
            sendController:dashboardNotifier.sendController,
            onChangedSend:(value) async {

              //Sender Text Field Onchange Function

              handleInteraction(context);

              //TextField Value Validation
              final regex = RegExp(r'^0(?!\.|$)');
              if (regex.hasMatch(value)) {
                dashboardNotifier.sendController.text = value.substring(1); // Remove the leading zero
                dashboardNotifier.sendController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: dashboardNotifier.sendController.text.length));
              } else if (value.isEmpty) {

                dashboardNotifier.sendController.text = '0'; // Set the value to "0" when cleared
                dashboardNotifier.recipientController.text = "0";
                dashboardNotifier.singXData = 0;
                dashboardNotifier.totalPayable = 0;
                dashboardNotifier.sendController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: dashboardNotifier.sendController.text.length));

              }else {
                dashboardNotifier.sendController.text = value;
                dashboardNotifier.sendController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: dashboardNotifier.sendController.text.length));
              }

              //exchange API while changing text
              dashboardNotifier.exchangeApi(
                  context,
                  dashboardNotifier.selectedSender,
                  dashboardNotifier.selectedReceiver,
                  dashboardNotifier.selectedCountryData ==
                          AppConstants.australia
                      ? "First"
                      : "Send",
                  double.parse(value), false);
            },
            recipientController:dashboardNotifier.recipientController,
            onChangedReceive: (value) async {

              //Receiver Text Field onchange function

              handleInteraction(context);

              //TextField Value Validation
              final regex = RegExp(r'^0(?!\.|$)');
              if (regex.hasMatch(value)) {
                dashboardNotifier.recipientController.text = value.substring(1); // Remove the leading zero
                dashboardNotifier.recipientController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: dashboardNotifier.recipientController.text.length));
              } else if (value.isEmpty) {

                dashboardNotifier.recipientController.text = '0'; // Set the value to "0" when cleared
                dashboardNotifier.sendController.text = "0";
                dashboardNotifier.singXData = 0;
                dashboardNotifier.totalPayable = 0;
                dashboardNotifier.recipientController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: dashboardNotifier.recipientController.text.length));

              }else {
                dashboardNotifier.recipientController.text = value;
                dashboardNotifier.recipientController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: dashboardNotifier.recipientController.text.length));
              }


              //Exchange API while changing value
              dashboardNotifier.exchangeApi(
                  context,
                  dashboardNotifier.selectedSender,
                  dashboardNotifier.selectedReceiver,
                  dashboardNotifier.selectedCountryData ==
                          AppConstants.australia
                      ? "Second"
                      : "Receive",
                  double.parse(value), false);
            },
            singxFee:dashboardNotifier.singXData.toString(),
            totalAmountPay:dashboardNotifier.totalPayable.toString(),
            title:S.of(context).sendMoney,
            errorMessage:dashboardNotifier.errorExchangeValue,
            sendCountry:dashboardNotifier.selectedSender,
            receiverCountry:dashboardNotifier.selectedReceiver,
            sendCountryList:dashboardNotifier.selectedCountryData == AppConstants.australia
                ? dashboardNotifier.senderData
                : dashboardNotifier.senderData,
            receiverCountryList:dashboardNotifier.selectedCountryData == AppConstants.australia
                ? dashboardNotifier.ReceiverData
                : dashboardNotifier.ReceiverData,
            sendOnchanged:dashboardNotifier.selectedCountryData == AppConstants.australia ||
                    dashboardNotifier.selectedCountryData ==
                        AppConstants.hongKong
                ? null
                : (String? newValue) {

                    //Sender dropdown onChange value

                    dashboardNotifier.selectedSender = newValue!;
                    dashboardNotifier.ReceiverData.clear();

                    //Controlling the corridor data
                    dashboardNotifier.selectedCountryData ==
                            AppConstants.australia
                        ? null
                        : FxRepository()
                            .corridorResponseData
                            .forEach((key, value) {
                            if (dashboardNotifier.selectedSender == key) {
                              value.forEach((element) {
                                dashboardNotifier.selectedReceiver =
                                    value[0].key!;
                              });
                            }
                            if (newValue == key) {
                              value.forEach((element) {
                                dashboardNotifier.ReceiverData.add(
                                    element.key!);
                              });
                            }
                          });


                    dashboardNotifier.exchangeSelectedSender =
                        dashboardNotifier.selectedSender;
                    dashboardNotifier.exchangeSelectedReceiver =
                        dashboardNotifier.selectedReceiver;

                    //Exchange API while changing corridor
                    dashboardNotifier.exchangeApi(
                      context,
                      dashboardNotifier.selectedSender,
                      dashboardNotifier.selectedReceiver,
                      dashboardNotifier.selectedCountryData ==
                              AppConstants.australia
                          ? "First"
                          : "Send",
                      double.parse(dashboardNotifier.sendController.text), true,
                    );
                  },
            receiverOnchanged:(String? newValue) {

              //Receiver dropdown onChange Function

              dashboardNotifier.selectedReceiver = newValue!;
              dashboardNotifier.exchangeSelectedSender =
                  dashboardNotifier.selectedSender;
              dashboardNotifier.exchangeSelectedReceiver =
                  dashboardNotifier.selectedReceiver;

              //exchange api while changing receiver corridor data
              dashboardNotifier.exchangeApi(
                  context,
                  dashboardNotifier.exchangeSelectedSender,
                  dashboardNotifier.exchangeSelectedReceiver,
                  dashboardNotifier.selectedCountryData ==
                          AppConstants.australia
                      ? "First"
                      : "Send",
                  double.parse(dashboardNotifier.sendController.text),true,);
            },
            buttonFunction:null,
            exchangeRateInitialValue:dashboardNotifier.exchagneRateInital,
            exchangeRateConvertedValue:dashboardNotifier.exchagneRateConverted,
            buttonFunctionForExchange:() {

              //This function is for transfer exchange rate

              String temp;
              temp = dashboardNotifier.exchangeSelectedSender;
              dashboardNotifier.exchangeSelectedSender =
                  dashboardNotifier.exchangeSelectedReceiver;
              dashboardNotifier.exchangeSelectedReceiver = temp;
              dashboardNotifier.exchagneRateConverted =
                  (1 / double.parse(dashboardNotifier.exchagneRateConverted))
                      .toString();
            },
            selectedCountry:dashboardNotifier.selectedCountryData,
            dashboardNotifier:dashboardNotifier,
          ),
          sizedBoxHeight30(context),
          sizedBoxHeight15(context),
        ],
      ),
    );
  }
}
