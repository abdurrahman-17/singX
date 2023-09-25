import 'package:flutter/material.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ResetPasswordSuccessful extends StatelessWidget {
   ResetPasswordSuccessful({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: px24DimenAll(context),
          child: Scrollbar(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).passwordResetSuccessful,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: hanBlue,
                    fontSize: AppConstants.twentyEight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sizedBoxHeight20(context),
                Text(
                  S
                      .of(context)
                      .requestForPasswordResetSuccessfulPleaseCheckEmail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppConstants.fifteen,
                  ),
                ),
                sizedBoxHeight20(context),
                sizedBoxHeight20(context),
                buildButton(
                  context,
                  name: S.of(context).backToLogin,
                  fontColor: white,
                  color: hanBlue,
                  width: AppConstants.fiveHundred,
                  onPressed: () {
                    SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
                    Navigator.pushNamedAndRemoveUntil(
                        context, loginRoute, (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
