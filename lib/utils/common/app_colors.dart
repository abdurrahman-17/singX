import 'dart:math' as math;
import 'package:flutter/material.dart';

//General
final white = Colors.white;
final black = Color(0xFF000000);
final red = Colors.red;
final grey = Colors.grey;
final white24 = Colors.white24;

//Primary Color:
final hanBlue = Color(0xff3F70D4);
final orangePantone = Color(0xffFF5B00);
const oxfordBlue = Color(0xff131E33);
const oxfordBluelight = Color(0xff152728);
final transparent = Colors.transparent;

//Status Color

const success = Color(0xff64D030);
const error = Color(0xffFF1413);
const errorTextField = Color(0xffFD1413);
const information = Color(0xff24B8ED);
const alert = Color(0xffFFB624);
const dottedLineColor = Color(0xffECECEC);

//Shades of Primary Color:

//HanBlueTints:
const hanBlueTint100 = Color(0xffecf1fb);
final hanBlueTint200 = Color(0xffd9e2f6);
const hanBlueTint300 = Color(0xffb2c6ee);
const hanBlueTint400 = Color(0xff8ca9e5);
const hanBlueTint500 = Color(0xff658ddd);

//CaryolaBlueTints:
final caryolaBlueTint200 = Color(0xffe5f7fa);

//OrangePantoneTints:
const orangePantoneTint100 = Color(0xffffefe5);
const orangePantoneTint200 = Color(0xffffdecc);
const orangePantoneTint500 = Color(0xffff7c33);
const orangePantoneTint600 = Color(0xffff5b00);

//OxfordBlueTints:
const oxfordBlueTint100 = Color(0xffe7e8eb);
const oxfordBlueTint300 = Color(0xffA1A5AD);
const oxfordBlueTint400 = Color(0xff717885);
final oxfordBlueTint500 = Color(0xff424b5c);

//Tints of primary colors

//HanBlueshades:
const hanBlueshades400 = Color(0xff26437f);
const hanBlueshades600 = Color(0xff3f70d4);

//OrangePantoneShades:
const orangePantoneShade600 = Color(0xffff5b00);

// //Mobile BG Color
const orangeColor = Color(0xffF78330);
const greyColor = Color(0xff8B8B8B);
const blueColor = Color(0xff000141);
final loginBlueColor = Color(0xff2D4983);
const greyButtonColor = Color(0xffD6D6D6);
const greyButtonSingupColor = Color(0xfff1f1f1);
const fieldBorderColor = Color(0xffEDEDED);
const fieldBorderColorNew = Color(0xffCECFD5);
const fieldBackWhitegroundColor = Color(0xffFFFFFF);
const lightblack = Color(0xff353535);
const lightgrey = Color(0xffF6F6F6);
const containerBorderColor = Color(0xffEEEEEE);
const bankdetailsBorderColor = Color(0xffE8E8E8);

// //MobileButton TextColor
const greyButtonTextStyleColor = Color(0xff757575);
const uploadeButtonTextStyleColor = Color(0xff9097A5);

// //appColors
const drawerGreyText = Color(0xff6E6E6E);
const fieldHeadingGreyText = Color(0xff424B5C);

// //checkbox border
final checkBoxBorderColor = Color(0xffDFE2E7);

// //Text Color
const greytextcolor = Color(0xff949492);
const dividercolor = Color(0xffF5F5F5);
const exchangeRateHeadingcolor = Color(0xff717885);
const exchangeRateDatacolor = Color(0xff131E33);
const orangeALertColor = Color(0xffFF5B00);

// //Web Colors
const lightSandColor = Color(0xffFFF8E8);
const lightBlueWebColor = Color(0xffECF1FB);

const bankDetailsBackground = Color(0xffFDFEFF);
const greyWhite = Color(0x80FDFDFD);
const greyLightDarkWhite = Color(0xffFBFBFB);
const iconArrowColor = Color(0xffF7F7F7);
const clearIconColor = Color(0xffE9AA18);
const listTileexpansionColor = Color(0xff7B7B7B);
const gray85Color = Color(0xffD9D9D9);
const darkBlue99 = Color(0x9926437F);
const darkBluecc = Color(0xcc26437F);
const containerColor = Color(0x1AFFFFFF);
const transferHeaderBackground = Color(0xFF808080);

final greyShade50 = Colors.grey.shade50;
final greyShade400 = Colors.grey.shade400;

//Background Gradient
const topBarGradientRegistartion = LinearGradient(
  colors: [
    greyLightDarkWhite,
    greyWhite,
    Colors.transparent,
    greyLightDarkWhite
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0, 0.02, 0.0, 0.0],
);

colorRandom() => Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
    .withOpacity(1.0);
