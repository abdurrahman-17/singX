import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/data/remote/service/transaction_repository.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_request.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_response.dart';
import 'package:singx/core/models/request_response/get_invoice_transaction/get_invoice_aus_transaction.dart';
import 'package:singx/core/models/request_response/transaction/transacton_response.dart';
import 'package:singx/core/models/request_response/transaction_statment/transaction_statement_SG_request.dart';
import 'package:singx/core/models/request_response/transaction_statment/transaction_statment_request.dart';
import 'package:singx/core/notifier/activities_remittence_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class Remittance extends StatelessWidget {

  //Pagination Box Size
  double _dataPagerHeight = 55;
  //Commone width for responsive view
  var commonWidth ;

  @override
  Widget build(BuildContext context) {
    _dataPagerHeight = kIsWeb ? MediaQuery.of(context).size.width < 682 ? 105 : 55 :  screenSizeWidth < 682 ? 105 : 55;
    commonWidth = kIsWeb ? isTab(context)
        ? getScreenWidth(context) * 0.20
        : isMobile(context)
        ? double.infinity
        : getScreenWidth(context) * 0.20 : isTabSDK(context)
        ? screenSizeWidth * 0.20
        : isMobileSDK(context)
        ? double.infinity
        : screenSizeWidth * 0.20;
    userCheck(context);
    return buildBody(context);
  }

  //On Status Change Calling API
  void statusOnChangedFunction(val,context,activitiesRemittenceNotifier,statusDatas) async {
      handleInteraction(context);
      if (activitiesRemittenceNotifier.countryData ==
          AppConstants.australia) {
        for (int i = 0;
        i <
            activitiesRemittenceNotifier
                .selectedStatusDataAus.length;
        i++) {
          statusDatas.add(activitiesRemittenceNotifier
              .selectedStatusDataAus[i]["statusName"]);
          if (val ==
              activitiesRemittenceNotifier
                  .selectedStatusDataAus[i]["statusName"]) {
            activitiesRemittenceNotifier.stageID =
            activitiesRemittenceNotifier
                .selectedStatusDataAus[i]["stageId"];
          }
        }
        int contactID = await SharedPreferencesMobileWeb.instance
            .getContactId(apiContactId);
        await FxRepository()
            .apiDashboardTransactionAus(
            DashboardTransactionAustraliaRequest(
                contactId: contactID,
                stageId: activitiesRemittenceNotifier.stageID,
                allstatus: activitiesRemittenceNotifier.stageID == 0 ? true : false,
                frmdt:
                activitiesRemittenceNotifier.startDateAPI,
                todt:
                activitiesRemittenceNotifier.endDateAPI),
            context)
            .then((value) {
          List<DashboardTransactionAustraliaResponse>
          dashboardTransactionAusResponse = value as List<DashboardTransactionAustraliaResponse>;
          activitiesRemittenceNotifier.transactions.clear();
          activitiesRemittenceNotifier.orders.clear();
          activitiesRemittenceNotifier.transactions =  dashboardTransactionAusResponse;
          activitiesRemittenceNotifier.orders = dashboardTransactionAusResponse;
          activitiesRemittenceNotifier.transactionsDataPaginated.clear();
          activitiesRemittenceNotifier.pageIndex = 1;
          if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
          activitiesRemittenceNotifier.pageCount = (activitiesRemittenceNotifier.transactions.length / 10).ceil();
          int start = (activitiesRemittenceNotifier.pageIndex! -1) * 10;
          int end = start + 10;
          if (end > activitiesRemittenceNotifier.transactions.length) {
            end = activitiesRemittenceNotifier.transactions.length;
          }
          activitiesRemittenceNotifier.transactionsDataPaginated =  activitiesRemittenceNotifier.transactions.sublist(start, end);

          activitiesRemittenceNotifier.notifyListeners();
        });
      } else {
        for (int i = 0;
        i <
            activitiesRemittenceNotifier
                .selectedStatusData.length;
        i++) {
          if (activitiesRemittenceNotifier
              .selectedStatusData[i].value ==
              val) {
            activitiesRemittenceNotifier.selectedStatus =
            activitiesRemittenceNotifier
                .selectedStatusData[i].key!;
            await TransactionRepository()
                .apiActivitiesTransaction(
              activitiesRemittenceNotifier.url,
              activitiesRemittenceNotifier.startDateAPI.isNotEmpty
                  ? activitiesRemittenceNotifier.startDateAPI
                  : null,
              activitiesRemittenceNotifier.endDateAPI.isNotEmpty
                  ? activitiesRemittenceNotifier.endDateAPI
                  : null,
              activitiesRemittenceNotifier
                  .selectedStatusData[i].key,
              activitiesRemittenceNotifier.SearchController.text.isEmpty ? null : activitiesRemittenceNotifier.SearchController.text,
              activitiesRemittenceNotifier.selectedCountryFilter.isEmpty?
              null
                  :activitiesRemittenceNotifier.selectedCountryFilter,
            )
                .then((value) {
              TransactionResponse transactionResponse =
              TransactionResponse.fromJson(value);
              List<Content> empty = [];
              activitiesRemittenceNotifier.pageIndex = 1;
              if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
              activitiesRemittenceNotifier.pageCount =
                  transactionResponse.totalPages ?? 1;
              activitiesRemittenceNotifier.transactionSg =
                  transactionResponse.content ?? empty;
              activitiesRemittenceNotifier.orderSg =
                  transactionResponse.content ?? empty;
            });
          }
        }
      }
  }

  //On country Change Calling API
  void receiverCountryOnChangedFunction(val,context,activitiesRemittenceNotifier) {
    handleInteraction(context);
    activitiesRemittenceNotifier.selectedReceiverCountry.forEach((element) {
      if(val == element.value){
        activitiesRemittenceNotifier.selectedCountryFilter = element.key!;
        SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
          if (value == AppConstants.singapore || value == AppConstants.hongKong) {
            await TransactionRepository()
                .apiActivitiesTransaction(
                activitiesRemittenceNotifier.url,
                activitiesRemittenceNotifier.startDateAPI.isNotEmpty?activitiesRemittenceNotifier.startDateAPI:null,
                activitiesRemittenceNotifier.endDateAPI.isNotEmpty?activitiesRemittenceNotifier.endDateAPI:null,
                activitiesRemittenceNotifier.selectedStatus.isNotEmpty ?activitiesRemittenceNotifier.selectedStatus:null,
                activitiesRemittenceNotifier.SearchController.text.isEmpty ? null : activitiesRemittenceNotifier.SearchController.text,
                activitiesRemittenceNotifier.selectedCountryFilter)
                .then((value) {
              TransactionResponse transactionResponse =
              TransactionResponse.fromJson(value);

              List<Content> empty = [];
              activitiesRemittenceNotifier.pageIndex = 1;
              if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
              activitiesRemittenceNotifier.pageCount = transactionResponse.totalPages ?? 1;
              activitiesRemittenceNotifier.transactionSg = transactionResponse.content ?? empty;
              activitiesRemittenceNotifier.orderSg = transactionResponse.content ?? empty;
            });
          } else {
            await SharedPreferencesMobileWeb.instance
                .getContactId(apiContactId)
                .then((value) async {
              FxRepository()
                  .apiDashboardTransactionAus(
                  DashboardTransactionAustraliaRequest(
                      contactId: value,
                      stageId: activitiesRemittenceNotifier.stageID,
                      allstatus: activitiesRemittenceNotifier.stageID == 0 ? true : false,
                      frmdt: activitiesRemittenceNotifier.startDateAPI,
                      todt: activitiesRemittenceNotifier.endDateAPI),
                  context)
                  .then((value) {
                List<DashboardTransactionAustraliaResponse>
                dashboardTransactionAusResponse =
                value as List<DashboardTransactionAustraliaResponse>;
                activitiesRemittenceNotifier.transactions.clear();
                activitiesRemittenceNotifier.orders.clear();
                activitiesRemittenceNotifier.transactions = dashboardTransactionAusResponse;
                activitiesRemittenceNotifier.orders = dashboardTransactionAusResponse;
              });
            });
          }
        });
      }
    });
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivitiesRemittenceNotifier(context, AppConstants.remittance),
      child: Consumer<ActivitiesRemittenceNotifier>(
          builder: (contexts, activitiesRemittenceNotifier, _) {
            return Theme(
              data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData().copyWith(
                      trackVisibility: MaterialStateProperty.all(false),
                      thumbVisibility: MaterialStateProperty.all(false),
                      thumbColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.40),
                      ),
                      thickness: MaterialStatePropertyAll(8))),
              child: Scrollbar(
                child: Padding(
                  padding: px16DimenHorizontal(context),
                  child: Theme(
                    data: ThemeData(
                        scrollbarTheme: ScrollbarThemeData().copyWith(
                            thumbColor: MaterialStateProperty.all(
                              Colors.grey.withOpacity(0.40),
                            ),
                            thickness: MaterialStatePropertyAll(8))),
                    child: SingleChildScrollView(
                      primary: true,
                      child: Padding(
                        padding: px15DimenBottom(context),
                        child: Column(
                          children: [
                            sizedBoxHeight15(context),
                            buildFilterMethod(
                                context, activitiesRemittenceNotifier),
                            sizedBoxHeight30(context),
                            Container(
                              height: kIsWeb ? getScreenHeight(context) * 0.65 : screenSizeHeight * 0.65,
                              child: buildTransactionTable(
                                  context, activitiesRemittenceNotifier),
                            ),
                            Visibility(
                              visible: activitiesRemittenceNotifier.countryData ==
                                  AppConstants.australia &&
                                  activitiesRemittenceNotifier
                                      .orders.isNotEmpty ||
                                  activitiesRemittenceNotifier.countryData !=
                                      AppConstants.australia &&
                                      activitiesRemittenceNotifier
                                          .orderSg.isNotEmpty,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      //Calling Api To Download Statement
                                      if (activitiesRemittenceNotifier
                                          .countryData ==
                                          AustraliaName) {
                                        SharedPreferencesMobileWeb.instance
                                            .getContactId(apiContactId)
                                            .then((value) async {
                                          await TransactionRepository()
                                              .apiTransactionStatment(
                                              TransactionStatement(
                                                  contactId: value,
                                                  countryId: 0,
                                                  statusId: 17,
                                                  fromDate:
                                                  activitiesRemittenceNotifier
                                                      .startDateAPI,
                                                  toDate:
                                                  activitiesRemittenceNotifier
                                                      .endDateAPI),
                                              context);
                                        });
                                      } else {
                                        final startDate = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month - 3,
                                            DateTime.now().day);
                                        final endDate = DateTime.now();
                                        final startDateAPI =
                                            startDate.millisecondsSinceEpoch;
                                        final endDateAPI =
                                            endDate.millisecondsSinceEpoch;
                                        await TransactionRepository()
                                            .apiTransactionStatmentSG(
                                          DownloadStatementSgRequest(
                                            fromDate: activitiesRemittenceNotifier.startDateAPI.isEmpty?startDateAPI:DateFormat('yyy-MM-dd').parse(activitiesRemittenceNotifier.startDateAPI).millisecondsSinceEpoch,
                                            toDate: activitiesRemittenceNotifier.endDateAPI.isEmpty?endDateAPI:DateFormat('yyy-MM-dd').parse(activitiesRemittenceNotifier.endDateAPI).millisecondsSinceEpoch,
                                          ),
                                          context,
                                        );
                                      }
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Row(
                                        children: [
                                          Text(
                                            S.of(context).downloadStatement,
                                            style: downloadStatementTextStyleStyle(
                                                context),
                                          ),
                                          sizedBoxWidth8(context),
                                          Icon(
                                            AppCustomIcon.downloadStatement,
                                            color: orangePantoneShade600,
                                            size: AppConstants.twenty,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  sizedBoxHeight5(context),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  //Filter Methods Row
  Widget buildFilterMethod(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return Row(
      children: [
        Flexible(
          child: kIsWeb
                ? getScreenWidth(context) >= 990
                    ? buildFilterGreaterThan990(
                        context, activitiesRemittenceNotifier)
                    : isMobile(context)
                        ? buildFilterForMobile(
                            context, activitiesRemittenceNotifier)
                        : buildFilterLessThan990(
                            context, activitiesRemittenceNotifier)
                : screenSizeWidth >= 990
                    ? buildFilterGreaterThan990(
                        context, activitiesRemittenceNotifier)
                    : isMobileSDK(context)
                        ? buildFilterForMobile(
                            context, activitiesRemittenceNotifier)
                        : buildFilterLessThan990(
                            context, activitiesRemittenceNotifier)
        ),
      ],
    );
  }

  //Filter Methods For Above The Screen Size Of 990
  Widget buildFilterGreaterThan990(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return Row(
      children: [
        Visibility(
            child: Expanded(
              flex: AppConstants.two,
              child: buildSearchField(context, activitiesRemittenceNotifier),
            ),
            visible: activitiesRemittenceNotifier.countryData ==
                AppConstants.singapore),
        kIsWeb
            ? getScreenWidth(context) <= 1210 && getScreenWidth(context) >= 1060
                ? sizedBoxWidth15(context)
                : Visibility(
                    visible: activitiesRemittenceNotifier.countryData !=
                        AppConstants.singapore,
                    child: Spacer())
            : screenSizeWidth <= 1210 && screenSizeWidth >= 1060
                ? sizedBoxWidth15(context)
                : Visibility(
                    visible: activitiesRemittenceNotifier.countryData !=
                        AppConstants.singapore,
                    child: Spacer()),
        Visibility(
            visible: activitiesRemittenceNotifier.countryData != AustraliaName,
            child: Row(
              children: [
                sizedBoxWidth15(context),
                buildReceiverCountryDropDown(
                    context, activitiesRemittenceNotifier),
              ],
            )),
        sizedBoxWidth15(context),
        buildDateField(context, activitiesRemittenceNotifier),
        sizedBoxWidth15(context),
        buildStatusDropDown(context, activitiesRemittenceNotifier),
      ],
    );
  }

  //Filter Methods For Mobile
  Widget buildFilterForMobile(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return Column(
      children: [
        Visibility(
            child: buildSearchField(context, activitiesRemittenceNotifier),
            visible: activitiesRemittenceNotifier.countryData == SingaporeName),
        Visibility(
            child: Column(
              children: [
                sizedBoxHeight10(context),
                buildReceiverCountryDropDown(
                    context, activitiesRemittenceNotifier),
              ],
            ),
            visible: activitiesRemittenceNotifier.countryData != AustraliaName),
        sizedBoxHeight10(context),
        buildDateField(context, activitiesRemittenceNotifier),
        sizedBoxHeight10(context),
        buildStatusDropDown(context, activitiesRemittenceNotifier),
      ],
    );
  }

  //Filter Methods For Below the Screen Size Of 990
  Widget buildFilterLessThan990(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return Column(
      children: [
        Row(
          children: [
            Visibility(
              visible:
                  activitiesRemittenceNotifier.countryData == SingaporeName,
              child: Expanded(
                flex: AppConstants.oneInt,
                child: buildSearchField(context, activitiesRemittenceNotifier),
              ),
            ),
            Visibility(
                visible:
                    activitiesRemittenceNotifier.countryData != HongKongName,
                child: sizedBoxWidth10(context)),
            Visibility(
                visible:
                    activitiesRemittenceNotifier.countryData != AustraliaName,
                child: Expanded(
                    child: buildReceiverCountryDropDown(
                        context, activitiesRemittenceNotifier))),
          ],
        ),
        sizedBoxHeight15(context),
        Row(
          children: [
            Expanded(
              flex: AppConstants.oneInt,
              child: buildDateField(context, activitiesRemittenceNotifier),
            ),
            sizedBoxWidth10(context),
            Expanded(
              flex: AppConstants.oneInt,
              child: buildStatusDropDown(context, activitiesRemittenceNotifier),
            ),
          ],
        )
      ],
    );
  }

  //Search Data TextField
  Widget buildSearchField(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return Selector<ActivitiesRemittenceNotifier, TextEditingController>(
        builder: (context, SearchController, child) {
          return CommonTextField(
            onChanged: (val) async {
              handleInteraction(context);
              await TransactionRepository()
                  .apiActivitiesTransaction(
                activitiesRemittenceNotifier.url,
                activitiesRemittenceNotifier.startDateAPI.isEmpty ? null : activitiesRemittenceNotifier.startDateAPI,
                activitiesRemittenceNotifier.endDateAPI.isEmpty ? null : activitiesRemittenceNotifier.endDateAPI,
                activitiesRemittenceNotifier.selectedStatus.isEmpty ? null : activitiesRemittenceNotifier.selectedStatus,
                val.isEmpty ? null : val,
                activitiesRemittenceNotifier.selectedCountryFilter.isEmpty?
                null
                    :activitiesRemittenceNotifier.selectedCountryFilter,
              )
                  .then((value) {
                TransactionResponse transactionResponse =
                TransactionResponse.fromJson(value);
                List<Content> empty = [];
                activitiesRemittenceNotifier.pageIndex = 1;
                if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                activitiesRemittenceNotifier.pageCount =
                    transactionResponse.totalPages ?? 1;
                activitiesRemittenceNotifier.transactionSg =
                    transactionResponse.content ?? empty;
                activitiesRemittenceNotifier.orderSg =
                    transactionResponse.content ?? empty;
              });
            },
            contentPadding: px16DimenLeftOnly(context),
            height: AppConstants.fortyTwo,
            hintText:
            S.of(context).search + ' ' + S.of(context).transactionIDTable,
            hintStyle: hintStyle(context),
            controller: SearchController,

            width: kIsWeb
                ? isTab(context)
                    ? getScreenWidth(context) * 0.60
                    : isMobile(context)
                        ? double.infinity
                        : getScreenWidth(context) * 0.20
                : isTabSDK(context)
                    ? screenSizeWidth * 0.60
                    : isMobileSDK(context)
                        ? double.infinity
                        : screenSizeWidth * 0.20,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child:
              Image.asset(AppImages.search, width: AppConstants.twentyTwo),
            ),
          );
        },
        selector: (buildContext, activitiesRemittenceNotifier) =>
        activitiesRemittenceNotifier.SearchController);
  }

  //Filter Date TextField
  Widget buildDateField(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return Selector<ActivitiesRemittenceNotifier, TextEditingController>(
        builder: (context, DateController, child) {
          return CommonTextField(
            onChanged: (val) {
              handleInteraction(context);
            },
            contentPadding: px16DimenLeftOnly(context),
            height: AppConstants.fortyTwo,
            hintText: S.of(context).datewithout,
            hintStyle: hintStyle(context),
            controller: DateController,
            width: commonWidth,
              suffixIcon: Row(
                children: [
                  Visibility(
                    visible: DateController.text.isNotEmpty,
                    child: Container(
                      width: 40,
                      child: IconButton(onPressed: (){
                        DateController.clear();
                        DateController.text = '';
                        activitiesRemittenceNotifier.startDateAPI = '';
                        activitiesRemittenceNotifier.endDateAPI = '';
                        activitiesRemittenceNotifier.loadInitialRemmitanceData(context);
                        activitiesRemittenceNotifier.notifyListeners();
                      }, icon: Icon(Icons.close,size: 15,color: Colors.red,)),
                    ),
                  ),
                  Visibility(
                      visible: DateController.text.isEmpty,
                      child:Spacer()),
                  Padding(
                    padding: EdgeInsets.only(right:DateController.text.isEmpty ? 8.0 : 0),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xffA1A5AD).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              maxHeight: 50,
              maxWidth: 68,
            readOnly: true,
            onTap: () async {
              DateRangePickerWithYear(context,activitiesRemittenceNotifier.countryData == AustraliaName || activitiesRemittenceNotifier.selectedStartDate != null?activitiesRemittenceNotifier.selectedStartDate == null ? activitiesRemittenceNotifier.startDate : activitiesRemittenceNotifier.selectedStartDate!:null,activitiesRemittenceNotifier.countryData == AustraliaName || activitiesRemittenceNotifier.selectedEndDate != null?activitiesRemittenceNotifier.selectedEndDate == null ? activitiesRemittenceNotifier.endDate : activitiesRemittenceNotifier.selectedEndDate!:null).then((CustomRangePickerResponse value) {
                activitiesRemittenceNotifier.selectedStartDate = value.dateTime;
                activitiesRemittenceNotifier.selectedEndDate = value.dateTime2!.add(Duration(hours: 23,minutes: 59, seconds: 59));
                final rangeStartDate =
                    activitiesRemittenceNotifier.countryData == AustraliaName
                      ? DateFormat('yyyy/MM/dd').format(activitiesRemittenceNotifier.selectedStartDate!).toString()
                      : DateFormat('MM/dd/yyyy').format(activitiesRemittenceNotifier.selectedStartDate!).toString();
                final rangeEndDate =
                activitiesRemittenceNotifier.countryData == AustraliaName
                    ? DateFormat('yyyy/MM/dd').format(activitiesRemittenceNotifier.selectedEndDate!).toString()
                    : DateFormat('MM/dd/yyyy').format(activitiesRemittenceNotifier.selectedEndDate!).toString();
                activitiesRemittenceNotifier.startDateAPI =
                    DateFormat('yyy-MM-dd HH:mm:ss').format(activitiesRemittenceNotifier.selectedStartDate!).toString();
                activitiesRemittenceNotifier.endDateAPI =
                    DateFormat('yyy-MM-dd HH:mm:ss').format(activitiesRemittenceNotifier.selectedEndDate!).toString();
                activitiesRemittenceNotifier.DateController.text =
                '$rangeStartDate - $rangeEndDate';
                SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
                  if (value == AppConstants.singapore || value == AppConstants.hongKong) {
                    activitiesRemittenceNotifier.url =
                    "?page=0&size=10&filter=";
                    await TransactionRepository()
                        .apiActivitiesTransaction(
                        activitiesRemittenceNotifier.url,
                        activitiesRemittenceNotifier.startDateAPI.isEmpty ? null : activitiesRemittenceNotifier.startDateAPI,
                        activitiesRemittenceNotifier.endDateAPI.isEmpty ? null : activitiesRemittenceNotifier.endDateAPI,
                        activitiesRemittenceNotifier.selectedStatus.isEmpty ? null : activitiesRemittenceNotifier.selectedStatus,
                        activitiesRemittenceNotifier.SearchController.text.isEmpty ? null : activitiesRemittenceNotifier.SearchController.text,
                        activitiesRemittenceNotifier.selectedCountryFilter.isEmpty? null : activitiesRemittenceNotifier.selectedCountryFilter)
                        .then((value) {
                      TransactionResponse transactionResponse =
                      TransactionResponse.fromJson(value);
                      List<Content> empty = [];
                      activitiesRemittenceNotifier.pageIndex = 1;
                      if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                      activitiesRemittenceNotifier.pageCount = transactionResponse.totalPages ?? 1;
                      activitiesRemittenceNotifier.transactionSg = transactionResponse.content ?? empty;
                      activitiesRemittenceNotifier.orderSg = transactionResponse.content ?? empty;
                    });
                  } else {
                    activitiesRemittenceNotifier.startDateAPI =
                        DateFormat('yyy-MM-dd').format(activitiesRemittenceNotifier.selectedStartDate!).toString();
                    activitiesRemittenceNotifier.endDateAPI =
                        DateFormat('yyy-MM-dd').format(activitiesRemittenceNotifier.selectedEndDate!).toString();
                    await SharedPreferencesMobileWeb.instance
                        .getContactId(apiContactId)
                        .then((value) async {
                      FxRepository()
                          .apiDashboardTransactionAus(
                          DashboardTransactionAustraliaRequest(
                              contactId: value,
                              stageId: activitiesRemittenceNotifier.stageID,
                              allstatus: activitiesRemittenceNotifier.stageID == 0 ? true : false,
                              frmdt: activitiesRemittenceNotifier.startDateAPI,
                              todt: activitiesRemittenceNotifier.endDateAPI),
                          context)
                          .then((value) {
                        List<DashboardTransactionAustraliaResponse>
                        dashboardTransactionAusResponse =
                        value as List<DashboardTransactionAustraliaResponse>;
                        activitiesRemittenceNotifier.transactions.clear();
                        activitiesRemittenceNotifier.orders.clear();
                        activitiesRemittenceNotifier.transactions = dashboardTransactionAusResponse;
                        activitiesRemittenceNotifier.orders = dashboardTransactionAusResponse;
                        activitiesRemittenceNotifier.transactionsDataPaginated.clear();
                        activitiesRemittenceNotifier.pageIndex = 1;
                        if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                        activitiesRemittenceNotifier.pageCount = (activitiesRemittenceNotifier.transactions.length / 10).ceil();
                        int start = (activitiesRemittenceNotifier.pageIndex! -1) * 10;
                        int end = start + 10;
                        if (end > activitiesRemittenceNotifier.transactions.length) {
                          end = activitiesRemittenceNotifier.transactions.length;
                        }
                        activitiesRemittenceNotifier.transactionsDataPaginated =  activitiesRemittenceNotifier.transactions.sublist(start, end);
                      });
                    });
                  }
                });
              });
            },
          );
        },
        selector: (buildContext, activitiesRemittenceNotifier) =>
        activitiesRemittenceNotifier.DateController);
  }

  //Status Dropdown Field
  Widget buildStatusDropDown(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    List<String> statusDatas = [];
    if (activitiesRemittenceNotifier.countryData == AppConstants.singapore ||
        activitiesRemittenceNotifier.countryData == AppConstants.hongKong) {
      for (int i = 0;
      i < activitiesRemittenceNotifier.selectedStatusData.length;
      i++) {
        statusDatas
            .add(activitiesRemittenceNotifier.selectedStatusData[i].value!);
      }
    } else {
      for (int i = 0;
      i < activitiesRemittenceNotifier.selectedStatusDataAus.length;
      i++) {
        statusDatas.add(activitiesRemittenceNotifier.selectedStatusDataAus[i]
        ["statusName"]);
      }
    }
    return Container(
        height: 42,
        width: kIsWeb ? isWeb(context)
            ? getScreenWidth(context) * 0.20
            : getScreenWidth(context) * 0.90 : screenSizeWidth > 800 ? screenSizeWidth * 0.20 : screenSizeWidth * 0.90,
        child: LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(
              context,
              dropdownItems: statusDatas,
              controller: activitiesRemittenceNotifier.statusController,
              hintText: S.of(context).statuswithout,
              width: commonWidth,
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected onSelected, Iterable options) {
                if(statusDatas.contains("Status")){

                }else{
                  statusDatas.insert(0, "Status");
                }
                return buildDropDownContainer(
                  context,
                  options: options,
                  onSelected: onSelected,
                  dropdownData: statusDatas,
                  constraints: constraints,
                  dropDownHeight: options.first == S.of(context).noDataFound
                      ? 150
                      : options.length < 5
                      ? options.length * 50
                      : 200,
                );
              },
              validation: (val) {
                return null;
              },
              onChanged: (val) async {
                handleInteraction(context);
              },
              onSelected: (val) {
                if(val == "Status"){
                  activitiesRemittenceNotifier.statusController.clear();
                  activitiesRemittenceNotifier.selectedStatus = "";
                  activitiesRemittenceNotifier.stageID = 0;
                  activitiesRemittenceNotifier.notifyListeners();
                  activitiesRemittenceNotifier.loadInitialRemmitanceData(context);
                }
                activitiesRemittenceNotifier.url =
                "?page=0&size=10&filter=";
                statusOnChangedFunction(val,context,activitiesRemittenceNotifier,statusDatas);},
              onSubmitted: (val) {
                if(val == "Status"){
                  activitiesRemittenceNotifier.statusController.clear();
                  activitiesRemittenceNotifier.selectedStatus = "";
                  activitiesRemittenceNotifier.stageID = 0;
                  activitiesRemittenceNotifier.loadInitialRemmitanceData(context);
                }
                activitiesRemittenceNotifier.url =
                "?page=0&size=10&filter=";
                statusOnChangedFunction(val,context,activitiesRemittenceNotifier,statusDatas);}

            )));
  }

  //Receiver Country Dropdown Field
  Widget buildReceiverCountryDropDown(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    List<String> receiverCountryData = [];
      for (int i = 0; i < activitiesRemittenceNotifier.selectedReceiverCountry.length; i++) {
        receiverCountryData
            .add(activitiesRemittenceNotifier.selectedReceiverCountry[i].value!);
      }
    receiverCountryData.sort();
    return Container(
        height: 42,
        width: kIsWeb ? isWeb(context)
            ? getScreenWidth(context) * 0.18
            : getScreenWidth(context) * 0.90 :  screenSizeWidth > 800
            ? screenSizeWidth * 0.18
            : screenSizeWidth * 0.90,
        child: LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(
              context,
              dropdownItems: receiverCountryData,
              controller: activitiesRemittenceNotifier.receiverCountryController,
              width: commonWidth,
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected onSelected, Iterable options) {
                if(receiverCountryData.contains(S.of(context).receiverCountry)){

                }else{
                  receiverCountryData.insert(0, S.of(context).receiverCountry);
                }
                return buildDropDownContainer(
                  context,
                  options: options,
                  onSelected: onSelected,
                  dropdownData: receiverCountryData,
                  constraints: constraints,
                  dropDownHeight: options.first == S.of(context).noDataFound
                      ? 150
                      : options.length < 5
                      ? options.length * 50
                      : 200,
                );
              },
              validation: (val) {
                return null;
              },
              onChanged: (val) async {
                handleInteraction(context);
              },
              onSelected: (val) {
                if(val == S.of(context).receiverCountry){
                  activitiesRemittenceNotifier.receiverCountryController.clear();
                  activitiesRemittenceNotifier.selectedCountryFilter ="";
                  activitiesRemittenceNotifier.loadInitialRemmitanceData(context);
                }else {
                  activitiesRemittenceNotifier.url =
                  "?page=0&size=10&filter=";
                  receiverCountryOnChangedFunction(
                      val, context, activitiesRemittenceNotifier);
                }

              },
              onSubmitted: (val) {
                if(val == S.of(context).receiverCountry){
                  activitiesRemittenceNotifier.receiverCountryController.clear();
                  activitiesRemittenceNotifier.selectedCountryFilter ="";
                  activitiesRemittenceNotifier.loadInitialRemmitanceData(context);
                }else {
                  activitiesRemittenceNotifier.url =
                  "?page=0&size=10&filter=";
                  receiverCountryOnChangedFunction(
                      val, context, activitiesRemittenceNotifier);
                }
                },
                hintText: S.of(context).receiverCountry
            )));
  }

  //Transaction Table
  Widget buildTransactionTable(BuildContext context,
      ActivitiesRemittenceNotifier activitiesRemittenceNotifier) {
    return LayoutBuilder(
      builder: (BuildContext, constraint) {
        return Column(
          children: [
            Selector<ActivitiesRemittenceNotifier,
                 ScrollController>(
                builder: (context, data, child) {

                    return SizedBox(
                      height: constraint.maxHeight - _dataPagerHeight,
                      width: constraint.maxWidth,
                      child:  countrySelectedData == AustraliaName
                            ? activitiesRemittenceNotifier.transactions.isEmpty
                            ? Center(
                            child: Text(
                              S.of(context).noDataFound,
                              style: TextStyle(fontSize: 18),
                            ))
                            : Scrollbar(
                              thumbVisibility: true,
                              controller: activitiesRemittenceNotifier.verticalScrollController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: activitiesRemittenceNotifier.verticalScrollController,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: activitiesRemittenceNotifier.horizontalScrollController,
                                  child: SingleChildScrollView(
                          scrollDirection: getScreenWidth(context) > 1650 ? Axis.vertical : Axis.horizontal,
                          controller: activitiesRemittenceNotifier.horizontalScrollController,
                          child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: dividercolor,
                                  ),
                                  child: DataTable(
                                    dataRowHeight: 60,
                                    dividerThickness: 2,
                                    columns: [
                                      DataColumn(label: Text(S.of(context).datewithout, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).receiverWeb, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).amount, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).ratewithout, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(totalAmount, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(transactionNo, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).statuswithout, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).invoice, style: dataTableHeadingStyle(context),)),
                                    ],
                                    rows: activitiesRemittenceNotifier.transactionsDataPaginated.map((data) {
                                      TextStyle textStyleRow = TextStyle(
                                          fontSize: AppConstants.fourteen,
                                          fontWeight: AppFont.fontWeightMedium,
                                          color: black);
                                      String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(data.transactiondt!);
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(formattedDate,style: textStyleRow,)),
                                          DataCell(Text(data.recname!,style: textStyleRow,)),
                                          DataCell(Text(data.sendamnt!,style: textStyleRow,)),
                                          DataCell(Text(data.exchngrate!,style: textStyleRow,)),
                                          DataCell(Text(data.totalPayable!,style: textStyleRow,)),
                                          DataCell(Text(data.usrtxnid!,style: textStyleRow,)),
                                          DataCell(Text(data.txnstatus!,style: TextStyle(
                                              fontSize: AppConstants.fourteen,
                                              fontWeight: AppFont.fontWeightMedium,
                                              color: data.txnstatus == initiated
                                                  ? orangeColor
                                                  : data.txnstatus == validityExpired
                                                  ? error
                                                  :data.txnstatus == "Fund Transferred"
                                                  ? Colors.green
                                                  : black),)),
                                          DataCell(  data.txnstatus == "Fund Transferred" ? IconButton(
                                            mouseCursor: SystemMouseCursors.click,
                                            color: oxfordBlueTint300,
                                            onPressed: () async {
                                              await SharedPreferencesMobileWeb.instance
                                                  .getContactId(apiContactId)
                                                  .then((value) async {
                                                FxRepository().apiGetInvoiceAus(
                                                    GetInvoiceRequest(
                                                        contactId: value, userTxnId: data.usrtxnid),
                                                    context);
                                              });
                                            },
                                            icon: Icon(
                                              AppCustomIcon.documentDownload,
                                              size: AppConstants.twenty,
                                            ),
                                          ): SizedBox()),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                                ),
                              ),
                            ): activitiesRemittenceNotifier.transactionSg.isEmpty
                            ? Center(
                            child: Text(
                              S.of(context).noDataFound,
                              style: TextStyle(fontSize: 18),
                            ))
                            :Scrollbar(
                          thumbVisibility: true,
                          controller: activitiesRemittenceNotifier.verticalScrollController,
                              child: SingleChildScrollView(
                          scrollDirection: Axis.vertical ,
                                controller: activitiesRemittenceNotifier.verticalScrollController,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: activitiesRemittenceNotifier.horizontalScrollController,
                                  child: SingleChildScrollView(
                                    controller: activitiesRemittenceNotifier.horizontalScrollController,
                          scrollDirection: getScreenWidth(context) > 1650 ? Axis.vertical : Axis.horizontal,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: dividercolor,
                                      ),
                                      child: DataTable(
                                        dataRowHeight: 60,
                          dividerThickness: 2,
                          columns: [
                                      DataColumn(label: Text(S.of(context).datewithout, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).receiverWeb, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).amount, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).ratewithout, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(totalAmount, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(receiverAmount, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(transactionNo, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).statuswithout, style: dataTableHeadingStyle(context),)),
                                      DataColumn(label: Text(S.of(context).invoice, style: dataTableHeadingStyle(context),)),
                          ],
                          rows: activitiesRemittenceNotifier.transactionSg.map((data) {
                                  TextStyle textStyleRow = TextStyle(
                                          fontSize: AppConstants.fourteen,
                                          fontWeight: AppFont.fontWeightMedium,
                                          color: black);
                                  var timeStampDate =
                                  new DateTime.fromMillisecondsSinceEpoch(int.parse(data.date!));
                                  final formatter = DateFormat('yyy-MM-dd HH:mm:ss');
                                  final dateTime = formatter.parse(timeStampDate.toString());
                                  var outputFormat = DateFormat('MM/dd/yyyy');
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(outputFormat.format(dateTime),style: textStyleRow,)),
                                          DataCell(Text(data.receiverName!,style: textStyleRow,)),
                                          DataCell(Text(data.sendAmount!,style: textStyleRow,)),
                                          DataCell(Text(data.exchangeRate!,style: textStyleRow,)),
                                          DataCell(Text(data.totalPayable!,style: textStyleRow,)),
                                          DataCell(Text(data.receiveAmount!,style: textStyleRow,)),
                                          DataCell(Text(data.txnId!,style: textStyleRow,)),
                                          DataCell(Text(data.status!,style: TextStyle(
                                              fontSize: AppConstants.fourteen,
                                              fontWeight: AppFont.fontWeightMedium,
                                              color: data.status == initiated
                                                  ? orangeColor
                                                  : data.status == validityExpired
                                                  ? error
                                                  : data.status == "Payment Successful"
                                                  ? Colors.green
                                                  : black),)),
                                          DataCell(  data.status == "Payment Successful" ? IconButton(
                                            mouseCursor: SystemMouseCursors.click,
                                            color: oxfordBlueTint300,
                                            onPressed: () async {
                                                  FxRepository()
                                                      .apiGetInvoice(data.id!, context: context);
                                            },
                                            icon: Icon(
                                              AppCustomIcon.documentDownload,
                                              size: AppConstants.twenty,
                                            ),
                                          ): SizedBox()),
                                        ],
                                      );
                          }).toList(),
                        ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    );
                },
                selector: (buildContext, activitiesRemittenceNotifier) =>  activitiesRemittenceNotifier
                    .horizontalScrollController),
            sizedBoxHeight10(context),
          Visibility(
            visible:  countrySelectedData == AustraliaName ? activitiesRemittenceNotifier.transactions.isNotEmpty:activitiesRemittenceNotifier.transactionSg.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    buildPagination(context: context,iconData: Icons.first_page,isIcon: true, buttonFunction: () {
                      if(activitiesRemittenceNotifier.pageIndex == 1) return;
                      activitiesRemittenceNotifier.pageIndex = 1;
                      if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                      onPaginated(context,activitiesRemittenceNotifier);
                    }),
                    sizedBoxWidth5(context),
                    buildPagination(context: context,iconData: Icons.keyboard_arrow_left,isIcon: true, buttonFunction: () {
                      if(activitiesRemittenceNotifier.pageIndex! <= 1) return;
                      activitiesRemittenceNotifier.pageIndex = (activitiesRemittenceNotifier.pageIndex! - 1);
                      activitiesRemittenceNotifier.paginationScrollController.position.jumpTo(activitiesRemittenceNotifier.paginationScrollController.offset - AppConstants.forty);
                      onPaginated(context,activitiesRemittenceNotifier);
                    }),
                    SizedBox(
                      height: AppConstants.thirtyFive,
                        width: (getScreenWidth(context)<310||activitiesRemittenceNotifier.pageCount<=1)?AppConstants.forty:(getScreenWidth(context)<350||activitiesRemittenceNotifier.pageCount<=2)?AppConstants.eighty:AppConstants.oneHundredAndTwenty,
                      child: Center(
                        child: ListView.builder(
                            controller: activitiesRemittenceNotifier.paginationScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: activitiesRemittenceNotifier.pageCount,
                            itemBuilder: (context,index){
                                 return Padding(
                                   padding:  EdgeInsets.only(left: 5.0),
                                   child: buildPagination(context: context,isIcon: false,
                                      selectedPageCount: activitiesRemittenceNotifier.pageIndex,
                                      pageCount: (index + 1).toString(), buttonFunction: () {
                                         activitiesRemittenceNotifier.pageIndex = index + 1;
                                         onPaginated(context, activitiesRemittenceNotifier);
                                       }),
                                 );

                        }),
                      ),
                    ),
                    sizedBoxWidth5(context),
                    buildPagination(context: context,iconData: Icons.keyboard_arrow_right,isIcon: true, buttonFunction: () {
                      if(activitiesRemittenceNotifier.pageIndex! >= activitiesRemittenceNotifier.pageCount) return;
                      activitiesRemittenceNotifier.pageIndex = (activitiesRemittenceNotifier.pageIndex! + 1);
                      activitiesRemittenceNotifier.paginationScrollController.position.jumpTo(activitiesRemittenceNotifier.paginationScrollController.offset + AppConstants.forty);
                      onPaginated(context,activitiesRemittenceNotifier);
                    }),
                    sizedBoxWidth5(context),
                    buildPagination(context: context,iconData: Icons.last_page,isIcon: true, buttonFunction: () async{
                      if(activitiesRemittenceNotifier.pageIndex == activitiesRemittenceNotifier.pageCount) return;
                      if(activitiesRemittenceNotifier.paginationScrollController.hasClients) await activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.offset + 1, duration: Duration(milliseconds: 1), curve: Curves.easeIn);
                      activitiesRemittenceNotifier.pageIndex = activitiesRemittenceNotifier.pageCount;
                      if(activitiesRemittenceNotifier.paginationScrollController.hasClients)activitiesRemittenceNotifier.paginationScrollController.position.animateTo(activitiesRemittenceNotifier.paginationScrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeIn);
                      onPaginated(context,activitiesRemittenceNotifier);
                    }),
                  ],
                ),
                if(getScreenWidth(context)>500)Visibility(
                  visible:  countrySelectedData == AustraliaName ? activitiesRemittenceNotifier.transactions.isNotEmpty:activitiesRemittenceNotifier.transactionSg.isNotEmpty,
                  child: Text(
                      '${activitiesRemittenceNotifier.pageIndex!} ${"of"} ${activitiesRemittenceNotifier.pageCount} '
                          '${"pages"}',
                    style: blackTextStyle16(context)..copyWith(fontSize: activitiesRemittenceNotifier.pageIndex! > 9 || activitiesRemittenceNotifier.pageCount > 100 ?13:16,)
                  ),
                )
              ],
            ),
          ),
            sizedBoxHeight10(context),
            if(getScreenWidth(context)<500)Visibility(
              visible:  countrySelectedData == AustraliaName ? activitiesRemittenceNotifier.transactions.isNotEmpty:activitiesRemittenceNotifier.transactionSg.isNotEmpty,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${activitiesRemittenceNotifier.pageIndex!} ${"of"} ${activitiesRemittenceNotifier.pageCount} '
                        '${"pages"}',
                    style: blackTextStyle16(context)..copyWith(fontSize: activitiesRemittenceNotifier.pageIndex! > 9 || activitiesRemittenceNotifier.pageCount > 100 ?13:16,)
                ),
              ),
            )
          ],
        );
      },
    );
  }

  //On Pagination Calling API for Data
  onPaginated(BuildContext context,ActivitiesRemittenceNotifier activitiesRemittenceNotifier)async{
    apiLoader(context);
      if (activitiesRemittenceNotifier.countryData ==
          AppConstants.singapore ||
          activitiesRemittenceNotifier
              .countryData ==
              AppConstants.hongKong) {
        activitiesRemittenceNotifier.url =
        "?page=${activitiesRemittenceNotifier.pageIndex! - 1}&size=10&filter=";
        await TransactionRepository()
            .apiActivitiesTransaction(
            activitiesRemittenceNotifier
                .url,
            activitiesRemittenceNotifier
                .startDateAPI.isEmpty
                ? null
                : activitiesRemittenceNotifier
                .startDateAPI,
            activitiesRemittenceNotifier
                .endDateAPI.isEmpty
                ? null
                : activitiesRemittenceNotifier
                .endDateAPI,
            activitiesRemittenceNotifier
                .selectedStatus.isEmpty
                ? null
                : activitiesRemittenceNotifier
                .selectedStatus,
            activitiesRemittenceNotifier
                .SearchController
                .text
                .isEmpty
                ? null
                : activitiesRemittenceNotifier
                .SearchController.text,
            activitiesRemittenceNotifier.selectedCountryFilter.isEmpty?
            null
                :activitiesRemittenceNotifier.selectedCountryFilter
        )
            .then((value) {
          TransactionResponse
          transactionResponse =
          TransactionResponse
              .fromJson(value);
          List<Content> empty = [];

          activitiesRemittenceNotifier.pageCount = transactionResponse.totalPages ?? 1;
          activitiesRemittenceNotifier.transactionSg = transactionResponse.content ?? empty;
          activitiesRemittenceNotifier.orderSg = transactionResponse.content ?? empty;
          activitiesRemittenceNotifier.pageIndex = (transactionResponse.pageable!.pageNumber! + 1);

        });
      }else{
          int start = (activitiesRemittenceNotifier.pageIndex! -1) * 10;
          int end = start + 10;
          if (end > activitiesRemittenceNotifier.transactions.length) {
            end = activitiesRemittenceNotifier.transactions.length;
          }
          activitiesRemittenceNotifier.transactionsDataPaginated =  activitiesRemittenceNotifier.transactions.sublist(start, end);
        }
      Navigator.pop(context);
  }
}
//Selected Country Data
String countrySelectedData = '';
