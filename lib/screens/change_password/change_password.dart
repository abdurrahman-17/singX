import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/models/request_response/australia/change_password/change_password_request.dart';
import 'package:singx/core/models/request_response/change_password/change_password_request.dart';
import 'package:singx/core/notifier/change_password_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
    if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;
import 'package:singx/utils/common/page_scaffold/web_app_menu/app_menu.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);

  //Repository Data
  final AuthRepository changePasswordRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    var commonWidth = isMobile(context) ||
            isTab(context) ||
            getScreenWidth(context) > 800 && getScreenWidth(context) < 1100
        ? getScreenWidth(context)
        : getScreenWidth(context) / 3;
    return WillPopScope(
      onWillPop: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(AppConstants.country)
            .then((value) async {
          Navigator.pushNamedAndRemoveUntil(
              context, dashBoardRoute, (route) => false);
        });

        return Future.value(true);
      },
      child: AppInActiveCheck(
        context: context,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          endDrawer: isMobile(context) || getScreenWidth(context) > 800
              ? null
              : Drawer(
                  backgroundColor: black,
                  child: AppMenu(),
                ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: Padding(
              padding: isMobile(context) || isTab(context)
                  ? px15DimenTop(context)
                  : px30DimenTopOnly(context),
              child: buildAppBar(
                context,
                drawerVisible: false,
                Text(
                  S.of(context).changePassword,
                  style: appBarWelcomeText(context),
                ),
              ),
            ),
          ),
          body: ChangeNotifierProvider(
            create: (BuildContext context) => ChangePasswordNotifier(context),
            child: Consumer<ChangePasswordNotifier>(
              builder: (context, changePasswordNotifier, _) {
                return buildBody(context, changePasswordNotifier, commonWidth);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, ChangePasswordNotifier changePasswordNotifier, commonWidth) {
    return Center(
      child: SingleChildScrollView(
        controller: changePasswordNotifier.scrollController,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                  text: S.of(context).changeYourPassword,
                  fontSize: AppConstants.twentyFour,
                  fontWeight: FontWeight.w700,
                  fontColor: oxfordBluelight),
              sizedBoxHeight30(context),
              buildCurrentPasswordTextField(
                  context, changePasswordNotifier, commonWidth),
              sizedBoxHeight30(context),
              buildNewPasswordTextField(
                  context, changePasswordNotifier, commonWidth),
              sizedBoxHeight10(context),
              Visibility(
                  child: Text(changePasswordNotifier.errorMessage,
                      style: errorMessageStyle(context)),
                  visible: changePasswordNotifier.errorMessage != ""),
              sizedBoxHeight20(context),
              Container(
                width: commonWidth,
                child: buildText(
                    text: S.of(context).yourpasswordmustcontain,
                    fontSize: AppConstants.sixteen,
                    fontWeight: FontWeight.w700,
                    fontColor: greyButtonTextStyleColor),
              ),
              sizedBoxHeight10(context),
              buildText(
                  text: S.of(context).pleaseDontRepeatAnOldPassword,
                  fontSize: AppConstants.sixteen,
                  fontWeight: FontWeight.w700,
                  fontColor: oxfordBluelight),
              sizedBoxHeight30(context),
              Container(
                width: commonWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: buildButton(
                        context,
                        name: S.of(context).cancel,
                        fontColor: hanBlue,
                        color: hanBlueTint200,
                        onPressed: () async {
                          await SharedPreferencesMobileWeb.instance
                              .getCountry(AppConstants.country)
                              .then((value) async {
                            Navigator.pushNamed(context, dashBoardRoute);
                          });
                        },
                      ),
                    ),
                    sizedBoxwidth20(context),
                    Expanded(
                        child:
                            buildSaveButton(context, changePasswordNotifier))
                  ],
                ),
              ),
              sizedBoxHeight20(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrentPasswordTextField(
      context, ChangePasswordNotifier changePasswordNotifier, commonWidth,
      {TextEditingController? passwordController}) {
    return Selector<ChangePasswordNotifier, TextEditingController>(
        builder: (context, oldPasswordController, child) {
          return Form(
            key: changePasswordNotifier.oldPasswordKey,
            child: CommonTextField(
              onChanged: (val) {
                handleInteraction(context);
                html.eyeIssue(changePasswordNotifier.currentPasswordFocusNode);
                if(val.isNotEmpty){
                  changePasswordNotifier.oldPasswordKey.currentState!.validate();
                }
              },
              autoValidateMode: AutovalidateMode.disabled,
              width: commonWidth,
              controller: oldPasswordController,
              containerColor: containerColor,
              focusNode: changePasswordNotifier.currentPasswordFocusNode,
              hintStyle: hintStyle(context),
              isPasswordVisible: changePasswordNotifier.isCurrentPasswordVisible,
              errorStyle: TextStyle(color: errorTextField,
                  fontSize: 11.5,fontWeight: FontWeight.w500),
              suffixIcon: Theme(
                  data: Theme.of(context).copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent),
                  child: IconButton(
                    icon: changePasswordNotifier.isCurrentPasswordVisible == true
                        ? Icon(
                            AppCustomIcon.visibilityOff,
                            size: AppConstants.eighteen,
                          )
                        : Image.asset(
                            AppImages.eye,
                            height: AppConstants.twentyTwo,
                            width: AppConstants.twentyTwo,
                          ),
                    onPressed: () {
                      changePasswordNotifier.isCurrentPasswordVisible =
                          !changePasswordNotifier.isCurrentPasswordVisible;
                    },
                  )),
              maxHeight: AppConstants.fifty,
              validator: (v) {
                String? message;
                if (v!.isEmpty) {
                  message ??= '';
                  message += AppConstants.passwordOldEmptyValidation;
                }
                return message;
              },
              hintText: S.of(context).currentPassword,
            ),
          );
        },
        selector: (buildContext, changePasswordNotifier) =>
            changePasswordNotifier.oldPasswordController);
  }

  Widget buildSaveButton(BuildContext context, ChangePasswordNotifier changePasswordNotifier) {
    return buildButton(
      context,
      name: S.of(context).save,
      onPressed: () {
        changePasswordNotifier.oldPasswordKey.currentState!.validate();
        changePasswordNotifier.newPasswordKey.currentState!.validate();
        if (changePasswordNotifier.oldPasswordKey.currentState!.validate() &&changePasswordNotifier.newPasswordKey.currentState!.validate() &&
            changePasswordNotifier.countryName == AppConstants.AustraliaName) {
          if (changePasswordNotifier.newPasswordEmailController.text ==
              changePasswordNotifier.oldPasswordController.text) {
            changePasswordNotifier.errorMessage =
                S.of(context).oldPasswordAndNewPasswordAreSame;
          } else
            changePasswordRepository
                .apiChangePasswordAus(
                    ChangePasswordRequestAUS(
                        contactId: changePasswordNotifier.contactId,
                        newPassword: changePasswordNotifier
                            .newPasswordEmailController.text,
                        oldPassword:
                            changePasswordNotifier.oldPasswordController.text,
                        country: changePasswordNotifier.countryName),
                    context)
                .then((value) {
              changePasswordNotifier.errorMessage = value.toString();
            });
        } else if (changePasswordNotifier.oldPasswordKey.currentState!
            .validate() && changePasswordNotifier.newPasswordKey.currentState!
            .validate()) {
          if (changePasswordNotifier.newPasswordEmailController.text ==
              changePasswordNotifier.oldPasswordController.text) {
            changePasswordNotifier.errorMessage =
                S.of(context).oldPasswordAndNewPasswordAreSame;
          } else
            changePasswordRepository
                .apiChangePassword(
                    ChangePasswordRequest(
                      newPassword: changePasswordNotifier
                          .newPasswordEmailController.text,
                      oldPassword:
                          changePasswordNotifier.oldPasswordController.text,
                    ),
                    context)
                .then((value) {
              changePasswordNotifier.errorMessage = value.toString();
            });
        }
      },
      fontColor: white,
      color: hanBlue,
    );
  }

  Widget buildNewPasswordTextField(
      context, ChangePasswordNotifier changePasswordNotifier, commonWidth,
      {TextEditingController? passwordController}) {
    return Selector<ChangePasswordNotifier, TextEditingController>(
        builder: (context, newPasswordEmailController, child) {
          return Form(
            key: changePasswordNotifier.newPasswordKey,
            child: CommonTextField(
              controller: newPasswordEmailController,
              containerColor: containerColor,
              hintStyle: hintStyle(context),
              maxHeight: AppConstants.fifty,
              autoValidateMode: AutovalidateMode.disabled,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp("[ A-Za-z0-9_@./#&+-]")),
              ],
              errorStyle: TextStyle(color: errorTextField,
                  fontSize: 11.5,fontWeight: FontWeight.w500),
              isPasswordVisible: changePasswordNotifier.isNewPasswordVisible,
              focusNode: changePasswordNotifier.newPasswordFocusNode,
              onChanged: (value) {
                handleInteraction(context);
                changePasswordNotifier.errorMessage = "";
                html.eyeIssue(changePasswordNotifier.newPasswordFocusNode);
                if (RegExp(".*[0-9].*").hasMatch(value) &&
                    value.length >= 8 &&
                    RegExp('.*[a-z].*').hasMatch(value) &&
                    RegExp('.*[A-Z].*').hasMatch(value) &&
                    RegExp('.*?[!@#\$&*~]').hasMatch(value)) {
                  changePasswordNotifier.newPasswordKey.currentState!.validate();
                }
              },
              suffixIcon: Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: Theme(
                    data: ThemeData(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent),
                    child: IconButton(
                      icon: changePasswordNotifier.isNewPasswordVisible == true
                          ? Icon(
                              AppCustomIcon.visibilityOff,
                              size: AppConstants.eighteen,
                            )
                          : Image.asset(
                              AppImages.eye,
                              height: AppConstants.twentyTwo,
                              width: AppConstants.twentyTwo,
                            ),
                      onPressed: () {
                        changePasswordNotifier.isNewPasswordVisible =
                            !changePasswordNotifier.isNewPasswordVisible;
                      },
                    ),
                  )),
              hintText: S.of(context).newPassword,
              validator: (v) {
                String? message;
                if (v!.length < 1) {
                  message = S.of(context).pleaseEnterNewPassword;
                } else if (!RegExp(".*[0-9].*").hasMatch(v) ||
                    v.length < 8 ||
                    !RegExp('.*[a-z].*').hasMatch(v) ||
                    !RegExp('.*[A-Z].*').hasMatch(v) ||
                    !RegExp('.*?[!@#\$&*~]').hasMatch(v)) {
                  message ??= '';
                  message += AppConstants.passwordErrorMessage;
                }
                return message;
              },
              width: commonWidth,
            ),
          );
        },
        selector: (buildContext, changePasswordNotifier) =>
            changePasswordNotifier.newPasswordEmailController);
  }
}
