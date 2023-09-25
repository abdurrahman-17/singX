import 'package:flutter/material.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';

class NetworkNotAvailable extends StatelessWidget {
  const NetworkNotAvailable({Key? key}) : super(key: key);

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
              Icon(
                Icons.vpn_lock,
                size: AppConstants.hundred,
                color: grey,
              ),
              sizedBoxHeight15(context),
              Text(S.of(context).networkNotAvailable,
                  style: topUpFieldTextStyle(context)),
              sizedBoxHeight5(context),
              Text(S.of(context).checkYourInternetConnection,
                  style: alertbodyTextStyle12(context)),
              sizedBoxHeight15(context),
            ],
          ),
        ),
      ),
    );
  }
}
