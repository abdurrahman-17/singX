import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_font.dart';
import 'app_constants.dart';
import 'app_images.dart';
import 'app_screen_dimen.dart';
import 'app_widgets.dart';

TextStyle userNameTextStyle(context) => (TextStyle(
    fontSize: 25, fontWeight: AppFont.fontWeightMedium, color: Colors.white));

TextStyle drawerTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightMedium, color: drawerGreyText));

TextStyle topUpFieldTextStyle(context) => (TextStyle(
    fontSize: 16,
    fontWeight: AppFont.fontWeightMedium,
    color: fieldHeadingGreyText));

TextStyle topUpTextDataTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightMedium, color: black));

TextStyle dropDownHeadingTextStyle(context) => (TextStyle(
    fontSize: 16,
    fontWeight: AppFont.fontWeightMedium,
    color: oxfordBlueTint500));

TextStyle alertbodyTextStyle12(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: oxfordBlue));

TextStyle alertbodyTextStyleBold(context) => (TextStyle(
    fontSize: 18, fontWeight: AppFont.fontWeightBold, color: oxfordBlue));

TextStyle primaryButtonText(context) => (TextStyle(
    fontWeight: AppFont.fontWeightSemiBold, fontSize: 18, color: Colors.white));

TextStyle dashboardTopupText(context) => (TextStyle(
      fontWeight: AppFont.fontWeightSemiBold,
      fontSize: getScreenWidth(context) <= 300
          ? 14
          : getScreenWidth(context) >= 450
              ? 18
              : 16,
    ));

TextStyle labels14(context) => (TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ));

TextStyle mobileButtonStyle(context) => (TextStyle(
    fontSize: 18, fontWeight: AppFont.fontWeightRegular, color: Colors.white));

TextStyle webGreyButtonStyle(context) => (TextStyle(
    fontSize: 18,
    fontWeight: AppFont.fontWeightBold,
    color: oxfordBlueTint400));

TextStyle mobileButtonSingupStyleIndividual(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightBold, color: Colors.white));

TextStyle webButtonSingupStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightBold, color: Colors.white));

TextStyle mobileButtonSingupStyleBusiness(context) => (TextStyle(
    fontSize: 14,
    fontWeight: AppFont.fontWeightBold,
    color: Color(0xff646363)));

TextStyle topupAboutSubHeading(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: black));

TextStyle errorMessageStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: error));

TextStyle noteMessageStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: orangePantone));

TextStyle successMessageStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: success));

TextStyle topupAboutSubHeadingOrange(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightBold, color: orangePantone));

TextStyle topupAboutSubHeadingOrangeWithUnderline(context) => (TextStyle(
      fontSize: 14,
      fontWeight: AppFont.fontWeightBold,
      color: orangePantone,
      decoration: TextDecoration.underline,
    ));

TextStyle mobileGreyButtonStyle(context) => (TextStyle(
    fontSize: 17,
    fontWeight: AppFont.fontWeightBold,
    color: greyButtonTextStyleColor));

TextStyle mobileUploadButtonStyle(context) => (TextStyle(
    fontSize: 16,
    fontWeight: AppFont.fontWeightMedium,
    color: uploadeButtonTextStyleColor));

TextStyle seeAllActivityText(context) => (TextStyle(
      fontSize: 16,
      fontWeight: AppFont.fontWeightSemiBold,
      color: Color(0xffFF5B00),
    ));

TextStyle findOutMoreTextStyle(context) => (TextStyle(
      fontSize: 16,
      fontWeight: AppFont.fontWeightBold,
      color: Color(0xffFF5B00),
    ));

TextStyle unSelectedTabBarTextStyle(context) => (TextStyle(
    fontSize: 16,
    fontWeight: AppFont.fontWeightRegular,
    color: Color(0xff717885)));

TextStyle payNowQrCodeStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightBold, color: oxfordBlue));

TextStyle greyTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightMedium, color: greytextcolor));
TextStyle greyTextStyleBold(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightBold, color: greytextcolor));

TextStyle blackTextStyle16(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightRegular, color: black));

TextStyle ImpNoteTextStyle16(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightRegular, color: Colors.red));

TextStyle hanBlueTextStyle16(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightRegular, color: hanBlue));

TextStyle blackTextStyle14(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: black));

TextStyle whiteTextStyle16(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightRegular, color: white));

TextStyle greyTextStyle14(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: greytextcolor));

TextStyle statusActivityStyle(context, Color statusColor) => (TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: statusColor,
    ));

TextStyle fieldTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightMedium, color: black));

TextStyle walletGridTextStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightMedium, color: black));

TextStyle walletGridTextStyle2(context) =>
    (TextStyle(fontSize: 14, fontWeight: AppFont.fontWeightBold, color: black));

TextStyle tabBarTextStyle(context) =>
    (TextStyle(fontSize: 16, fontWeight: AppFont.fontWeightBold, color: black));

TextStyle walletGridTextStyle14(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightMedium, color: black));

