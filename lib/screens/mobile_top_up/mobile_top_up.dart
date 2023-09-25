// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:singx/core/notifier/mobile_top_up_notifier.dart';
// import 'package:singx/generated/l10n.dart';
// import 'package:singx/main.dart';
// import 'package:singx/utils/common/app_colors.dart';
// import 'package:singx/utils/common/app_constants.dart';
// import 'package:singx/utils/common/app_font.dart';
// import 'package:singx/utils/common/app_images.dart';
// import 'package:singx/utils/common/app_route_paths.dart';
// import 'package:singx/utils/common/app_screen_dimen.dart';
// import 'package:singx/utils/common/app_text_style.dart';
// import 'package:singx/utils/common/app_widgets.dart';
// import 'package:singx/utils/common/dummy_data.dart';
// import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
// import 'package:singx/utils/helper_widget/widget_helper.dart';
// import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:url_launcher/url_launcher_string.dart';
//
// class MobileTopUp extends StatefulWidget {
//   bool? navigateData;
//
//   MobileTopUp({Key? key, this.navigateData}) : super(key: key);
//
//   @override
//   State<MobileTopUp> createState() => _MobileTopUpState();
// }
//
// int rowsPerPage = 6;
// List<PagingProduct> _paginatedProductData = [];
// List<PagingProduct> _products = [];
//
// class _MobileTopUpState extends State<MobileTopUp> {
//   MobileTopUpNotifier mobileTopUpNotifier = MobileTopUpNotifier();
//
//   @override
//   void initState() {
//     super.initState();
//     load(mobileTopUpNotifier);
//   }
//
//   load(MobileTopUpNotifier mobileTopUpNotifier) async {
//     //Initializing Data
//
//     mobileTopUpNotifier.employees = getMobileTransactionData();
//     mobileTopUpNotifier.mobileTransactionSource =
//         MobileTransactionSource(employeeData: mobileTopUpNotifier.employees);
//
//     _products = List.from(populateData());
//     if (_products.isNotEmpty && _products.length > 0) {
//       _paginatedProductData = _products
//           .getRange(
//               0,
//               _products.length > 6
//                   ? 6
//                   : _products.length > 4
//                       ? 4
//                       : _products.length)
//           .toList(growable: false);
//     }
//     mobileTopUpNotifier.pageCount =
//         (_products.length / rowsPerPage).ceilToDouble();
//   }
//
//   Widget loadListView(BoxConstraints constraints, context,
//       MobileTopUpNotifier mobileTopUpNotifier) {
//     List<Widget> _getChildren() {
//       final List<Widget> stackChildren = [];
//       if (_products.isNotEmpty) {
//         stackChildren.add(
//           (GridView.custom(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: getScreenWidth(context) < 580 ? 1 : 2,
//                 crossAxisSpacing: AppConstants.fifteen,
//                 mainAxisSpacing: AppConstants.fifteen,
//                 childAspectRatio: getScreenWidth(context) > 550 &&
//                         getScreenWidth(context) < 750
//                     ? 2.5
//                     : 3),
//             childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder),
//           )),
//         );
//       }
//
//       if (mobileTopUpNotifier.showLoadingIndicator) {
//         stackChildren.add(Container(
//           color: Colors.transparent,
//           width: constraints.maxWidth,
//           height: constraints.maxHeight,
//           child: Align(
//             alignment: Alignment.center,
//             child: defaultTargetPlatform == TargetPlatform.iOS
//                 ? CupertinoActivityIndicator(
//                     radius: 30,
//                   )
//                 : CircularProgressIndicator(
//                     strokeWidth: 3,
//                   ),
//           ),
//         ));
//       }
//       return stackChildren;
//     }
//
//     return Stack(
//       children: _getChildren(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     userCheck(context);
//     return buildBody(context);
//   }
//
//   Widget buildBody(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => MobileTopUpNotifier(),
//       child: Consumer<MobileTopUpNotifier>(
//         builder: (context, mobileTopUpNotifier, _) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             //Initializing Data
//             mobileTopUpNotifier.employees = getMobileTransactionData();
//             mobileTopUpNotifier.mobileTransactionSource =
//                 MobileTransactionSource(
//                     employeeData: mobileTopUpNotifier.employees);
//             _products = List.from(populateData());
//
//             mobileTopUpNotifier.pageCount =
//                 (_products.length / rowsPerPage).ceilToDouble();
//
//             mobileTopUpNotifier.isPlanSelected = widget.navigateData!;
//           });
//           return PageScaffold(
//             color: bankDetailsBackground,
//             appbar: buildAppbar(context),
//             title: S.of(context).mobileTopup + 's',
//             body: mobileTopUpNotifier.isPlanSelected == false &&
//                     mobileTopUpNotifier.isProceed == false
//                 ? Scrollbar(
//               controller: mobileTopUpNotifier.scrollController,
//                     child: SingleChildScrollView(
//                         controller: mobileTopUpNotifier.scrollController,
//                         child: Padding(
//                       padding: px20DimenAll(context),
//                       child: Column(
//                         children: [
//                           buildMobileTopUpContainer(
//                               context, mobileTopUpNotifier),
//                           sizedBoxHeight25(context),
//                           buildMobileTopUpTransactionList(
//                               context, mobileTopUpNotifier),
//                         ],
//                       ),
//                     )),
//                   )
//                 : mobileTopUpNotifier.isPlanSelected == true &&
//                         mobileTopUpNotifier.isProceed == false
//                     ? Scrollbar(
//               controller: mobileTopUpNotifier.scrollController,
//                         child: SingleChildScrollView(
//                             controller: mobileTopUpNotifier.scrollController,
//                             child: Center(
//                                 child: Container(
//                                     width: getScreenWidth(context) < 580
//                                         ? 400
//                                         : getScreenWidth(context) > 580 &&
//                                                 getScreenWidth(context) < 750
//                                             ? 580
//                                             : 750,
//                                     child: Card(
//                                         child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 20.0,
//                                                 top: 10,
//                                                 right: 20,
//                                                 bottom: 20),
//                                             child: LayoutBuilder(
//                                                 builder: (context, constraint) {
//                                               return Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   sizedBoxHeight30(context),
//                                                   Text(
//                                                       'Please Select a top-up plan to proceed.'),
//                                                   Container(
//                                                     margin:
//                                                         px10OnlyTop(context),
//                                                     padding:
//                                                         px5Top10Right5Bottom(
//                                                             context),
//                                                     height: getScreenWidth(
//                                                                 context) <=
//                                                             370
//                                                         ? AppConstants.sixty
//                                                         : AppConstants
//                                                             .fortyThree,
//                                                     child:
//                                                         horizontalListBillCategory(
//                                                       mobileTopUpNotifier,
//                                                       context: context,
//                                                       isTitle: true,
//                                                     ),
//                                                   ),
//                                                   sizedBoxHeight15(context),
//                                                   Container(
//                                                     height: 400,
//                                                     child: loadListView(
//                                                         constraint,
//                                                         context,
//                                                         mobileTopUpNotifier),
//                                                   ),
//                                                   SfDataPagerTheme(
//                                                     data: SfDataPagerThemeData(
//                                                       selectedItemTextStyle:
//                                                           whiteTextStyle16(
//                                                               context),
//                                                       itemTextStyle:
//                                                           blackTextStyle16(
//                                                               context),
//                                                       itemBorderWidth: 0.5,
//                                                       itemBorderColor:
//                                                           Colors.grey.shade300,
//                                                       itemBorderRadius:
//                                                           radiusAll12(context),
//                                                       selectedItemColor:
//                                                           hanBlue,
//                                                     ),
//                                                     child: Selector<
//                                                             MobileTopUpNotifier,
//                                                             double>(
//                                                         builder: (context,
//                                                             pageCount, child) {
//                                                           return SfDataPager(
//                                                             firstPageItemVisible:
//                                                                 false,
//                                                             lastPageItemVisible:
//                                                                 false,
//                                                             nextPageItemVisible:
//                                                                 true,
//                                                             previousPageItemVisible:
//                                                                 false,
//                                                             navigationItemHeight:
//                                                                 AppConstants
//                                                                     .fortyFive,
//                                                             navigationItemWidth:
//                                                                 AppConstants
//                                                                     .fortyFive,
//                                                             pageCount:
//                                                                 pageCount,
//                                                             onPageNavigationStart:
//                                                                 (pageIndex) {
//                                                               mobileTopUpNotifier
//                                                                       .showLoadingIndicator =
//                                                                   true;
//                                                               mobileTopUpNotifier
//                                                                   .gridAccountSelected = 0;
//                                                             },
//                                                             onPageNavigationEnd:
//                                                                 (pageIndex) {
//                                                               mobileTopUpNotifier
//                                                                       .showLoadingIndicator =
//                                                                   false;
//                                                               mobileTopUpNotifier
//                                                                   .gridAccountSelected = 0;
//                                                             },
//                                                             delegate:
//                                                                 CustomSliverChildBuilderDelegate(
//                                                                     indexBuilder),
//                                                             isMobileSize: 600,
//                                                           );
//                                                         },
//                                                         selector: (buildContext,
//                                                                 mobileTopUpNotifier) =>
//                                                             mobileTopUpNotifier
//                                                                 .pageCount),
//                                                   ),
//                                                   sizedBoxHeight15(context),
//                                                   Container(
//                                                       width: 750,
//                                                       child: Row(
//                                                         children: [
//                                                           Expanded(
//                                                               child: buildButton(
//                                                                   context,
//                                                                   name: 'Back',
//                                                                   color:
//                                                                       hanBlueTint200,
//                                                                   fontColor:
//                                                                       hanBlue,
//                                                                   onPressed:
//                                                                       () {
//                                                                         MyApp.navigatorKey.currentState!.maybePop();
//                                                           })),
//                                                           sizedBoxWidth8(
//                                                               context),
//                                                           Expanded(
//                                                               child: buildButton(
//                                                                   context,
//                                                                   name:
//                                                                       'Proceed',
//                                                                   color:
//                                                                       hanBlue,
//                                                                   fontColor:
//                                                                       white,
//                                                                   onPressed:
//                                                                       () {
//                                                             mobileTopUpNotifier
//                                                                     .isProceed =
//                                                                 true;
//                                                           })),
//                                                         ],
//                                                       ))
//                                                 ],
//                                               );
//                                             })))))),
//                       )
//                     : Scrollbar(
//               controller: mobileTopUpNotifier.scrollController,
//                         child: Center(
//                           child: Container(
//                               width: getScreenWidth(context) < 450
//                                   ? getScreenWidth(context) * 0.95
//                                   : getScreenWidth(context) < 700
//                                       ? getScreenWidth(context) * 0.8
//                                       : getScreenWidth(context) < 1000
//                                           ? getScreenWidth(context) * 0.6
//                                           : getScreenWidth(context) * 0.48,
//                               decoration: BoxDecoration(
//                                   color: white,
//                                   borderRadius: BorderRadius.circular(5)),
//                               child: SingleChildScrollView(
//                                 controller: mobileTopUpNotifier.scrollController,
//                                 child: Card(
//                                   elevation: 10,
//                                   child: Padding(
//                                     padding: px24DimenAll(context),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               'Payment Details',
//                                               style: TextStyle(
//                                                 fontSize: getScreenWidth(
//                                                             context) <=
//                                                         400
//                                                     ? AppConstants.sixteen
//                                                     : getScreenWidth(context) <=
//                                                             450
//                                                         ? AppConstants.twenty
//                                                         : AppConstants
//                                                             .twentyFour,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: oxfordBluelight,
//                                               ),
//                                             ),
//                                             IconButton(
//                                               hoverColor: Colors.transparent,
//                                               highlightColor:
//                                                   Colors.transparent,
//                                               splashColor: Colors.transparent,
//                                               onPressed: () {
//                                                 MyApp.navigatorKey.currentState!.maybePop();
//                                               },
//                                               icon: Icon(
//                                                 Icons.close,
//                                                 size: 15,
//                                                 color: oxfordBlueTint400,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         sizedBoxHeight25(context),
//                                         Container(
//                                           child: Card(
//                                             elevation: 5,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(20.0),
//                                               child: Column(
//                                                 children: [
//                                                   buildDetailRow(
//                                                       title: "Mobile Number :",
//                                                       description:
//                                                           "+91 9003206260"),
//                                                   sizedBoxHeight10(context),
//                                                   buildDetailRow(
//                                                       title: "Country :",
//                                                       description: "India"),
//                                                   sizedBoxHeight10(context),
//                                                   buildDetailRow(
//                                                       title:
//                                                           "Service Provider :",
//                                                       description:
//                                                           "Reliance Jio India Bundles"),
//                                                   sizedBoxHeight10(context),
//                                                   buildDetailRow(
//                                                       title: "Topup plan :",
//                                                       description:
//                                                           "INR ${mobileTopUpNotifier.finalInrPrice} Airtime"),
//                                                   sizedBoxHeight10(context),
//                                                   buildDetailRow(
//                                                       title: "Payment Total :",
//                                                       description:
//                                                           "SGD ${mobileTopUpNotifier.finalSgdPrice}"),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Visibility(
//                                             visible: mobileTopUpNotifier
//                                                 .isPaymentSuccess,
//                                             child: Column(
//                                               children: [
//                                                 sizedBoxHeight25(context),
//                                                 Text(
//                                                   'Payment Options',
//                                                   style: TextStyle(
//                                                     fontSize: getScreenWidth(
//                                                                 context) <=
//                                                             400
//                                                         ? AppConstants.sixteen
//                                                         : getScreenWidth(
//                                                                     context) <=
//                                                                 450
//                                                             ? AppConstants
//                                                                 .twenty
//                                                             : AppConstants
//                                                                 .twentyFour,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: oxfordBluelight,
//                                                   ),
//                                                 ),
//                                                 sizedBoxHeight25(context),
//                                                 Container(
//                                                   height: 90,
//                                                   child: Card(
//                                                     elevation: 5,
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               16.0),
//                                                       child: Row(
//                                                         children: [
//                                                           Expanded(
//                                                               flex: 1,
//                                                               child: Text(
//                                                                   'SignX Wallet(Balance SGD 87.65)')),
//                                                           Spacer(),
//                                                           buildButton(context,
//                                                               onPressed: () {
//                                                             mobileTopUpNotifier
//                                                                     .isPaymentSuccess =
//                                                                 false;
//                                                           },
//                                                               name: 'Proceed',
//                                                               color: hanBlue,
//                                                               fontColor: white,
//                                                               width: 120),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             )),
//                                         sizedBoxHeight15(context),
//                                         Align(
//                                             alignment: Alignment.center,
//                                             child: buildButton(context,
//                                                 name: 'Back',
//                                                 color: hanBlueTint200,
//                                                 fontColor: hanBlue,
//                                                 width: 140, onPressed: () {
//                                               if (mobileTopUpNotifier
//                                                       .isPaymentSuccess ==
//                                                   true) {
//                                                 mobileTopUpNotifier.isProceed =
//                                                     false;
//                                               } else {
//                                                 MyApp.navigatorKey.currentState!.maybePop();
//                                               }
//                                             }))
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                         ),
//                       ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget horizontalListBillCategory(MobileTopUpNotifier mobileTopUpNotifier,
//       {required BuildContext context, bool? isTitle}) {
//     return Container(
//       child: Scrollbar(
//         controller: mobileTopUpNotifier.scrollController,
//         thickness: AppConstants.five,
//         thumbVisibility: true,
//         child: Selector<MobileTopUpNotifier, List<MobileTopUpTitle>>(
//             builder: (context, values, child) {
//               return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 physics: BouncingScrollPhysics(),
//                 itemCount: values.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return buildMobileTopUpCategoryTitleCurvedBox(context,
//                       index: index, titles: values);
//                 },
//               );
//             },
//             selector: (buildContext, mobileTopUpNotifier) =>
//                 mobileTopUpNotifier.values),
//       ),
//     );
//   }
//
//   Widget buildMobileTopUpCategoryTitleCurvedBox(context,
//       {double? height,
//       double? width,
//       number,
//       int? index,
//       List<MobileTopUpTitle>? titles}) {
//     int? selectedIndex = 0;
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: Container(
//         padding: px2Top2Left8right2Bottom(context),
//         child: ElevatedButton(
//             child: buildText(
//               text: titles![index!].title!,
//               fontSize: AppConstants.sixteen,
//               fontWeight:
//                   titles[index].isSelected! ? FontWeight.w700 : FontWeight.w400,
//               fontColor:
//                   titles[index].isSelected! ? exchangeRateDatacolor : greyColor,
//             ),
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(white),
//               elevation: titles[index].isSelected!
//                   ? MaterialStateProperty.all<double?>(15.0)
//                   : MaterialStateProperty.all<double?>(0.0),
//               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppConstants.eighteen),
//                   side: BorderSide(
//                     width: titles[index].isSelected! ? 1.0 : 0.5,
//                     color: titles[index].isSelected!
//                         ? orangePantone
//                         : Color(0xffECECEC),
//                   ),
//                 ),
//               ),
//             ),
//             onPressed: () {
//               selectedIndex = index;
//               for (int arrIndex = 0; arrIndex < titles.length; arrIndex++) {
//                 if (arrIndex == selectedIndex) {
//                   if (this.mounted) {
//                     titles[arrIndex].isSelected = true;
//                   }
//                 } else {
//                   if (this.mounted) {
//                     titles[arrIndex].isSelected = false;
//                   }
//                 }
//               }
//             }),
//       ),
//     );
//   }
//
//   Widget buildDetailRow({title, description}) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 1,
//           child: Text(title),
//         ),
//         SizedBox(width: 5),
//         Expanded(
//             flex: 1,
//             child: Align(
//                 alignment: Alignment.centerRight, child: Text(description))),
//       ],
//     );
//   }
//
//   Widget buildAppbar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(AppConstants.appBarHeight),
//       child: Padding(
//         padding: isMobile(context) || isTab(context)
//             ? px15DimenTop(context)
//             : px30DimenTopOnly(context),
//         child: buildAppBar(
//           context,
//           Text(
//             S.of(context).mobileTopup,
//             style: appBarWelcomeText(context),
//           ),
//           backCondition: mobileTopUpNotifier.isPlanSelected == true
//               ? null
//               : () {
//             MyApp.navigatorKey.currentState!.maybePop();
//                 },
//         ),
//       ),
//     );
//   }
//
//   Widget buildMobileTopUpContainer(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return Container(
//       padding: px25DimenAll(context),
//       decoration: mobileTopUpBoxDecoration(context),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           getScreenWidth(context) >= 750
//               ? Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             S.of(context).recipientCountry,
//                             style: dropDownHeadingTextStyle(context),
//                           ),
//                           sizedBoxHeight8(context),
//                           buildCountryDropdown(context, mobileTopUpNotifier),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: getScreenWidth(context) * 0.017,
//                     ),
//                     Expanded(
//                         child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(S.of(context).serviceProvider,
//                             style: dropDownHeadingTextStyle(context)),
//                         sizedBoxHeight8(context),
//                         buildProviderDropdown(context, mobileTopUpNotifier),
//                       ],
//                     )),
//                     SizedBox(width: getScreenWidth(context) * 0.017),
//                     Expanded(child: mobileTextField(mobileTopUpNotifier)),
//                   ],
//                 )
//               : Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           S.of(context).recipientCountry,
//                           style: dropDownHeadingTextStyle(context),
//                         ),
//                         sizedBoxHeight8(context),
//                         buildCountryDropdown(context, mobileTopUpNotifier),
//                       ],
//                     ),
//                     sizedBoxHeight10(context),
//                     Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           S.of(context).serviceProvider,
//                           style: dropDownHeadingTextStyle(context),
//                         ),
//                         sizedBoxHeight8(context),
//                         buildProviderDropdown(context, mobileTopUpNotifier),
//                       ],
//                     ),
//                     SizedBox(width: getScreenWidth(context) * 0.017),
//                     sizedBoxHeight10(context),
//                     mobileTextField(mobileTopUpNotifier),
//                   ],
//                 ),
//           sizedBoxHeight20(context),
//           buildSelectThePlan(context, mobileTopUpNotifier),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSelectThePlan(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return getScreenWidth(context) >= 625
//         ? Row(
//             children: [
//               Expanded(
//                   child:
//                       buildSelectThePlanbutton(context, mobileTopUpNotifier)),
//               SizedBox(width: getScreenWidth(context) * 0.017),
//               Expanded(child: SizedBox()),
//               SizedBox(width: getScreenWidth(context) * 0.017),
//               Expanded(
//                   child: Align(
//                 alignment: Alignment.centerRight,
//                 child: buildReadMoreAbout(context),
//               )),
//             ],
//           )
//         : Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                   alignment: Alignment.center,
//                   child:
//                       buildSelectThePlanbutton(context, mobileTopUpNotifier)),
//               sizedBoxHeight8(context),
//               Align(
//                 alignment: Alignment.center,
//                 child: buildReadMoreAbout(context),
//               ),
//             ],
//           );
//   }
//
//   Widget mobileTextField(MobileTopUpNotifier mobileTopUpNotifier,
//       {TextEditingController? mobileController}) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         getScreenWidth(context) >= 750 ? SizedBox(height: 22) : SizedBox(),
//         Text(
//           S.of(context).mobileNumberWeb,
//           style: dropDownHeadingTextStyle(context),
//         ),
//         sizedBoxHeight8(context),
//         Selector<MobileTopUpNotifier, TextEditingController>(
//             builder: (context, mobileController, child) {
//               return CommonTextField(
//                   onChanged: (val) {
//                     handleInteraction(context);
//                   },
//                   helperText: ' ',
//                   keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
//                   controller: mobileController,
//                   width: isTab(context) || isMobile(context)
//                       ? double.infinity
//                       : getScreenWidth(context) * 0.32,
//                   prefixIcon: Wrap(
//                     children: [
//                       Padding(
//                         padding: (!kIsWeb)
//                             ? EdgeInsets.only(top: 1.5, left: 1.0)
//                             : isMobile(context)
//                                 ? EdgeInsets.only(top: 1.0, left: 1.0)
//                                 : EdgeInsets.only(left: 1.0),
//                         child: Container(
//                           decoration: mobileFieldPrefixContainerStyle(context),
//                           height: AppConstants.fortyFive,
//                           width: 90,
//                           child: Row(
//                             children: [
//                               sizedBoxWidth15(context),
//                               Image.asset(
//                                   mobileTopUpNotifier.selectedCountry ==
//                                           AppConstants.singapore
//                                       ? AppImages.singaporeFlag
//                                       : mobileTopUpNotifier.selectedCountry ==
//                                               AppConstants.india
//                                           ? AppImages.indiaFlag
//                                           : AppImages.hongkongFlag,
//                                   height: getScreenHeight(context) * 0.025),
//                               SizedBoxWidth(context, 0.01),
//                               buildText(
//                                   text: mobileTopUpNotifier.selectedCountry ==
//                                           AppConstants.singapore
//                                       ? singapore
//                                       : mobileTopUpNotifier.selectedCountry ==
//                                               AppConstants.india
//                                           ? india
//                                           : hongkong,
//                                   fontSize: AppConstants.sixteen),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: getScreenWidth(context) * 0.01),
//                     ],
//                   ),
//                   validatorEmptyErrorText: mobileRequired,
//                   isMobileNumberValidator: true,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(
//                       RegExp("[0-9]"),
//                     ),
//                   ],
//                   maxLength: 10);
//             },
//             selector: (buildContext, mobileTopUpNotifier) =>
//                 mobileTopUpNotifier.mobileController),
//       ],
//     );
//   }
//
//   Widget buildMobileTopUpTransactionList(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return Container(
//       padding: px15DimenAll(context),
//       decoration: mobileTopUpBoxDecoration(context),
//       child: Column(
//         children: [
//           buildFilterMethod(context, mobileTopUpNotifier),
//           sizedBoxHeight30(context),
//           buildTransactionTable(context, mobileTopUpNotifier)
//         ],
//       ),
//     );
//   }
//
//   Widget buildFilterMethod(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return Row(
//       children: [
//         Flexible(
//           child: getScreenWidth(context) >= 650
//               ? Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: buildSearchField(context, mobileTopUpNotifier),
//                     ),
//                     Spacer(),
//                     Expanded(
//                       flex: AppConstants.oneInt,
//                       child: buildDateField(context, mobileTopUpNotifier),
//                     ),
//                     sizedBoxWidth15(context),
//                     Expanded(
//                       flex: AppConstants.oneInt,
//                       child: buildStatusDropdown(context, mobileTopUpNotifier),
//                     )
//                   ],
//                 )
//               : isMobile(context)
//                   ? Column(
//                       children: [
//                         buildSearchField(context, mobileTopUpNotifier),
//                         sizedBoxHeight10(context),
//                         buildDateField(context, mobileTopUpNotifier),
//                         sizedBoxHeight10(context),
//                         buildStatusDropdown(context, mobileTopUpNotifier),
//                       ],
//                     )
//                   : Column(
//                       children: [
//                         buildSearchField(context, mobileTopUpNotifier),
//                         sizedBoxHeight15(context),
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: AppConstants.oneInt,
//                               child:
//                                   buildDateField(context, mobileTopUpNotifier),
//                             ),
//                             sizedBoxWidth10(context),
//                             Expanded(
//                               flex: AppConstants.oneInt,
//                               child: buildStatusDropdown(
//                                   context, mobileTopUpNotifier),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildSearchField(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return CommonTextField(
//       onChanged: (val) {
//         handleInteraction(context);
//       },
//       contentPadding: px16DimenLeftOnly(context),
//       hintText: S.of(context).searchWithDot,
//       hintStyle: hintStyle(context),
//       controller: mobileTopUpNotifier.SearchController,
//       width: isTab(context)
//           ? double.infinity
//           : isMobile(context)
//               ? double.infinity
//               : getScreenWidth(context) * 0.32,
//       suffixIcon: Padding(
//         padding: px16DimenRightOnly(context),
//         child: Image.asset(AppImages.searchNormal, width: 22),
//       ),
//     );
//   }
//
//   Widget buildDateField(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return Selector<MobileTopUpNotifier, TextEditingController>(
//         builder: (context, DateController, child) {
//           return CommonTextField(
//             onChanged: (val) {
//               handleInteraction(context);
//             },
//             contentPadding: px16DimenLeftOnly(context),
//             maxHeight: 20,
//             hintText: S.of(context).datewithout,
//             hintStyle: hintStyle(context),
//             controller: DateController,
//             width: isTab(context)
//                 ? getScreenWidth(context) * 0.60
//                 : isMobile(context)
//                     ? double.infinity
//                     : getScreenWidth(context) * 0.32,
//             suffixIcon: Padding(
//               padding: const EdgeInsets.only(right: 19.0),
//               child: Image.asset('assets/images/arrow-down.png',
//                   color: Color(0xff292D32)),
//             ),
//             readOnly: true,
//             onTap: () async {
//               dateTimeRangePicker(mobileTopUpNotifier);
//             },
//           );
//         },
//         selector: (buildContext, mobileTopUpNotifier) =>
//             mobileTopUpNotifier.DateController);
//   }
//
//   dateTimeRangePicker(MobileTopUpNotifier mobileTopUpNotifier) async {
//     DateTimeRange? picked = await showDateRangePicker(
//         context: context,
//         firstDate: DateTime(DateTime.now().year - 5),
//         lastDate: DateTime.now(),
//         initialDateRange: DateTimeRange(
//           end: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day + 1),
//           start: DateTime.now(),
//         ),
//         builder: (context, child) {
//           return Column(
//             children: [
//               ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: 400.0,
//                 ),
//                 child: child,
//               )
//             ],
//           );
//         });
//     final rangeStartDate = DateFormat('MM/dd').format(picked!.start).toString();
//     final rangeEndDate = DateFormat('MM/dd').format(picked.end).toString();
//     mobileTopUpNotifier.DateController.text = '$rangeStartDate - $rangeEndDate';
//   }
//
//   Widget buildStatusDropdown(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return CommonDropDownField(
//       items: selectStatus,
//       contentPadding: px16DimenLeftOnly(context),
//       hintText: S.of(context).statuswithout,
//       onChanged: (val) {
//         handleInteraction(context);
//         mobileTopUpNotifier.selectedStatus = val!;
//       },
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: fieldBorderColorNew),
//       ),
//       maxHeight: AppConstants.oneHundredFifty,
//       border: const OutlineInputBorder(),
//       hintStyle: hintStyle(context),
//       width: isTab(context)
//           ? getScreenWidth(context) * 0.60
//           : isMobile(context)
//               ? double.infinity
//               : getScreenWidth(context) * 0.32,
//       color: Colors.transparent,
//     );
//   }
//
//   Widget buildCountryDropdown(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return CommonDropDownField(
//       showSearchBox: false,
//       items: mobileTopUpNotifier.countryListData,
//       contentPadding: px16DimenLeftOnly(context),
//       hintText: S.of(context).select,
//       onChanged: (val) {
//         handleInteraction(context);
//         mobileTopUpNotifier.selectedCountry = val!;
//       },
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: fieldBorderColorNew),
//       ),
//       maxHeight: AppConstants.oneHundredFifty,
//       border: const OutlineInputBorder(),
//       hintStyle: hintStyle(context),
//       width: isTab(context)
//           ? double.infinity
//           : isMobile(context)
//               ? double.infinity
//               : getScreenWidth(context) * 0.32,
//       color: Colors.transparent,
//     );
//   }
//
//   Widget buildProviderDropdown(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return CommonDropDownField(
//         items: selectProvider,
//         showSearchBox: false,
//         contentPadding: px16DimenLeftOnly(context),
//         hintText: S.of(context).select,
//         onChanged: (val) {
//           handleInteraction(context);
//           mobileTopUpNotifier.selectedProvider = val!;
//         },
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: fieldBorderColorNew),
//         ),
//         maxHeight: AppConstants.oneHundredFifty,
//         border: const OutlineInputBorder(),
//         hintStyle: hintStyle(context),
//         width: isTab(context)
//             ? double.infinity
//             : isMobile(context)
//                 ? double.infinity
//                 : getScreenWidth(context) * 0.32,
//         color: Colors.transparent);
//   }
//
//   Widget buildTransactionTable(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return Container();
//     // return SfDataGridTheme(
//     //   data: SfDataGridThemeData(
//     //     gridLineColor: dottedLineColor,
//     //     headerHoverColor: Colors.transparent,
//     //   ),
//     //   child: Selector<MobileTopUpNotifier, MobileTransactionSource>(
//     //       builder: (context, mobileTransactionSource, child) {
//     //         return SfDataGrid(
//     //           verticalScrollPhysics: NeverScrollableScrollPhysics(),
//     //           highlightRowOnHover: false,
//     //           headerRowHeight: AppConstants.thirty,
//     //           horizontalScrollPhysics: AlwaysScrollableScrollPhysics(),
//     //           isScrollbarAlwaysShown: true,
//     //           headerGridLinesVisibility: GridLinesVisibility.none,
//     //           gridLinesVisibility: GridLinesVisibility.none,
//     //           source: mobileTransactionSource,
//     //           columnWidthMode: getScreenWidth(context) <= 825
//     //               ? ColumnWidthMode.auto
//     //               : ColumnWidthMode.fill,
//     //           columnWidthCalculationRange:
//     //               ColumnWidthCalculationRange.visibleRows,
//     //           columns: <GridColumn>[
//     //             GridColumn(
//     //               columnName: S.of(context).datewithout,
//     //               label: Container(
//     //                 alignment: Alignment.centerLeft,
//     //                 child: Column(
//     //                   mainAxisAlignment: MainAxisAlignment.center,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Text(
//     //                       S.of(context).datewithout,
//     //                       style: dataTableHeadingStyle(context),
//     //                     ),
//     //                     sizedBoxHeight8(context),
//     //                     MySeparator(
//     //                       color: dottedLineColor,
//     //                     )
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             GridColumn(
//     //               columnName: S.of(context).mobileNumberWeb,
//     //               label: Container(
//     //                 alignment: Alignment.centerLeft,
//     //                 child: Column(
//     //                   mainAxisAlignment: MainAxisAlignment.center,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Text(
//     //                       S.of(context).mobileNumberWeb,
//     //                       style: dataTableHeadingStyle(context),
//     //                     ),
//     //                     sizedBoxHeight8(context),
//     //                     MySeparator(
//     //                       color: dottedLineColor,
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             GridColumn(
//     //               columnName: S.of(context).serviceProvider,
//     //               label: Container(
//     //                 alignment: Alignment.centerLeft,
//     //                 child: Column(
//     //                   mainAxisAlignment: MainAxisAlignment.center,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Text(
//     //                       S.of(context).serviceProvider,
//     //                       style: dataTableHeadingStyle(context),
//     //                       overflow: TextOverflow.ellipsis,
//     //                     ),
//     //                     sizedBoxHeight8(context),
//     //                     MySeparator(
//     //                       color: dottedLineColor,
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             GridColumn(
//     //               columnName: S.of(context).amountPaid,
//     //               label: Container(
//     //                 alignment: Alignment.centerLeft,
//     //                 child: Column(
//     //                   mainAxisAlignment: MainAxisAlignment.center,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Text(
//     //                       S.of(context).amountPaid,
//     //                       style: dataTableHeadingStyle(context),
//     //                     ),
//     //                     sizedBoxHeight8(context),
//     //                     MySeparator(
//     //                       color: dottedLineColor,
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             GridColumn(
//     //               columnName: S.of(context).topUpAmount,
//     //               label: Container(
//     //                 alignment: Alignment.centerLeft,
//     //                 child: Column(
//     //                   mainAxisAlignment: MainAxisAlignment.center,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Text(
//     //                       S.of(context).topUpAmount,
//     //                       style: dataTableHeadingStyle(context),
//     //                     ),
//     //                     sizedBoxHeight8(context),
//     //                     MySeparator(
//     //                       color: dottedLineColor,
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             GridColumn(
//     //               columnName: S.of(context).statuswithout,
//     //               label: Container(
//     //                 alignment: Alignment.centerRight,
//     //                 child: Column(
//     //                   mainAxisAlignment: MainAxisAlignment.center,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Text(
//     //                       S.of(context).statuswithout,
//     //                       style: dataTableHeadingStyle(context),
//     //                     ),
//     //                     sizedBoxHeight8(context),
//     //                     MySeparator(
//     //                       color: dottedLineColor,
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         );
//     //       },
//     //       selector: (buildContext, mobileTopUpNotifier) =>
//     //           mobileTopUpNotifier.mobileTransactionSource),
//     // );
//   }
//
//   Widget buildSelectThePlanbutton(
//       BuildContext context, MobileTopUpNotifier mobileTopUpNotifier) {
//     return buildButtonMobile(context, name: S.of(context).selecttheplan,
//         onPressed: () async {
//       await SharedPreferencesMobileWeb.instance
//           .getCountry(country)
//           .then((value) async {
//         Navigator.pushNamed(context, selectPlanRoute);
//       });
//
//       mobileTopUpNotifier.isPlanSelected = true;
//     },
//         height: AppConstants.fortyTwo,
//         style: TextStyle(
//           fontSize: AppConstants.sixteen,
//           fontWeight: AppFont.fontWeightBold,
//           color: Colors.white,
//         ),
//         width: getScreenWidth(context) <= 625
//             ? 160.0
//             : getScreenWidth(context) * 0.245,
//         fontColor: white,
//         color: hanBlue);
//   }
//
//   Widget buildReadMoreAbout(BuildContext context) {
//     return Text.rich(
//       TextSpan(
//         text: S.of(context).readMoreAbout,
//         style: readMoreAboutTextStyle(context),
//         children: <TextSpan>[
//           TextSpan(text: ' '),
//           TextSpan(
//             recognizer: TapGestureRecognizer()
//               ..onTap = () => launchUrlString(
//                   'https://uat.singx.co/singx/MobileTopups/About'),
//             text: S.of(context).globalMobileTopupsWeb,
//             style: orangeAlertTextStyle(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget indexBuilder(BuildContext context, int index) {
//     final PagingProduct data = _paginatedProductData[index];
//     return Container(
//         width: double.infinity,
//         child: GestureDetector(
//             onTap: () {
//               mobileTopUpNotifier.gridAccountSelected = index;
//               mobileTopUpNotifier.finalInrPrice = data.inrPrice!;
//               mobileTopUpNotifier.finalSgdPrice = data.sgdPrice!;
//             },
//             child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: mobileTopUpNotifier.gridAccountSelected == index
//                         ? orangePantone
//                         : containerBorderColor,
//                     width: AppConstants.one,
//                   ),
//                   borderRadius: radiusAll10(context),
//                 ),
//                 child: Padding(
//                   padding: getScreenWidth(context) < 320
//                       ? EdgeInsets.symmetric(horizontal: 5, vertical: 0)
//                       : const EdgeInsets.only(left: 25.0, right: 25, top: 1),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset('assets/images/jio.png',
//                           height: 50, width: 50),
//                       Padding(
//                         padding: getScreenWidth(context) < 320
//                             ? EdgeInsets.only(top: 5)
//                             : const EdgeInsets.only(top: 20.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Top-up Amount',
//                               style: tabBarTextStyle(context),
//                             ),
//                             Row(
//                               children: [
//                                 SizedBoxWidth(context, 0.05),
//                                 buildText(
//                                     text: 'INR ${data.inrPrice}',
//                                     fontColor: Color(0xffFF5B00),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   'Your Cost ',
//                                   style: gridViewTextStyle(context),
//                                 ),
//                                 buildText(
//                                     text: 'SGD ${data.sgdPrice}',
//                                     fontColor: Color(0xffFF5B00),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: AppConstants.twenty,
//                         width: AppConstants.twenty,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border:
//                               mobileTopUpNotifier.gridAccountSelected == index
//                                   ? null
//                                   : Border.all(
//                                       color: containerBorderColor,
//                                       width: AppConstants.one,
//                                     ),
//                           color:
//                               mobileTopUpNotifier.gridAccountSelected == index
//                                   ? orangePantone
//                                   : white,
//                         ),
//                         child: Center(
//                           child: Container(
//                             height: AppConstants.twelve,
//                             width: AppConstants.twelve,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))));
//   }
// }
//
// class MobileTransaction {
//   MobileTransaction(this.date, this.mobileNumber, this.serviceProvider,
//       this.amountPaid, this.topUpAmount, this.status);
//
//   final String date;
//
//   final String mobileNumber;
//
//   final String serviceProvider;
//
//   final String amountPaid;
//
//   final String topUpAmount;
//
//   final String status;
// }
//
// // class MobileTransactionSource extends DataGridSource {
// //   MobileTransactionSource({required List<MobileTransaction> employeeData}) {
// //     _employeeData = employeeData
// //         .map<DataGridRow>(
// //           (e) => DataGridRow(cells: [
// //             DataGridCell<String>(columnName: date, value: e.date),
// //             DataGridCell<String>(
// //                 columnName: mobileNumber, value: e.mobileNumber),
// //             DataGridCell<String>(
// //                 columnName: serviceProvider, value: e.serviceProvider),
// //             DataGridCell<String>(
// //                 columnName: amountPaidDataTable, value: e.amountPaid),
// //             DataGridCell<String>(columnName: topUpAmount, value: e.topUpAmount),
// //             DataGridCell<String>(columnName: statusWithout, value: e.status),
// //           ]),
// //         )
// //         .toList();
// //   }
// //
// //   List<DataGridRow> _employeeData = [];
// //
// //   @override
// //   List<DataGridRow> get rows => _employeeData;
// //
// //   @override
// //   DataGridRowAdapter buildRow(DataGridRow row) {
// //     return DataGridRowAdapter(
// //       cells: row.getCells().map<Widget>((e) {
// //         return Column(
// //           children: [
// //             Spacer(),
// //             Container(
// //               padding: e.value == initiated
// //                   ? EdgeInsets.only(right: 5)
// //                   : e.value == date
// //                       ? EdgeInsets.only(left: 5)
// //                       : EdgeInsets.zero,
// //               alignment: Alignment.centerLeft,
// //               child: Text(
// //                 e.value.toString(),
// //                 style: TextStyle(
// //                     fontSize: AppConstants.fourteen,
// //                     fontWeight: AppFont.fontWeightMedium,
// //                     color: e.value == initiated ? orangeColor : black),
// //               ),
// //             ),
// //             Spacer(),
// //             Divider(
// //               color: dottedLineColor,
// //               thickness: 1,
// //             ),
// //           ],
// //         );
// //       }).toList(),
// //     );
// //   }
// // }
//
// class MobileTopUpTitle {
//   MobileTopUpTitle(this.title, this.isSelected);
//
//   String? title;
//   bool? isSelected;
// }
//
// // class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
// //     with DataPagerDelegate, ChangeNotifier {
// //   CustomSliverChildBuilderDelegate(builder) : super(builder);
// //
// //   @override
// //   int get childCount => _paginatedProductData.length;
// //
// //   @override
// //   Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
// //     int startRowIndex = newPageIndex * rowsPerPage;
// //     int endRowIndex = startRowIndex + rowsPerPage;
// //
// //     if (endRowIndex > _products.length) {
// //       endRowIndex = _products.length - 1;
// //     }
// //
// //     await Future.delayed(Duration(milliseconds: 1000));
// //     _paginatedProductData =
// //         _products.getRange(startRowIndex, endRowIndex).toList(growable: false);
// //     notifyListeners();
// //     return true;
// //   }
// //
// //   @override
// //   bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
// //     return true;
// //   }
// // }
