import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_widgets.dart';

var pixelRatio = window.devicePixelRatio;

getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

isMobile(BuildContext context) {
  return getScreenWidth(context) <= 570;
}

isMobileSDK(BuildContext context) {
  return screenSizeWidth <= 570;
}

isTab(BuildContext context) {
  return getScreenWidth(context) > 570 && getScreenWidth(context) <= 800;
}

isTabSDK(BuildContext context) {
  return screenSizeWidth > 570 && screenSizeWidth <= 800;
}

isTabForClass(BuildContext context) {
  return getScreenWidth(context) > 570 && getScreenWidth(context) <= 1060;
}

isWeb(BuildContext context) {
  return getScreenWidth(context) > 800;
}

//Padding:
px10DimenAll(context) => const EdgeInsets.all(10);

px12And10DimenAll(context) =>
    const EdgeInsets.symmetric(vertical: 10, horizontal: 12);

px5DimenAll(context) => const EdgeInsets.all(5);

px25DimenAll(context) => const EdgeInsets.all(25);

px28And25DimenAll(context) =>
    const EdgeInsets.only(left: 25, bottom: 15, right: 25);

px15DimenAll(context) => const EdgeInsets.all(15);

px5DimenVerticale(context) => const EdgeInsets.symmetric(vertical: 5);

px16DimenAll(context) => const EdgeInsets.all(16);

px16DimenHorizontal(context) => const EdgeInsets.symmetric(horizontal: 16);

px16DimenRightOnly(context) => const EdgeInsets.only(right: 16);

px16DimenLeftOnly(context) => const EdgeInsets.only(left: 16.0);

px12DimenRightOnly(context) => const EdgeInsets.only(right: 12);

px12DimenAll(context) => const EdgeInsets.all(12.0);

px20DimenAll(context) => const EdgeInsets.all(20);

px24DimenAll(context) => const EdgeInsets.all(24);

px15HorizAnd24VertDimenAll(context) =>
    const EdgeInsets.symmetric(horizontal: 15, vertical: 24);

px24NoTopDimen(context) =>
    const EdgeInsets.only(left: 24, right: 24, bottom: 24);

px15DimenHorizontal(context) => const EdgeInsets.symmetric(horizontal: 15);

px15DimenHorizontaland10Vertical(context) =>
    const EdgeInsets.symmetric(horizontal: 15, vertical: 10);

px24DimenHorizontaland16Vertical(context) =>
    const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

px15DimenHorizontalandpx12vertical(context) =>
    const EdgeInsets.symmetric(horizontal: 15, vertical: 12);

px5Top(context) => const EdgeInsets.only(top: 5.0);

px20TopAnd10Right(context) => const EdgeInsets.only(top: 20.0, right: 10.0);

px5Top10Right5Bottom(context) =>
    const EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0);

px15DimenBottom(context) => const EdgeInsets.only(bottom: 15);

px20DimenHorizontal(context) => const EdgeInsets.symmetric(horizontal: 20);

px12Horizontaland14Vertical(context) =>
    const EdgeInsets.symmetric(horizontal: 12, vertical: 14);

px8Horizontaland2Vertical(context) =>
    const EdgeInsets.symmetric(horizontal: 8, vertical: 2);

px50Horizontal(context) => const EdgeInsets.symmetric(horizontal: 50.0);

px10OnlyTop(context) => const EdgeInsets.only(top: 10.0);

px10OnlyRight(context) => const EdgeInsets.only(right: 10.0);

px10OnlyLeft(context) => const EdgeInsets.only(left: 10.0);

px8Right(context) => const EdgeInsets.only(right: 8.0);

px8RightAndBottom(context) => const EdgeInsets.only(right: 8.0, bottom: 10);

px2Top2Left8right2Bottom(context) =>
    const EdgeInsets.fromLTRB(2.0, 2.0, 8.0, 2.0);

px8DimenAll(context) => const EdgeInsets.all(8);

px15DimenLeft(context) => const EdgeInsets.only(left: 15);

px15DimenTop(context) => const EdgeInsets.only(top: 15);

px20DimenTop(context) => const EdgeInsets.only(top: 20);

px60DimenTop(context) => const EdgeInsets.only(top: 60);

px6DimenHorizontal(context) => const EdgeInsets.only(left: 6, right: 6);

px23HorizontalDimen(context) => const EdgeInsets.symmetric(horizontal: 23);

px1topandLeftDimenIcon(context) => EdgeInsets.only(top: 1.0, left: 1.0);

px24HorizontalSymmetric(context) => EdgeInsets.symmetric(horizontal: 24);

px15DimenRight(context) => const EdgeInsets.only(right: 15);

px15Horiz10VertDimen(context) =>
    const EdgeInsets.symmetric(horizontal: 15, vertical: 10);

px30DimenTopOnly(context) => const EdgeInsets.only(top: 30.0);

px5Horiz8VertDimen(context) =>
    const EdgeInsets.symmetric(vertical: 5, horizontal: 8);