TextStyle loginFaceStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: orangeColor));

TextStyle loginFaceGreyStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: greyColor));

TextStyle orangeText16(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightMedium, color: orangePantone));

TextStyle orangeText18(context) => (TextStyle(
    fontSize: 18, fontWeight: AppFont.fontWeightMedium, color: orangePantone));

TextStyle gridViewTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightRegular, color: black));

TextStyle downloadStatementTextStyleStyle(context) => (TextStyle(
      fontSize: 14,
      fontWeight: AppFont.fontWeightMedium,
      color: orangeALertColor,
    ));

TextStyle totalAmountTextStyleStyleWeb(context) => (TextStyle(
      fontSize: 16,
      fontWeight: AppFont.fontWeightBold,
      color: orangeColor,
    ));

TextStyle dontHaveAccuntStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: AppFont.fontWeightRegular, color: greytextcolor));

TextStyle orangeAlertTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightBold, color: orangeALertColor));

TextStyle greySendTextStyle(context) => (TextStyle(
    fontSize: 18,
    fontWeight: AppFont.fontWeightMedium,
    color: oxfordBlueTint400));

TextStyle transferAmountTextStyle(context) =>
    (TextStyle(fontSize: 25, fontWeight: AppFont.fontWeightBold, color: black));

TextStyle appBarWelcomeText(context) => TextStyle(
    fontSize: getScreenWidth(context) < 310 ?14:getScreenWidth(context) < 350 ?16:getScreenWidth(context) < 570 ?18:23,
    // kIsWeb ? getScreenWidth(context) <= 355
    //     ? 15
    //     : getScreenWidth(context) <= 385
    //         ? 20
    //         : 23 : screenSizeWidth < 385 ? 18 : 23,
    fontWeight: FontWeight.w700,
    color: Color(0xff152728));

TextStyle appBarDateAndTimeText(context) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff717885));

TextStyle readMoreAboutTextStyle(context) => (TextStyle(
    fontSize: 16, fontWeight: AppFont.fontWeightMedium, color: black));

TextStyle fairexchangeStyle(context) =>
    (TextStyle(fontSize: 20, fontWeight: AppFont.fontWeightBold, color: black));

TextStyle dashboardRecentActivityText(context) => (TextStyle(
    fontSize: 20,
    fontWeight: AppFont.fontWeightBold,
    color: Color(0xff131E33)));

TextStyle dashboardActivityNameText(context) => (TextStyle(
    fontSize: 16,
    fontWeight: AppFont.fontWeightMedium,
    color: Color(0xff424B5C)));

TextStyle dashboardListText(context) => (TextStyle(
    fontSize: 14,
    fontWeight: AppFont.fontWeightRegular,
    color: Color(0xff717885)));

TextStyle dashboardListTextBold(context) => (TextStyle(
    fontSize: 16,
    fontWeight: AppFont.fontWeightBold,
    color: Color(0xff424B5C)));

TextStyle exchangeRateHeadingTextStyle(context) => (TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: exchangeRateHeadingcolor));

TextStyle exchangeRateDataTextStyle(context) => (TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, color: exchangeRateDatacolor));

TextStyle alertbodyTextStyle14(context) => (TextStyle(
      fontSize: 14,
      fontWeight: AppFont.fontWeightMedium,
      color: oxfordBlue,
    ));

TextStyle alertbodyTextStyle14Mobile(context) => (TextStyle(
    fontSize: 14,
    fontWeight: AppFont.fontWeightMedium,
    color: black,
    height: 2));

TextStyle policyStyleHanBlue(context) => (TextStyle(
      fontSize: AppConstants.fourteen,
      fontWeight: FontWeight.w700,
      color: hanBlue,
    ));

TextStyle policyStyleBlack(context) => (TextStyle(
      fontSize: AppConstants.fourteen,
      fontWeight: FontWeight.w400,
      color: black,
    ));

BoxDecoration mobileFieldPrefixContainerStyle(context) => BoxDecoration(
      color: Color(0xffECF1FB),
      borderRadius: BorderRadius.only(
        topLeft: Radius.zero,
      ),
    );

BoxDecoration statusActivityDecorationColor(context, Color statusColor) =>
    BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: statusColor.withOpacity(0.10),
    );

BoxDecoration tabBarBoxDecoration(context) => BoxDecoration(
      color: white,
      border: Border(
        bottom: BorderSide(color: orangePantone, width: 2),
      ),
    );

BoxDecoration amountFieldDecorationStyle(context) => BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xffecf1fb),
    );

BoxDecoration activitiesContainerStyle(context) => BoxDecoration(
      border: Border.all(
        color: Color(0xffF2F2F2),
        width: 1,
      ),
      borderRadius: radiusAll5(context),
    );

BoxDecoration referralCodeContainerStyle(context) => BoxDecoration(
      color: Color(0xfff3f3f5),
      borderRadius: BorderRadius.circular(5),
    );

