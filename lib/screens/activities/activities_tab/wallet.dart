import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_transaction_history.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_transaction_history_request.dart';
import 'package:singx/core/notifier/activities_wallet_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';



class Wallet extends StatelessWidget {

  //Pagination Box Size
  double _dataPagerHeight = 55.0;

  @override
  Widget build(BuildContext context) {
    _dataPagerHeight = kIsWeb ? MediaQuery.of(context).size.width < 682 ? 105 : 55 :  screenSizeWidth < 682 ? 105 : 55;
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivitiesWalletNotifier(context),
      child: Consumer<ActivitiesWalletNotifier>(
          builder: (context, activitiesWalletNotifier, _) {


        return Padding(
          padding: px16DimenHorizontal(context),
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              children: [
                sizedBoxHeight15(context),
                buildFilterMethod(context, activitiesWalletNotifier),
                sizedBoxHeight30(context),
                Container(
                  height: kIsWeb ? getScreenHeight(context) * 0.6 : screenSizeHeight * 0.6,
                  child:
                      buildTransactionTable(context, activitiesWalletNotifier),
                ),
                sizedBoxHeight5(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  //Filter Methods Row
  Widget buildFilterMethod(
      BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Row(
      children: [
        Flexible(
          child: kIsWeb ? getScreenWidth(context) >= 990
              ? buildFilterGreaterThan990(context, activitiesWalletNotifier)
              : isMobile(context)
                  ? buildFilterForMobile(context, activitiesWalletNotifier)
                  : buildFilterLessThan990(context, activitiesWalletNotifier) :  screenSizeWidth >= 990
              ? buildFilterGreaterThan990(context, activitiesWalletNotifier)
              : isMobileSDK(context)
              ? buildFilterForMobile(context, activitiesWalletNotifier)
              : buildFilterLessThan990(context, activitiesWalletNotifier)
        ),
      ],
    );
  }

  //Filter Methods For Above The Screen Size Of 990
  Widget buildFilterGreaterThan990(BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Row(
      children: [
        Expanded(
          flex: AppConstants.two,
          child:
          buildSearchField(context, activitiesWalletNotifier),
        ),
        getScreenWidth(context) <= 1210 &&
            getScreenWidth(context) >= 1060
            ? sizedBoxWidth15(context)
            : Spacer(),
        buildDateField(context, activitiesWalletNotifier),
        sizedBoxWidth15(context),
        buildStatusDropDown(context, activitiesWalletNotifier)
      ],
    );
  }

  //Filter Methods For Mobile
  Widget buildFilterForMobile(BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Column(
      children: [
        buildSearchField(context, activitiesWalletNotifier),
        sizedBoxHeight10(context),
        buildDateField(context, activitiesWalletNotifier),
        sizedBoxHeight10(context),
        buildStatusDropDown(context, activitiesWalletNotifier),
      ],
    );
  }

  //Filter Methods For Below the Screen Size Of 990
  Widget buildFilterLessThan990(BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: AppConstants.oneInt,
                child: buildSearchField(
                    context, activitiesWalletNotifier)),
          ],
        ),
        sizedBoxWidth10(context),
        sizedBoxHeight15(context),
        Row(
          children: [
            Expanded(
              flex: AppConstants.oneInt,
              child: buildDateField(
                  context, activitiesWalletNotifier),
            ),
            sizedBoxWidth10(context),
            Expanded(
              flex: AppConstants.oneInt,
              child: buildStatusDropDown(
                  context, activitiesWalletNotifier),
            ),
          ],
        )
      ],
    );
  }

  //Search Data TextField
  Widget buildSearchField(
      BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Selector<ActivitiesWalletNotifier, TextEditingController>(
        builder: (context, SearchController, child) {
          return CommonTextField(
            onChanged: (String val) {
              SGWalletRepository()
                  .SGWalletHistory(ActivitiesWalletRequest(
                      fromDate: activitiesWalletNotifier.selectedFromDate,
                      toDate: activitiesWalletNotifier.selectedToDate,
                      transactionId: val,
                      status: activitiesWalletNotifier.selectedStatus.isNotEmpty
                          ? activitiesWalletNotifier.selectedStatus
                          : ''))
                  .then((value) {
                List<SgWalletTransactionHistory> sgWalletTransactionHistory =
                    value as List<SgWalletTransactionHistory>;

                activitiesWalletNotifier.walletTransactions =
                    (sgWalletTransactionHistory);
                activitiesWalletNotifier.pageIndex = 1;
                if(activitiesWalletNotifier.paginationScrollController.hasClients)activitiesWalletNotifier.paginationScrollController.position.animateTo(activitiesWalletNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                activitiesWalletNotifier.pageCount = (activitiesWalletNotifier.walletTransactions.length / 10).ceil();
                int start = (activitiesWalletNotifier.pageIndex -1) * 10;
                int end = start + 10;
                if (end > activitiesWalletNotifier.walletTransactions.length) {
                  end = activitiesWalletNotifier.walletTransactions.length;
                }
                activitiesWalletNotifier.walletTransactionsDataPaginated =  activitiesWalletNotifier.walletTransactions.sublist(start, end);

                activitiesWalletNotifier.walletOrders =
                    (sgWalletTransactionHistory);
              });
              handleInteraction(context);
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
                        : getScreenWidth(context) * 0.32
                : isTabSDK(context)
                    ? screenSizeWidth * 0.60
                    : isMobileSDK(context)
                        ? double.infinity
                        : screenSizeWidth * 0.32,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child:
                  Image.asset(AppImages.search, width: AppConstants.twentyTwo),
            ),
          );
        },
        selector: (buildContext, activitiesWalletNotifier) =>
            activitiesWalletNotifier.SearchController);
  }

  //Filter Date TextField
  Widget buildDateField(
      BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Selector<ActivitiesWalletNotifier, TextEditingController>(
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
            width: kIsWeb
                ? isTab(context)
                    ? getScreenWidth(context) * 0.20
                    : isMobile(context)
                        ? double.infinity
                        : getScreenWidth(context) * 0.20
                : isTabSDK(context)
                    ? screenSizeWidth * 0.20
                    : isMobileSDK(context)
                        ? double.infinity
                        : screenSizeWidth * 0.20,
              suffixIcon: Row(
                children: [
                  Visibility(
                    visible: DateController.text.isNotEmpty,
                    child: Container(
                      width: 40,
                      child: IconButton(onPressed: (){
                        DateController.clear();
                        activitiesWalletNotifier.selectedFromDate = 0;
                        activitiesWalletNotifier.selectedToDate = 0;
                        activitiesWalletNotifier.loadInitialData();
                        activitiesWalletNotifier.notifyListeners();
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
              DateRangePickerWithYear(
                      context,
                      activitiesWalletNotifier.selectedWalletStartDate == null
                          ? DateTime(DateTime.now().year,
                              DateTime.now().month - 2, DateTime.now().day)
                          : activitiesWalletNotifier.selectedWalletStartDate!,
                      activitiesWalletNotifier.selectedWalletEndDate == null
                          ? DateTime.now()
                          : activitiesWalletNotifier.selectedWalletEndDate!)
                  .then((CustomRangePickerResponse value) {
                activitiesWalletNotifier.selectedWalletStartDate =
                    value.dateTime;
                activitiesWalletNotifier.selectedWalletEndDate =
                    value.dateTime2!.add(Duration(hours: 23,minutes: 59, seconds: 59));

                final rangeStartDate = DateFormat('MM/dd/yyyy')
                    .format(activitiesWalletNotifier.selectedWalletStartDate!)
                    .toString();
                final rangeEndDate = DateFormat('MM/dd/yyyy')
                    .format(activitiesWalletNotifier.selectedWalletEndDate!)
                    .toString();

                activitiesWalletNotifier.DateController.text =
                    '$rangeStartDate - $rangeEndDate';
                activitiesWalletNotifier.selectedFromDate =
                    activitiesWalletNotifier
                        .selectedWalletStartDate!.millisecondsSinceEpoch;
                activitiesWalletNotifier.selectedToDate =
                    activitiesWalletNotifier
                        .selectedWalletEndDate!.millisecondsSinceEpoch;
                SGWalletRepository()
                    .SGWalletHistory(ActivitiesWalletRequest(
                        fromDate: activitiesWalletNotifier.selectedFromDate,
                        toDate: activitiesWalletNotifier.selectedToDate,
                        transactionId: activitiesWalletNotifier
                                .SearchController.text.isNotEmpty
                            ? activitiesWalletNotifier.SearchController.text
                            : '',
                        status:
                            activitiesWalletNotifier.selectedStatus.isNotEmpty
                                ? activitiesWalletNotifier.selectedStatus
                                : ""))
                    .then((value) {
                  List<SgWalletTransactionHistory> sgWalletTransactionHistory =
                      value as List<SgWalletTransactionHistory>;

                  activitiesWalletNotifier.walletTransactions =
                      (sgWalletTransactionHistory);
                  activitiesWalletNotifier.pageIndex = 1;
                  if(activitiesWalletNotifier.paginationScrollController.hasClients)activitiesWalletNotifier.paginationScrollController.position.animateTo(activitiesWalletNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                  activitiesWalletNotifier.pageCount = (activitiesWalletNotifier.walletTransactions.length / 10).ceil();
                  int start = (activitiesWalletNotifier.pageIndex -1) * 10;
                  int end = start + 10;
                  if (end > activitiesWalletNotifier.walletTransactions.length) {
                    end = activitiesWalletNotifier.walletTransactions.length;
                  }
                  activitiesWalletNotifier.walletTransactionsDataPaginated =  activitiesWalletNotifier.walletTransactions.sublist(start, end);
                  activitiesWalletNotifier.walletOrders =
                      (sgWalletTransactionHistory);
                });
              });
            },
          );
        },
        selector: (buildContext, activitiesWalletNotifier) =>
            activitiesWalletNotifier.DateController);
  }

  //Status Dropdown Field
  Widget buildStatusDropDown(
      BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return Container(
        height: 42,
        width: kIsWeb ? isWeb(context)
            ? getScreenWidth(context) * 0.20
            : getScreenWidth(context) * 0.90 : screenSizeWidth > 800 ? screenSizeWidth * 0.20 : screenSizeWidth * 0.90,
        child: LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(
                  context,
                  dropdownItems: activitiesWalletNotifier.statusData,
                  controller: activitiesWalletNotifier.statusController,
                  hintText: S.of(context).statuswithout,
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected onSelected, Iterable options) {
                    if(activitiesWalletNotifier.statusData.contains("Status")){

                    }else{
                      activitiesWalletNotifier.statusData.insert(0, "Status");
                    }

                    return buildDropDownContainer(
                      context,
                      options: options,
                      onSelected: onSelected,
                      dropdownData: activitiesWalletNotifier.statusData,
                      constraints: constraints,
                      dropDownHeight: options.first == 'No Data Found'
                          ? 150
                          : options.length < 5
                          ? options.length * 50
                          : 200,
                    );
                  },
                  width: kIsWeb ? isWeb(context)
                      ? getScreenWidth(context) * 0.20
                      : null : screenSizeWidth > 800 ? screenSizeWidth * 0.20 : screenSizeWidth * 0.90,
                  height: 42,
                  validation: (val) {},
                  onSelected: (val) {
                    onStatusChanges(context,val,activitiesWalletNotifier);
                  },
                  onSubmitted: (val) {
                    onStatusChanges(context,val,activitiesWalletNotifier);
                  },
                )));
  }

  //On Status Change Calling API
  onStatusChanges(BuildContext context,String val,ActivitiesWalletNotifier activitiesWalletNotifier){
    if(val == "Status"){
      activitiesWalletNotifier.statusController.clear();
      activitiesWalletNotifier.selectedStatus = "";
    }
    handleInteraction(context);
    activitiesWalletNotifier.selectedStatus = val!;
    SGWalletRepository()
        .SGWalletHistory(ActivitiesWalletRequest(
        fromDate: activitiesWalletNotifier.selectedFromDate,
        toDate: activitiesWalletNotifier.selectedToDate,
        transactionId: activitiesWalletNotifier
            .SearchController.text.isNotEmpty
            ? activitiesWalletNotifier.SearchController.text
            : '',
        status: activitiesWalletNotifier.selectedStatus))
        .then((value) {
      List<SgWalletTransactionHistory>
      sgWalletTransactionHistory =
      value as List<SgWalletTransactionHistory>;

      activitiesWalletNotifier.walletTransactions =
      (sgWalletTransactionHistory);
      activitiesWalletNotifier.pageIndex = 1;
      if(activitiesWalletNotifier.paginationScrollController.hasClients)activitiesWalletNotifier.paginationScrollController.position.animateTo(activitiesWalletNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
      activitiesWalletNotifier.pageCount = (activitiesWalletNotifier.walletTransactions.length / 10).ceil();
      int start = (activitiesWalletNotifier.pageIndex -1) * 10;
      int end = start + 10;
      if (end > activitiesWalletNotifier.walletTransactions.length) {
        end = activitiesWalletNotifier.walletTransactions.length;
      }
      activitiesWalletNotifier.walletTransactionsDataPaginated =  activitiesWalletNotifier.walletTransactions.sublist(start, end);
      activitiesWalletNotifier.walletOrders =
      (sgWalletTransactionHistory);
    });
  }

  //Transaction Table
  Widget buildTransactionTable(
      BuildContext context, ActivitiesWalletNotifier activitiesWalletNotifier) {
    return LayoutBuilder(
      builder: (BuildContext, constraint) {
        return Selector<ActivitiesWalletNotifier,
            ScrollController>(
            builder: (context, data, child) {
              return Column(
                children: [
                  SizedBox(
                    height: constraint.maxHeight - _dataPagerHeight,
                    width: constraint.maxWidth,
                    child: activitiesWalletNotifier.walletTransactions.isEmpty
                        ? Center(
                            child: Text(
                            "No Data Found",
                            style: TextStyle(fontSize: 18),
                          ))
                        : Scrollbar(
                          thumbVisibility: true,
                          controller: activitiesWalletNotifier.DataTableVerticalScrollController,
                          child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: activitiesWalletNotifier.DataTableVerticalScrollController,
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: activitiesWalletNotifier.DataTableHorizontalScrollController,
                        child: SingleChildScrollView(
                            controller: activitiesWalletNotifier.DataTableHorizontalScrollController,
                            scrollDirection: getScreenWidth(context) > 1300 ? Axis.vertical : Axis.horizontal,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: dividercolor,
                              ),
                              child: DataTable(
                                dataRowHeight: 60,
                                dividerThickness: 2,
                                columns: [
                                  DataColumn(label: Text(S.of(context).datewithout, style: dataTableHeadingStyle(context),)),
                                  DataColumn(label: Text(S.of(context).description, style: dataTableHeadingStyle(context),)),
                                  DataColumn(label: Text(S.of(context).amount, style: dataTableHeadingStyle(context),)),
                                  DataColumn(label: Text(S.of(context).transactionIDTable, style: dataTableHeadingStyle(context),)),
                                  DataColumn(label: Text(S.of(context).runningBalance, style: dataTableHeadingStyle(context),)),
                                  DataColumn(label: Text(S.of(context).statuswithout, style: dataTableHeadingStyle(context),)),

                                ],
                                rows: activitiesWalletNotifier.walletTransactionsDataPaginated.map((data) {
                                  TextStyle textStyleRow = TextStyle(
                                      fontSize: AppConstants.fourteen,
                                      fontWeight: AppFont.fontWeightMedium,
                                      color: black);
                                  var timeStampDate =
                                  new DateTime.fromMillisecondsSinceEpoch(int.parse(data.txndate!) * 1000);
                                  final formatter = DateFormat('yyy-MM-dd HH:mm:ss');
                                  final dateTime = formatter.parse(timeStampDate.toString());
                                  var outputFormat = DateFormat('MM/dd/yyyy');
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(outputFormat.format(dateTime),style: textStyleRow,)),
                                      DataCell(Text(data.description!,style: textStyleRow,)),
                                      DataCell(Text(data.currency.toString() + ' ' + data.amount.toString().toString(),style: textStyleRow,)),
                                      DataCell(Text(data.producttxnid!,style: textStyleRow,)),
                                      DataCell(Text(data.currency! + ' ' + data.runningbal.toString(),style: textStyleRow,)),
                                      DataCell(Text(data.txnstatus!,style: TextStyle(
                                          fontSize: AppConstants.fourteen,
                                          fontWeight: AppFont.fontWeightMedium,
                                          color: data.txnstatus == initiatedWallet
                                              ? orangeColor
                                              : data.txnstatus == validityExpiredWallet
                                              ? error
                                              : black),)),

                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ),
                      ),
                    ),
                        )
                  ),
                  Container(
                    height: _dataPagerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            child: activitiesWalletNotifier.countryData ==
                                        AppConstants.singapore &&
                                    (activitiesWalletNotifier
                                            .walletOrders.length <
                                        1 || activitiesWalletNotifier
                                            .pageCount <
                                        1)
                                ? SizedBox()
                                :Column(
                                  children: [
                                    sizedBoxHeight10(context),
                                    Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                    Row(
                                      children: [
                                        buildPagination(context: context,iconData: Icons.first_page,isIcon: true, buttonFunction: () {
                                          if(activitiesWalletNotifier.pageIndex == 1) return;
                                          activitiesWalletNotifier.pageIndex = 1;
                                          if(activitiesWalletNotifier.paginationScrollController.hasClients)activitiesWalletNotifier.paginationScrollController.position.animateTo(activitiesWalletNotifier.paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                                          onPaginatedWallet(activitiesWalletNotifier);
                                        }),
                                        sizedBoxWidth5(context),
                                        buildPagination(context: context,iconData: Icons.keyboard_arrow_left,isIcon: true, buttonFunction: () {
                                          if(activitiesWalletNotifier.pageIndex <= 1) return;
                                          activitiesWalletNotifier.pageIndex = (activitiesWalletNotifier.pageIndex - 1);
                                          activitiesWalletNotifier.paginationScrollController.position.jumpTo(activitiesWalletNotifier.paginationScrollController.offset - AppConstants.forty);
                                          onPaginatedWallet(activitiesWalletNotifier);
                                        }),
                                        SizedBox(
                                          height: AppConstants.thirtyFive,
                                          width: (getScreenWidth(context)<310||activitiesWalletNotifier.pageCount<=1)?AppConstants.forty:(getScreenWidth(context)<350||activitiesWalletNotifier.pageCount<=2)?AppConstants.eighty:AppConstants.oneHundredAndTwenty,
                                          child: Center(
                                            child: ListView.builder(
                                                controller: activitiesWalletNotifier.paginationScrollController,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: activitiesWalletNotifier.pageCount,
                                                itemBuilder: (context,index){
                                                  return Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: buildPagination(context: context,isIcon: false,
                                                        selectedPageCount: activitiesWalletNotifier.pageIndex,
                                                        pageCount: (index + 1).toString(), buttonFunction: () {
                                                          activitiesWalletNotifier.pageIndex = index + 1;
                                                          onPaginatedWallet(activitiesWalletNotifier);
                                                        }),
                                                  );

                                                }),
                                          ),
                                        ),
                                        sizedBoxWidth5(context),
                                        buildPagination(context: context,iconData: Icons.keyboard_arrow_right,isIcon: true, buttonFunction: () {
                                          if(activitiesWalletNotifier.pageIndex >= activitiesWalletNotifier.pageCount) return;
                                          activitiesWalletNotifier.pageIndex = (activitiesWalletNotifier.pageIndex + 1);
                                          activitiesWalletNotifier.paginationScrollController.position.jumpTo(activitiesWalletNotifier.paginationScrollController.offset + AppConstants.forty);
                                          onPaginatedWallet(activitiesWalletNotifier);
                                        }),
                                        sizedBoxWidth5(context),
                                        buildPagination(context: context,iconData: Icons.last_page,isIcon: true, buttonFunction: () async{
                                          if(activitiesWalletNotifier.pageIndex == activitiesWalletNotifier.pageCount) return;
                                          if(activitiesWalletNotifier.paginationScrollController.hasClients) await activitiesWalletNotifier.paginationScrollController.position.animateTo(activitiesWalletNotifier.paginationScrollController.offset + 1, duration: Duration(milliseconds: 1), curve: Curves.easeIn);
                                          activitiesWalletNotifier.pageIndex = activitiesWalletNotifier.pageCount;
                                          if(activitiesWalletNotifier.paginationScrollController.hasClients)activitiesWalletNotifier.paginationScrollController.position.animateTo(activitiesWalletNotifier.paginationScrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeIn);
                                          onPaginatedWallet(activitiesWalletNotifier);
                                        }),
                                      ],
                                    ),
                                    if(getScreenWidth(context)>500)Text(
                                        '${activitiesWalletNotifier.pageIndex} ${"of"} ${activitiesWalletNotifier.pageCount} '
                                            '${"pages"}',
                                        style: blackTextStyle16(context)..copyWith(fontSize: activitiesWalletNotifier.pageIndex > 9 || activitiesWalletNotifier.pageCount > 100 ?13:16,)
                                    )
                              ],
                            ),
                                    sizedBoxHeight10(context),
                                    if(getScreenWidth(context)<500)Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          '${activitiesWalletNotifier.pageIndex} ${"of"} ${activitiesWalletNotifier.pageCount} '
                                              '${"pages"}',
                                          style: blackTextStyle16(context)..copyWith(fontSize: activitiesWalletNotifier.pageIndex > 9 || activitiesWalletNotifier.pageCount > 100 ?13:16,)
                                      )
                                      ,
                                    )

                                  ],
                                )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            selector: (buildContext, activitiesWalletNotifier) => activitiesWalletNotifier.horizontalScrollController);
      },
    );
  }

  //On Pagination Changing Data Table
  onPaginatedWallet(ActivitiesWalletNotifier activitiesWalletNotifier,){
    int start = (activitiesWalletNotifier.pageIndex -1) * 10;
    int end = start + 10;
    if (end > activitiesWalletNotifier.walletTransactions.length) {
      end = activitiesWalletNotifier.walletTransactions.length;
    }
    activitiesWalletNotifier.walletTransactionsDataPaginated =  activitiesWalletNotifier.walletTransactions.sublist(start, end);
  }
}