px70DimenRight(context) => const EdgeInsets.only(right: 70);
px20DimenRight(context) => const EdgeInsets.only(right: 20);

px7DimenTop(context) => EdgeInsets.only(top: 7);

px20DimenLeftRightTop(context) =>
    const EdgeInsets.only(left: 20, right: 20, top: 20);

px20VertAnd30HorizDimen(context) =>
    const EdgeInsets.symmetric(vertical: 20, horizontal: 30);

px20DimenOnlyLeft(context) => const EdgeInsets.only(left: 20);

radiusAll15(context) => BorderRadius.circular(15);

radiusAll10(context) => BorderRadius.circular(10);

radiusAll8(context) => BorderRadius.circular(8);

radiusAll5(context) => BorderRadius.circular(5);

radiusAll12(context) => BorderRadius.circular(12);

bottomRadius20(context) => const BorderRadius.only(
      bottomLeft: const Radius.circular(20),
      bottomRight: const Radius.circular(20),
    );

// //SizedBox
sizedBoxHeight2(context) => const SizedBox(height: 2);

sizedBoxHeight5(context) => const SizedBox(height: 5);

sizedBoxHeight8(context) => const SizedBox(height: 8);

sizedBoxHeight12(context) => const SizedBox(height: 12);

sizedBoxHeight13(context) => const SizedBox(height: 13);

sizedBoxHeight10(context) => const SizedBox(height: 10);

sizedBoxHeight40(context) => const SizedBox(height: 40);

sizedBoxHeight45(context) => const SizedBox(height: 45);

sizedBoxHeight20(context) => const SizedBox(height: 20);

sizedBoxHeight17(context) => const SizedBox(height: 17);

sizedBoxHeight18(context) => const SizedBox(height: 18);

sizedBoxwidth20(context) => const SizedBox(width: 20);

sizedBoxHeight24(context) => const SizedBox(height: 24);

sizedBoxHeight25(context) => const SizedBox(height: 25);

sizedBoxHeight30(context) => const SizedBox(height: 30);

sizedBoxHeight14(context) => const SizedBox(height: 14);

sizedBoxHeight15(context) => const SizedBox(height: 15);

sizedBoxHeight35(context) => const SizedBox(height: 35);

sizedBoxWidth12(context) => const SizedBox(width: 12);

sizedBoxWidth20(context) => const SizedBox(width: 20);

sizedBoxWidth45(context) => const SizedBox(width: 45);

sizedBoxWidth8(context) => const SizedBox(width: 8);

sizedBoxWidth5(context) => const SizedBox(width: 5);

sizedBoxWidth3(context) => const SizedBox(width: 3);

sizedBoxWidth10(context) => const SizedBox(width: 10);

sizedBoxWidth15(context) => const SizedBox(width: 15);

SizedBoxHeight(context, height) =>
    SizedBox(height: getScreenHeight(context) * height);

SizedBoxWidth(context, width) =>
    SizedBox(width: getScreenWidth(context) * width);

px12And15DimenAll(context) =>
    const EdgeInsets.symmetric(vertical: 12, horizontal: 15);

commonSizedBoxHeight5(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.005 : screenSizeHeight * 0.005);
commonSizedBoxHeight10(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.01 : screenSizeHeight * 0.01);
commonSizedBoxHeight12(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.012 : screenSizeHeight * 0.012);
commonSizedBoxHeight15(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.015 : screenSizeHeight * 0.015);
commonSizedBoxHeight20(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.02 : screenSizeHeight * 0.02);
commonSizedBoxHeight25(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.025 : screenSizeHeight * 0.025);
commonSizedBoxHeight30(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.03 : screenSizeHeight * 0.03);
commonSizedBoxHeight40(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.04 : screenSizeHeight * 0.04);
commonSizedBoxHeight45(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.045 : screenSizeHeight * 0.045);
commonSizedBoxHeight50(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.05 : screenSizeHeight * 0.05);
commonSizedBoxHeight60(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.06 : screenSizeHeight * 0.06);
commonSizedBoxHeight80(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.08 : screenSizeHeight * 0.08);
commonSizedBoxHeight100(context) => SizedBox(height: kIsWeb ? getScreenHeight(context) * 0.10 : screenSizeHeight * 0.10);


commonSizedBoxWidth7(context) => SizedBox(width: kIsWeb ? getScreenWidth(context) * 0.007 : screenSizeWidth * 0.007);
commonSizedBoxWidth10(context) => SizedBox(width: kIsWeb ? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01);
commonSizedBoxWidth15(context) => SizedBox(width: kIsWeb ? getScreenWidth(context) * 0.015 : screenSizeWidth * 0.015);
commonSizedBoxWidth20(context) => SizedBox(width: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02);
commonSizedBoxWidth30(context) => SizedBox(width: kIsWeb ? getScreenWidth(context) * 0.03 : screenSizeWidth * 0.03);
commonSizedBoxWidth40(context) => SizedBox(width: kIsWeb ? getScreenWidth(context) * 0.04 : screenSizeWidth * 0.04);