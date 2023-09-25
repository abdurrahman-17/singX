import 'package:flutter/material.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';

primarywebButton(context, String text, VoidCallback? callBack) {
  return SizedBox(
    height: 42,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
            callBack == null ? oxfordBlueTint100 : orangePantone),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      onPressed: callBack == null ? null : callBack,
      child: Text(
        text,
        style: callBack == null
            ? webGreyButtonStyle(context)
            : mobileButtonStyle(context),
      ),
    ),
  );
}

primaryMobileButton(context, String text, VoidCallback? callBack) {
  return SizedBox(
    height: 55,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
            callBack == null ? greyButtonColor : orangePantone),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: callBack == null ? null : callBack,
      child: Text(
        text,
        style: callBack == null
            ? mobileGreyButtonStyle(context)
            : mobileButtonStyle(context),
      ),
    ),
  );
}

primaryMobilewithSingXIconButton(context, String text, VoidCallback? callBack) {
  return SizedBox(
    height: 55,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(orangePantone),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: callBack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            Text(
              text,
              style: mobileButtonStyle(context),
            ),
            sizedBoxWidth10(context),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                AppImages.singpassWhite,
                width: getScreenWidth(context) < 300 ? 50 : 70,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

secondaryMobileButton(context, String text, VoidCallback? callBack) {
  return SizedBox(
    height: 55,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(hanBlueshades400),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: callBack,
      child: Text(
        text,
        style: mobileButtonStyle(context),
      ),
    ),
  );
}

secondaryMobileSignupButton(context, String text, VoidCallback? callBack) {
  return SizedBox(
    height: 30,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(blueColor),
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: radiusAll5(context),
          ),
        ),
      ),
      onPressed: callBack,
      child: Text(
        text,
        style: mobileButtonSingupStyleIndividual(context),
      ),
    ),
  );
}

greyMobileSignUpButton(context, String text, VoidCallback? callBack) {
  return SizedBox(
    height: 30,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(greyButtonSingupColor),
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: radiusAll5(context),
          ),
        ),
      ),
      onPressed: callBack,
      child: Text(
        text,
        style: mobileButtonSingupStyleBusiness(context),
      ),
    ),
  );
}
