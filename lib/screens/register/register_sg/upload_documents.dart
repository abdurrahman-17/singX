import 'package:flutter/material.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBoxHeight(context, 0.40),
              buildUploadDocumentText(context),
              SizedBoxHeight(context, 0.05),
              buildButton(context,name: S.of(context).register,onPressed:()  {
                Navigator.pushNamed(context, registerRoute);
              },color: hanBlueTint200,fontColor: hanBlue,width: 300),
              SizedBoxHeight(context, 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadDocumentText(BuildContext context) {
    return buildText(
      text: 'Something went wrong - Jumio verification unsuccessful',
      fontSize: AppConstants.twenty,
      fontWeight: AppFont.fontWeightBold,
    );
  }
}
