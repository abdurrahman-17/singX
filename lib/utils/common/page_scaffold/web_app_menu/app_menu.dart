import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provide;
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/main.dart';
import 'package:singx/screens/activities/activities.dart';
import 'package:singx/screens/bank_details/bank_details.dart';
import 'package:singx/screens/change_password/change_password.dart';
import 'package:singx/screens/dashboard/dashboard_landing_screen.dart';
import 'package:singx/screens/edit_profile/edit_profile.dart';
import 'package:singx/screens/india_bill_payment/india_bill_payment.dart';
import 'package:singx/screens/manage_receiver/manage_receivers.dart';
import 'package:singx/screens/manage_sender/manage_sender.dart';
import 'package:singx/screens/manage_wallet/manage_wallet.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../shared_preference/shared_preference_mobile_web.dart';

// a map of ("page name", WidgetBuilder) pairs
final _availablePages = <String, WidgetBuilder>{
  'Dashboard': (_) => DashboardLandingScreen(),
  'Manage wallet': (_) => const ManageWallet(),
  'Manage receivers': (_) => ManageReceivers(),
  'Manage senders': (_) => ManageSender(),
  'Activities': (_) => const Activities(),
  //'Mobile top-ups': (_) => MobileTopUp(),
  'India bill payments': (_) => IndiaBillPayment(),
  'Bank details': (_) => const BankDetails(),
  // 'Rate alerts': (_) =>  RateAlerts(),
  'Processing times': (_) => ChangePassword(),
  'Terms of use': (_) => ChangePassword(),
  'Support': (_) => ChangePassword(),
  'View profile': (_) => EditProfile(),
  'Log out': (_) => EditProfile(),
};

class AppMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String countryData = "";

    SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
      countryData = value;
    });
    ScrollController scrollController = ScrollController();
    Size Sizescreen = MediaQuery.of(context).size;


    return Scaffold(
        backgroundColor: hanBlueshades400,
        body: Theme(
          data: ThemeData(
            scrollbarTheme: ScrollbarThemeData(
                thickness: MaterialStateProperty.all(7),
                trackVisibility: MaterialStateProperty.all(true),
                thumbVisibility: MaterialStateProperty.all(true),
                thumbColor: MaterialStateProperty.all(white.withOpacity(0.10))),
          ),
          child: Scrollbar(
            controller: scrollController,
            child: ListView(
              controller: scrollController,
              children: <Widget>[
                SizedBox(
                  height: Sizescreen.height * 0.04,
                ),
                Container(
                  height: 60,
                  width: 142,
                  child: Center(
                    child: Image.asset("assets/images/SingXLogoAllWhite.png"),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: Sizescreen.height * 0.05,
                ),
                for (var pageName in _availablePages.keys)
                  PageListTile(
                    image: pageName == 'Dashboard'
                        ? "assets/images/SingxwebIcon/category.png"
                        : pageName == 'Manage wallet'
                            ? AppImages.walletIcon
                            : pageName == 'Manage receivers'
                                ? AppImages.profileIcon
                                : pageName == 'Manage senders'
                                    ? AppImages.profileIcon
                                    : pageName == 'Activities'
                                        ? AppImages.activitiesIcon
                                        : pageName == 'Mobile top-ups'
                                            ? AppImages.mobileIcon
                                            : pageName == 'India bill payments'
                                                ? AppImages.indiaBillPaymentIcon
                                                : pageName == 'Bank details'
                                                    ? AppImages.bankDetailsIcon
                                                    : pageName == 'Rate alerts'
                                                        ? AppImages
                                                            .rateAlertIcon
                                                        : pageName ==
                                                                'Processing times'
                                                            ? AppImages
                                                                .processingTimesIcon
                                                            : pageName ==
                                                                    'Terms of use'
                                                                ? AppImages
                                                                    .termsandconditionIcon
                                                                : pageName ==
                                                                        'Support'
                                                                    ? AppImages
                                                                        .questionMarkIcon
                                                                    : pageName ==
                                                                            'View profile'
                                                                        ? AppImages
                                                                            .viewProfileDrawer
                                                                        : pageName ==
                                                                                'Log out'
                                                                            ? AppImages.logoutIcon
                                                                            : AppImages.activitiesIcon,
                    // 3. pass the selectedPageName as an argument
                    selectedPageName:
                        provide.Provider.of<CommonNotifier>(context)
                            .classNameData,
                    pageName: pageName,
                    onPressed: () async {

                      if (pageName == 'Dashboard') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Dashboard") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                               dashBoardRoute, (route) => false);

                        } else
                          MyApp.navigatorKey.currentState!.pushReplacementNamed(
                               dashBoardRoute);

                      } else if (pageName == 'Manage wallet') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Manage wallet") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( manageWalletRoute);

                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( manageWalletRoute);

                      } else if (pageName == 'Manage receivers') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Manage receivers") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( manageReceiverRoute);

                        } else
                          MyApp.navigatorKey.currentState!.pushNamed(manageReceiverRoute);

                      } else if (pageName == 'Manage senders') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Manage senders") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( manageSenderRoute);


                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( manageSenderRoute);


                      } else if (pageName == 'Activities') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Activities") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed(activitiesRoute);


                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( activitiesRoute);


                      } else if (pageName == 'Mobile top-ups') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Mobile top-ups") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( mobileTopUpRoute);


                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( mobileTopUpRoute);


                      } else if (pageName == 'India bill payments') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "India bill payments") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();

                          MyApp.navigatorKey.currentState!.pushNamed( indiaBillPaymentRoute);
                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( indiaBillPaymentRoute);


                      } else if (pageName == 'Bank details') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Bank details") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( bankDetailsRoute);
                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( bankDetailsRoute);
                      } else if (pageName == 'Rate alerts') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Rate alerts") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( rateAlertsRoute);

                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( rateAlertsRoute);

                      } else if (pageName == 'Processing times') {
                        SharedPreferencesMobileWeb.instance
                            .getCountry(country)
                            .then((value) {
                          if (Uri.base.toString().contains("www.singx.co")) {
                            launchUrlString(
                                'https://www.singx.co/quicktransfer');
                          } else if (value == AppConstants.singapore) {
                            launchUrlString(
                                'https://uat.singx.co/quicktransfer');
                          } else if (value == AppConstants.hongKong) {
                            launchUrlString(
                                'https://hkuat.singx.co/quicktransfer');
                          } else if (value == AppConstants.australia) {
                            launchUrlString(
                                'https://uatau.singx.co/quicktransfer');
                          }
                        });
                      } else if (pageName == 'Terms of use') {
                        SharedPreferencesMobileWeb.instance
                            .getCountry(country)
                            .then((value) {
                          if (Uri.base.toString().contains("www.singx.co")) {
                            launchUrlString(
                                'https://www.singx.co/terms-of-use');
                          } else if (value == AppConstants.singapore) {
                            launchUrlString(
                                'https://uat.singx.co/terms-of-use');
                          } else if (value == AppConstants.hongKong) {
                            launchUrlString(
                                'https://hkuat.singx.co/terms-of-use');
                          } else if (value == AppConstants.australia) {
                            launchUrlString(
                                'https://uatau.singx.co/terms-of-use');
                          }
                        });
                      } else if (pageName == 'Support') {
                        SharedPreferencesMobileWeb.instance
                            .getCountry(country)
                            .then((value) {
                          if (Uri.base.toString().contains("www.singx.co")) {
                            launchUrlString('https://www.singx.co/contact-us');
                          } else if (value == AppConstants.singapore) {
                            launchUrlString('https://uat.singx.co/contact-us');
                          } else if (value == AppConstants.hongKong) {
                            launchUrlString(
                                'https://hkuat.singx.co/contact-us');
                          } else if (value == AppConstants.australia) {
                            launchUrlString(
                                'https://uatau.singx.co/contact-us');
                          }
                        });
                      } else if (pageName == 'View profile') {
                        if (provide.Provider.of<CommonNotifier>(context,
                                    listen: false)
                                .classNameData ==
                            "Edit profile") return;
                        if (isMobile(context) || isTab(context)) {
                          MyApp.navigatorKey.currentState!.maybePop();
                          MyApp.navigatorKey.currentState!.pushNamed( editProfileRoute);

                        } else
                          MyApp.navigatorKey.currentState!.pushNamed( editProfileRoute);

                      } else if (pageName == 'Log out') {
                        logoutAlert(context);
                      }
                    },
                  ),
                sizedBoxHeight25(context),
              ],
            ),
          ),
        ));
  }
}

