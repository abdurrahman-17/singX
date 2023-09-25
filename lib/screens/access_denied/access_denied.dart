import 'package:flutter/material.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class AccessDenied extends StatelessWidget {
  const AccessDenied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: px15DimenAll(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.vpn_lock, size: AppConstants.hundred, color: grey),
              sizedBoxHeight15(context),
              Text(S.of(context).accessDenied,
                  style: topUpFieldTextStyle(context)),
              sizedBoxHeight5(context),
              Text(S.of(context).unauthorizedLoginText,
                  style: alertbodyTextStyle12(context)),
              sizedBoxHeight15(context),
              buildButton(
                context,
                name: S.of(context).login,
                onPressed: () {
                  SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.apiToken);
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginRoute, (route) => false);
                },
                width: AppConstants.oneHundredAndTwenty,
                fontColor: white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
