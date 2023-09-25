import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplitView extends StatefulWidget {
  const SplitView({
    Key? key,
    required this.menu,
    this.content,
    this.breakpoint = 1060,
    this.menuWidth = 240,
  }) : super(key: key);
  final Widget menu;
  final Widget? content;
  final double breakpoint;
  final double menuWidth;

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  int? index;
  int compareIndex = 0;
  String _selectedCountryData = "";

  String get selectedCountryData => _selectedCountryData;

  set selectedCountryData(String value) {
    if (_selectedCountryData == value) return;
    _selectedCountryData = value;
    setState(() {});
  }

  bool? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData(context);
    });
  }

  getData(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getUserVerified()
        .then((value) async {
      Provider.of<CommonNotifier>(context, listen: false)
          .updateUserVerifiedBool = value;
      data = await value;
    });

    // await Provider.of<CommonNotifier>(context, listen: false)
    //     .updateUserVerifiedBool!;
  }


  getVerifiedData() async{
    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      selectedCountryData = await value;
      data = await Provider.of<CommonNotifier>(context, listen: false)
          .updateUserVerifiedBool;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future : getVerifiedData(),
        builder: (context, snapshot) {
          return Row(
            children: [
              data == false
                  ? SizedBox()
                  : screenWidth >= widget.breakpoint
                  ? SizedBox(
                width: widget.menuWidth,
                child: widget.menu,
              )
                  : SizedBox(),
              Expanded(
                child: Scaffold(
                  drawerEnableOpenDragGesture: false,
                  endDrawerEnableOpenDragGesture: false,
                  body: widget.content,
                  endDrawer: data == false
                      ? null
                      : getScreenWidth(context) >= 1060
                      ? null
                      : SizedBox(
                    width: widget.menuWidth,
                    child: Drawer(
                      child: widget.menu,
                    ),
                  ),
                  bottomNavigationBar: getScreenWidth(context) > 570
                      ? null
                      : selectedCountryData == AppConstants.singapore
                      ? Builder(
                    builder: (context) {
                      return BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Color(0xff26437F),
                        unselectedFontSize: 13,
                        selectedFontSize: 13,
                        onTap: (index) async {
                          if (index == 4) {
                            Scaffold.of(context).openEndDrawer();
                          } else if (index == 3) {
                            if (data == false) return;
                            launchUrlString(
                                'https://www.singx.co/contact-us');
                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(3);
                          } else if (index == 2) {
                            if (Provider.of<CommonNotifier>(context,
                                listen: false)
                                .classNameData ==
                                "Activities") return;
                            if (data == false) return;
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushReplacementNamed(
                                  context, activitiesRoute);
                            });
                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(2);
                          } else if (index == 1) {
                            if (Provider.of<CommonNotifier>(context,
                                listen: false)
                                .classNameData ==
                                "Manage wallet") return;
                            if (data == false) return;
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushReplacementNamed(
                                  context, manageWalletRoute);
                            });
                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(1);
                          } else if (index == 0) {
                            if (Provider.of<CommonNotifier>(context,
                                listen: false)
                                .classNameData ==
                                "Dashboard") return;
                            if (data == false) return;
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  dashBoardRoute, (route) => false);
                            });

                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(0);
                          }
                          setState(() {
                            this.index = index;
                            compareIndex = index;
                          });
                        },
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        items: [
                          BottomNavigationBarItem(
                              tooltip: "",
                              icon: Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 6.0),
                                    child: Image.asset(
                                      "assets/images/SingxwebIcon/category.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      color: Provider.of<CommonNotifier>(
                                          context)
                                          .classNameData ==
                                          "Dashboard"
                                          ? white
                                          : white.withOpacity(0.40),
                                    ),
                                  ),
                                ],
                              ),
                              label: "Home"),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/wallet.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "Wallet",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .classNameData ==
                                        "Manage wallet"
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                )
                              ],
                            ),
                            label: "Wallet",
                          ),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/activities.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "Activities",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .classNameData ==
                                        "Activities"
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                ),
                              ],
                            ),
                            label: "Activities",
                          ),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/questionMark.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "Support",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .classNameData ==
                                        "Support"
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                )
                              ],
                            ),
                            label: "Support",
                          ),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/more.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "More",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .bottomIndex ==
                                        4
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                )
                              ],
                            ),
                            label: "More",
                          ),
                        ],
                      );
                    },
                  )
                      : Builder(
                    builder: (context) {
                      return BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Color(0xff26437F),
                        unselectedFontSize: 13,
                        selectedFontSize: 13,
                        onTap: (index) async {
                          if (index == 3) {
                            Scaffold.of(context).openEndDrawer();
                          } else if (index == 2) {
                            if (data == false) return;
                            launchUrlString(
                                'https://www.singx.co/contact-us');
                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(3);
                          } else if (index == 1) {
                            if (Provider.of<CommonNotifier>(context,
                                listen: false)
                                .classNameData ==
                                "Activities") return;
                            if (data == false) return;
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushReplacementNamed(
                                  context, activitiesRoute);
                            });
                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(2);
                          } else if (index == 0) {
                            if (Provider.of<CommonNotifier>(context,
                                listen: false)
                                .classNameData ==
                                "Dashboard") return;
                            if (data == false) return;
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  dashBoardRoute, (route) => false);
                            });

                            Provider.of<CommonNotifier>(context,
                                listen: false)
                                .updateBottomData(0);
                          }
                          setState(() {
                            this.index = index;
                            compareIndex = index;
                          });
                        },
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        items: [
                          BottomNavigationBarItem(
                              tooltip: "",
                              icon: Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 6.0),
                                    child: Image.asset(
                                      "assets/images/SingxwebIcon/category.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      color: Provider.of<CommonNotifier>(
                                          context)
                                          .classNameData ==
                                          "Dashboard"
                                          ? white
                                          : white.withOpacity(0.40),
                                    ),
                                  ),
                                ],
                              ),
                              label: "Home"),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/activities.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "Activities",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .classNameData ==
                                        "Activities"
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                ),
                              ],
                            ),
                            label: "Activities",
                          ),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/questionMark.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "Support",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .classNameData ==
                                        "Support"
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                )
                              ],
                            ),
                            label: "Support",
                          ),
                          BottomNavigationBarItem(
                            tooltip: "",
                            icon: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 6.0),
                                  child: Image.asset(
                                    "assets/images/SingxwebIcon/more.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  "More",
                                  style: TextStyle(
                                    color:
                                    Provider.of<CommonNotifier>(context)
                                        .bottomIndex ==
                                        4
                                        ? white
                                        : white.withOpacity(0.40),
                                  ),
                                )
                              ],
                            ),
                            label: "More",
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
    );
    // narrow screen: show content, menu inside drawer
  }
}
