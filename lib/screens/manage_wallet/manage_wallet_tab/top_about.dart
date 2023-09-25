import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class TopUpAbout extends StatelessWidget {
  const TopUpAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).singXWallet,
          style: fairexchangeStyle(context),
        ),
        sizedBoxHeight8(context),
        Text(
          S.of(context).introducingYourVeryOwn,
          style: topupAboutSubHeading(context),
        ),
        sizedBoxHeight25(context),
        sizedBoxHeight25(context),
        sizedBoxHeight5(context),
        threeIcons(context),
        sizedBoxHeight35(context),
        sizedBoxHeight35(context),
        howToTopUp(context),
      ],
    );
  }

  Widget threeIcons(BuildContext context) {
    return getScreenWidth(context) >= 500
    // Tab and web view
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: AppConstants.flexOneData,
                child: rowWidget(
                  context,
                  S.of(context).topupToYour,
                  AppCustomIcon.empty_wallet,
                ),
              ),
              sizedBoxWidth45(context),
              Expanded(
                flex: AppConstants.flexOneData,
                child: rowWidget(
                  context,
                  S.of(context).useYourWalletBalance,
                  AppCustomIcon.globeTopup,
                ),
              ),
              sizedBoxWidth45(context),
              Expanded(
                flex: AppConstants.flexOneData,
                child: rowWidget(
                  context,
                  S.of(context).payBillsAndTopup,
                  AppCustomIcon.mobileTopUpOverseas,
                ),
              ),
            ],
          )
    // For mobile view
        : Padding(
            padding: px50Horizontal(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rowWidget(
                  context,
                  S.of(context).topUpToYourWallet,
                  AppCustomIcon.empty_wallet,
                ),
                sizedBoxHeight25(context),
                rowWidget(
                  context,
                  S.of(context).useYourWalletBalance,
                  AppCustomIcon.globeTopup,
                ),
                sizedBoxHeight25(context),
                rowWidget(
                  context,
                  S.of(context).payBillsAndTopup,
                  AppCustomIcon.mobileTopUpOverseas,
                ),
              ],
            ),
          );
  }

  // Mobile view UI
  Widget rowWidget(BuildContext context, String textData, IconData icons) {
    return Column(
      children: [
        Icon(
          icons,
          color: orangePantone,
          size: AppConstants.thirtyFive,
        ),
        sizedBoxHeight15(context),
        Text(
          textData,
          textAlign: TextAlign.center,
          style: topupAboutSubHeading(context),
        ),
      ],
    );
  }

  Widget howToTopUp(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).howToTopUpYour,
          style: fairexchangeStyle(context),
        ),
        sizedBoxHeight25(context),
        commonRowText(context, "1.", S.of(context).selectTopUpOnYour),
        sizedBoxHeight15(context),
        commonRowText(context, "2.", S.of(context).enterAmountAndChoose),
        sizedBoxHeight15(context),
        commonRowText(context, "3.", S.of(context).transferTheFund),
        sizedBoxHeight25(context),
        sizedBoxHeight25(context),
        Text.rich(
          TextSpan(
            text: S.of(context).toWithdrawFundsFrom,
            style: topupAboutSubHeading(context),
            children: [
              TextSpan(
                mouseCursor: MaterialStateMouseCursor.clickable,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    String email =
                        Uri.encodeComponent(S.of(context).helpSingXLink);
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
                text: S.of(context).helpSingXLink,
                style: topupAboutSubHeadingOrangeWithUnderline(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget commonRowText(BuildContext context, String indexNo, String textData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          indexNo,
          style: orangeText16(context),
        ),
        sizedBoxWidth15(context),
        Expanded(
          child: Text(
            textData,
            style: topupAboutSubHeading(context),
          ),
        ),
      ],
    );
  }
}