BoxDecoration transferModeBorder(context) => BoxDecoration(
    border: Border.all(width: 0.5, color: grey)
);

BoxDecoration transferModeHeadingBorder(context) => BoxDecoration(
  color: transferHeaderBackground,
    border: Border.all(width: 0.5, color: Colors.white60)
);

BoxDecoration circleBoxDecorationStyle(context) => BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color(0xffEEEEEE),
        width: 2,
      ),
    );

BoxDecoration circleDecoration(context) => BoxDecoration(
      color: orangePantoneTint100,
      borderRadius: radiusAll5(context),
    );

BoxDecoration formContainerBoxStyle(context) => BoxDecoration(
      color: white,
      border: Border.all(
        width: 2,
        color: lightgrey,
      ),
      borderRadius: radiusAll15(context),
    );

BoxDecoration fieldContainerStyle2(context) => BoxDecoration(
      borderRadius: radiusAll5(context),
      border: Border.all(
        color: fieldBorderColor,
      ),
    );

BoxDecoration bankDetailsContainerStyle(context) => BoxDecoration(
      borderRadius: radiusAll5(context),
      color: white,
      border: Border.all(
        color: bankdetailsBorderColor,
      ),
    );

BoxDecoration webAlertContainerStyle(context) => BoxDecoration(
      borderRadius: radiusAll8(context),
      color: lightSandColor,
      border: Border.all(
        color: alert,
      ),
    );

BoxDecoration transactionHistoryContainerStyle(context, {bool? isDisabled}) =>
    BoxDecoration(
        borderRadius: radiusAll15(context),
        color: isDisabled == true
            ? Colors.grey.shade200
            : fieldBackWhitegroundColor,
        border: isDisabled == true
            ? Border.all(color: Colors.grey, width: 0.2)
            : null,
        boxShadow: [
          BoxShadow(
              color: black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 2))
        ]);

BoxDecoration dashboardContainerStyle(context) => BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.08),
          blurRadius: 20,
          offset: Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(5),
    );

BoxDecoration tabBarChildContainerStyle(context) => BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Color(0xffF5F5F5),
        width: 1,
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(5),
        bottomRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xff7b7b7b).withOpacity(0.10),
          blurRadius: 30,
          offset: Offset(0, 15),
        ),
      ],
    );

BoxDecoration tabBarContainerStyle(context) => BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0xff7b7b7b).withOpacity(0.10),
          blurRadius: 30,
          offset: Offset(0, 15),
        ),
      ],
      color: white,
      border: Border(
        bottom: BorderSide(color: orangePantone, width: AppConstants.twoDouble),
      ),
    );

BoxDecoration tabBarChildContainerStyle2(context) => BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Color(0xffF5F5F5),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Color(0xff7b7b7b).withOpacity(0.10),
          blurRadius: 30,
          offset: Offset(0, 15),
        ),
      ],
    );

BoxDecoration tabBarChildContainerStyle2WithoutShadow(context) => BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Color(0xffF5F5F5),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(5),
    );

BoxDecoration dashboardContainerImageStyle(context) => BoxDecoration(
      image: DecorationImage(
        image: AssetImage(AppImages.containerCurves),
        fit: BoxFit.fill,
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.08),
          blurRadius: 20,
          offset: Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(5),
    );

BoxDecoration tabBarChildContainerStyle1(context) => BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Color(0xffF5F5F5),
        width: 1,
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(5),
        bottomRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xff7b7b7b).withOpacity(0.10),
          blurRadius: 30,
          offset: Offset(0, 15),
        ),
      ],
    );

BoxDecoration mobileTopUpBoxDecoration(context) => BoxDecoration(
    borderRadius: radiusAll5(context),
    color: white,
    boxShadow: [
      BoxShadow(
          color: Color(0xff7B7B7B).withOpacity(0.10),
          blurRadius: 30,
          offset: Offset(0, 15))
    ],
    border: Border.all(color: dividercolor));

TextStyle hintStyle(context) => TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: oxfordBlueTint300,
    );

TextStyle dataTableHeadingStyle(context) => TextStyle(
    fontSize: 14,
    fontWeight: AppFont.fontWeightMedium,
    color: oxfordBlueTint300);

TextStyle sgdValueText(context) => TextStyle(
    fontSize: 28, fontWeight: FontWeight.w400, color: Color(0xff152728));

TextStyle sgdValueTextBold(context) => TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xff152728));

TextStyle sgdValueTextBoldForField(context) => TextStyle(
    fontSize: getScreenWidth(context) > 340 ? 28 : 22,
    fontWeight: FontWeight.w700,
    color: Color(0xff152728));

TextStyle dashboardSingX700Text(context) => TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700, color: orangePantoneTint600);

TextStyle transferModeTableData(context) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: black);

TextStyle transferModeTableHeadingData(context) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: white);

TextStyle dashboardSingX500Text(context) => TextStyle(
    fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff131E33));

TextStyle textSpan2Bold(context) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xffFF5B00));

TextStyle textSpan1(context) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff717885));
