import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'dashboard.dart';
import 'dashboard_incomplete_version.dart';

class DashboardLandingScreen extends StatefulWidget {
  DashboardLandingScreen({Key? key}) : super(key: key);

  @override
  State<DashboardLandingScreen> createState() => _DashboardLandingScreenState();
}

class _DashboardLandingScreenState extends State<DashboardLandingScreen> {
bool? data;

  // Checking Whether the user is verified or not
  getData(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getUserVerified()
        .then((value) async {
      Provider.of<CommonNotifier>(context, listen: false)
          .updateUserVerifiedBool = value;
      data = await value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     WidgetsBinding.instance.addPostFrameCallback((_) {
       getData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return Provider.of<CommonNotifier>(context, listen: false)
        .updateUserVerifiedBool ==
        false
        ? const DashBoardIncompleteVersion()
        : Dashboard() ;
  }
}
