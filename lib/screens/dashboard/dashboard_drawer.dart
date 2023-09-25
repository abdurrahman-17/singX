import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/screens/activities/activities.dart';
import 'package:singx/screens/bank_details/bank_details.dart';
import 'package:singx/screens/change_password/change_password.dart';
import 'package:singx/screens/dashboard/dashboard_landing_screen.dart';
import 'package:singx/screens/edit_profile/edit_profile.dart';
import 'package:singx/screens/india_bill_payment/india_bill_payment.dart';
import 'package:singx/screens/manage_receiver/manage_receivers.dart';
import 'package:singx/screens/manage_sender/manage_sender.dart';
import 'package:singx/screens/manage_wallet/manage_wallet.dart';
import 'package:singx/screens/mobile_top_up/mobile_top_up.dart';
import 'package:singx/screens/rate_alerts/rate_alerts.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/split_view/split_view.dart';
import 'package:singx/utils/common/page_scaffold/web_app_menu/app_menu.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';


class DashboardDrawer extends StatefulWidget {
  final String? className;
  final bool? navigateData;

  DashboardDrawer({this.className, this.navigateData});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  DateTime? lastPressed;
  CommonNotifier commonNotifier = new CommonNotifier();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.Provider.of<CommonNotifier>(context, listen: false)
          .updateClassNameData(widget.className!);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var selectedPageBuilder;

    if (widget.className == "Dashboard")
      selectedPageBuilder = DashboardLandingScreen();
    else if (widget.className == "Manage wallet")
      selectedPageBuilder = ManageWallet();
    else if (widget.className == "Manage receivers")
      selectedPageBuilder = ManageReceivers(navigateData: widget.navigateData);
    else if (widget.className == "Manage senders")
      selectedPageBuilder = ManageSender(navigateData: widget.navigateData);
    else if (widget.className == "Activities")
      selectedPageBuilder = Activities();
    // else if (widget.className == "Mobile top-ups")
    //   selectedPageBuilder = MobileTopUp(navigateData: widget.navigateData);
    else if (widget.className == "India bill payments")
      selectedPageBuilder = IndiaBillPayment(navigateData: widget.navigateData);
    else if (widget.className == "Bank details")
      selectedPageBuilder = BankDetails();
    else if (widget.className == "Rate alerts")
      selectedPageBuilder = RateAlerts();
    else if (widget.className == "Processing times")
      selectedPageBuilder = ChangePassword();
    else if (widget.className == "Terms of use")
      selectedPageBuilder = ChangePassword();
    else if (widget.className == "Support")
      selectedPageBuilder = ChangePassword();
    else if (widget.className == "View profile")
      selectedPageBuilder = EditProfile(navigateData: widget.navigateData);

    return WillPopScope(
      onWillPop: () async {
        if (provider.Provider.of<CommonNotifier>(context, listen: false)
                    .classNameData ==
                "Manage senders" &&
            widget.navigateData == true) {
        } else if (provider.Provider.of<CommonNotifier>(context, listen: false)
                    .classNameData ==
                "Manage receivers" &&
            widget.navigateData == true) {
        } else if (provider.Provider.of<CommonNotifier>(context, listen: false)
                    .classNameData ==
                "Mobile top-ups" &&
            widget.navigateData == true) {
        } else if (provider.Provider.of<CommonNotifier>(context, listen: false)
                    .classNameData ==
                "India bill payments" &&
            widget.navigateData == false) {


        } else if (provider.Provider.of<CommonNotifier>(context, listen: false)
                    .classNameData ==
                "View profile" &&
            widget.navigateData == true) {
        } else if (provider.Provider.of<CommonNotifier>(context, listen: false)
                .classNameData ==
            
            "Dashboard") {
          if (getScreenWidth(context) > 1060) {
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushReplacementNamed(context, dashBoardRoute);
            });
          }

        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            dashBoardRoute,
                (route) => false,
          );
        }

        return Future.value(true);
      },
      child: SplitView(
        menu: AppMenu(),
        content: selectedPageBuilder,
      ),
    );
  }
}