class PageListTile extends StatefulWidget {
  const PageListTile({
    Key? key,
    this.selectedPageName,
    required this.pageName,
    this.onPressed,
    this.image,
  }) : super(key: key);
  final String? selectedPageName;
  final String? image;
  final String pageName;
  final VoidCallback? onPressed;

  @override
  State<PageListTile> createState() => _PageListTileState();
}

class _PageListTileState extends State<PageListTile> {
  String countryData = "";

  var hongKong;

  var australia;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
      setState(() {
        countryData = value;

        hongKong = countryData == "HongKong" &&
            (widget.pageName == "Manage wallet" ||
                widget.pageName == "Mobile top-ups" ||
                widget.pageName == "India bill payments" ||
                widget.pageName == "Rate alerts" ||
                widget.pageName == "Support");

        australia = countryData == "Australia" &&
            (widget.pageName == "Manage wallet" ||
                widget.pageName == "Mobile top-ups" ||
                widget.pageName == "India bill payments" ||
                widget.pageName == "Rate alerts" ||
                widget.pageName == "Support");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return hongKong == null || australia == null
        ? SizedBox()
        : hongKong
            ? SizedBox()
            : australia
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Theme(
                      data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.selectedPageName == widget.pageName
                              ? white.withOpacity(0.20)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,

                              leading: Image.asset(
                                widget.image!,
                                height: 20,
                                width: 20,
                              ),
                              title: Text(
                                widget.pageName,
                                style:


                                    TextStyle(
                                  fontWeight:
                                      widget.selectedPageName == widget.pageName
                                          ? AppFont.fontWeightMedium
                                          : AppFont.fontWeightMedium,
                                  fontSize: (!isMobile(context) ||
                                          getScreenWidth(context) >= 1060)
                                      ? 15
                                      : 14,
                                  color: white,
                                ),
                              ),
                              onTap: widget.onPressed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}
