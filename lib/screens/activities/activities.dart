import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/activities_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/activities/activities_tab/remittance.dart';
import 'package:singx/screens/activities/activities_tab/wallet.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';

import '../../utils/shared_preference/shared_preference_mobile_web.dart';

class Activities extends StatelessWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return ChangeNotifierProvider(
      create: (context) => ActivitiesNotifier(context),
      child: Consumer<ActivitiesNotifier>(
        builder: (context, activitiesNotifier, _) {
          SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
            activitiesNotifier.countryData = value;
          });
          return DefaultTabController(
            length: AppConstants.two,
            initialIndex: activitiesNotifier.selectedIndex,
            child: PageScaffold(
              color: bankDetailsBackground,
              appbar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: Padding(
                  padding: kIsWeb ? isMobile(context) || isTab(context)
                      ? px15DimenTop(context)
                      : px30DimenTopOnly(context) : isMobileSDK(context) || isTabSDK(context)
                      ? px15DimenTop(context)
                      : px30DimenTopOnly(context) ,
                  child: buildAppBar(
                    context,
                    Text(
                      S.of(context).activities,
                      style: appBarWelcomeText(context),
                    ),
                  ),
                ),
              ),
              body: activitiesNotifier.countryData == null
                  ? SingleChildScrollView(
                    primary: true,
                    child: Padding(
                        padding: px20DimenLeftRightTop(context),
                        child: Container(
                          decoration: tabBarChildContainerStyle1(context),
                          child: SizedBox(),
                        ),
                      ),
                  )
                  : activitiesNotifier.countryData != SingaporeName
                      ? Padding(
                          padding: px20DimenLeftRightTop(context),
                          child: Container(
                            decoration: tabBarChildContainerStyle1(context),
                            child: Remittance(),
                          ),
                        )
                      : GestureDetector(
                        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                        child: buildBody(context, activitiesNotifier)),
              title: S.of(context).activities,
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(
      BuildContext context, ActivitiesNotifier activitiesNotifier) {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: px20DimenLeftRightTop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tabBarHeader(context, activitiesNotifier),
                  tabBarChild(context, activitiesNotifier),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header Name
  Widget tabBarHeader(
      BuildContext context, ActivitiesNotifier activitiesNotifier) {
    return Container(
      height: AppConstants.fifty,
      child: Align(
        alignment: Alignment.topLeft,
        child: TabBar(
          onTap: (index) {
            activitiesNotifier.selectedIndex = index;
          },
          indicator: tabBarContainerStyle(context),
          isScrollable: true,

          overlayColor: MaterialStateProperty.all(Colors.transparent),
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: oxfordBlueTint400,
          unselectedLabelStyle: unSelectedTabBarTextStyle(context),
          labelStyle: tabBarTextStyle(context),
          labelColor: black,
          tabs: [
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb ? getScreenWidth(context) < 380
                        ? AppConstants.fifteen
                        : AppConstants.thirtyFive :  screenSizeWidth < 380
                        ? AppConstants.fifteen
                        : AppConstants.thirtyFive
                ),
                child: Text(S.of(context).remittance),
              ),
            ),
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb ? getScreenWidth(context) < 380
                        ? AppConstants.thirtyFive
                        : AppConstants.fiftyFive :  screenSizeWidth < 380
                        ? AppConstants.thirtyFive
                        : AppConstants.fiftyFive
                ),
                child: Text(
                  S.of(context).wallet,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Table history for remittance and wallet
  Widget tabBarChild(
      BuildContext context, ActivitiesNotifier activitiesNotifier) {
    return Container(
      decoration: tabBarChildContainerStyle1(context),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.minHeight),
            child: IntrinsicHeight(
              child: Selector<ActivitiesNotifier, int>(
                  builder: (context, selectedIndex, child) {
                    return Column(
                      children: [
                        selectedIndex == 0 ? Remittance() : Wallet(),
                      ],
                    );
                  },
                  selector: (buildContext, activitiesNotifier) =>
                      activitiesNotifier.selectedIndex),
            ),
          );
        },
      ),
    );
  }
}
