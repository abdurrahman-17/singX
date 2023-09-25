import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/wallet_top_up_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/manage_wallet/manage_wallet_tab/top_up_now.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'manage_wallet_tab/top_about.dart';

class ManageWallet extends StatelessWidget {
  const ManageWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    startTimer(context);
    userCheck(context);
    return ChangeNotifierProvider(
      create: (context) => WalletTopUpNotifier(context),
      child: Consumer<WalletTopUpNotifier>(
          builder: (context, walletTopUpNotifier, _) {
        return DefaultTabController(
          length: AppConstants.tabBarLength,
          initialIndex: walletTopUpNotifier.selectedIndex,
          child: MouseRegion(
            onHover: (PointerEvent event) {
              handleInteraction(context);
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: handleInteraction(context),
              onTap: handleInteraction(context),
              child: PageScaffold(
                title: AppConstants.manageWallet,
                appbar: PreferredSize(
                  preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                  child: Padding(
                    padding: isMobile(context) || isTab(context)
                        ? px15DimenTop(context)
                        : px30DimenTopOnly(context),
                    child: buildAppBar(
                      context,
                      Text(
                        S.of(context).manageWallet,
                        style: appBarWelcomeText(context),
                      ),
                    ),
                  ),
                ),
                body: GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                    child: buildBody(context, walletTopUpNotifier)),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildBody(
      BuildContext context, WalletTopUpNotifier walletTopUpNotifier) {
    return SingleChildScrollView(
      primary: true,
      child:
      Padding(
        padding: px20DimenLeftRightTop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAlertGetVerified(context),
            sizedBoxHeight25(context),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tabBarView(context, walletTopUpNotifier),
                  tabBarChild(context, walletTopUpNotifier),
                  sizedBoxHeight35(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Alert message
  Widget buildAlertGetVerified(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: px12And15DimenAll(context),
      decoration: webAlertContainerStyle(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).yourSingXWallet,
            style: isMobile(context)
                ? alertbodyTextStyle14Mobile(context)
                : alertbodyTextStyle14(context),
          ),
          sizedBoxHeight15(context),
          GestureDetector(
            onTap: () {
              launchUrlString(AppConstants.singXWalletUrl);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                S.of(context).findOut,
                style: findOutMoreTextStyle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab Bar header
  Widget tabBarView(
      BuildContext context, WalletTopUpNotifier walletTopUpNotifier) {
    return Container(
      height: AppConstants.fifty,
      child: TabBar(
        onTap: (index) {
          walletTopUpNotifier.selectedIndex = index;
        },
        indicator: tabBarBoxDecoration(context),
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
                horizontal: getScreenWidth(context) < 380 ? 15 : 35,
              ),
              child: Text(S.of(context).topUPWithDAsh),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) < 380 ? AppConstants.thirtyFive : AppConstants.fiftyFive,
              ),
              child: Text(
                S.of(context).about,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab Bar child Ui
  Widget tabBarChild(
      BuildContext context, WalletTopUpNotifier walletTopUpNotifier) {
    return Container(
      width: AppConstants.sevenHundredAndFifty,
      padding: px24DimenAll(context),
      decoration: tabBarChildContainerStyle(context),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.minHeight),
            child: Column(
              children: [
                walletTopUpNotifier.selectedIndex == 0
                    ? TopUpNow()
                    : TopUpAbout(),
              ],
            ),
          );
        },
      ),
    );
  }
}
