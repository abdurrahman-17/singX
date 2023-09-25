import 'dart:async';
import 'package:flutter/material.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class SplashScreen extends StatelessWidget {
  redirectToLogin(context) async {
    Timer(
        Duration(seconds: 2),
            () {
          SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.apiToken);
          Navigator.pushNamedAndRemoveUntil(
              context, loginRoute, (route) => false);
        });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    redirectToLogin(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => CommonNotifier(),
      child: Scaffold(
        backgroundColor: hanBlueshades400,
        body: Consumer<CommonNotifier>(
          builder: (context, commonNotifier, _) {
            return Container(
              alignment: Alignment.center,
              child: Container(
                height: AppConstants.hundred,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: AppConstants.thirtyFive, right: AppConstants.thirtyFive),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(AppImages.singXLogoWhite),
                  fit: BoxFit.contain,
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}
