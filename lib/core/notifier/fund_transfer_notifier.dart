import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/fund_transfer_repository.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/data/remote/service/receiver_repository.dart';
import 'package:singx/core/data/remote/service/sender_repository.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/australia/corridors/corrdidors_response.dart';
import 'package:singx/core/models/request_response/australia/corridors/get_receiver_currency_response.dart';
import 'package:singx/core/models/request_response/australia/corridors/get_sender_currency_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/customer_rating/customer_rating_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/receiver_list_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/customer_rating_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/get_receiver_account_details_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/get_sender_account_details_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/relationship/relationship_response.dart';
import 'package:singx/core/models/request_response/check_transfer_limit/check_transfer_limit_request.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_data_by_id_response.dart';
import 'package:singx/core/models/request_response/send_receiver_country/receiver_country_response.dart';
import 'package:singx/core/models/request_response/send_receiver_country/send_country_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/validate_transaction/validate_transaction_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/validate_transaction/validate_transaction_response.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/sender_list_response_aus.dart';
import 'package:singx/core/models/request_response/exchange/exchange_aus_request.dart';
import 'package:singx/core/models/request_response/exchange/exchange_aus_response.dart';
import 'package:singx/core/models/request_response/exchange/exchange_request.dart';
import 'package:singx/core/models/request_response/exchange/exchange_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/relationship_dropdown/relationship_response_aus.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/transfer_purpose/transfer_purpose_aus_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/transfer_purpose/transfer_purpose_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_response.dart';
import 'package:singx/core/models/request_response/transaction_file_upload/transaction_file_upload_response.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/justToolTip/src/models/just_the_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../utils/shared_preference/shared_preference_mobile_web.dart';

class FundTransferNotifier extends BaseChangeNotifier {

  FundTransferNotifier(context, {required int fundCountValue, String? from}) {
    SharedPreferencesMobileWeb.instance.getScreenSize(screenWidth).then((value)=> screenSize=value);
    userCheck(context);
    if (from == 'Wallet') {
    } else {
      fundCount = fundCountValue;
      sendController.text = "1000.00";
      recipientController.text = "1000.00";

      SharedPreferencesMobileWeb.instance
          .getContactId(apiContactId)
          .then((value) async {
        contactId = value;
        notifyListeners();
       await SharedPreferencesMobileWeb.instance.getScreenSize(screenWidth).then((value)=> screenSize=value);
      });
      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        countryData = value;
        notifyListeners();
        if (fundCount == 1) {
          if (countryData == AustraliaName) {
            selectedSender = "AUD";
            await corridorApi(context);
            await getFundTransferCalcStoredData(context);
            await getCorridorApi(context);
            await getSenderBankAccounts(context);
          } else {
            await corridorApi(context);
            await getFundTransferCalcStoredData(context);
            await getCorridorApi(context);
            await getSendCountryApi(context);
            await getReceiverCountryApi(context);
            if (countryData != HongKongName) await getWalletBalance(context);
          }
        }
        if (fundCount == 2) {
          if (countryData == AustraliaName) {
            SharedPreferencesMobileWeb.instance
                .getCountryId()
                .then((value) async {
              await getReceiverBankAccounts(
                  context, value == 0 ? selectedReceiverCountryID : value);
            });
          } else {
            await SharedPreferencesMobileWeb.instance
                .getReceiveCurrencyId(AppConstants.receiveCurrencyIdData)
                .then((value) async {
              receiverCurrencyId = value;
              await getFundTransferCalcStoredData(context);
              await getReceiverBankAccountsSG(context);
            });
          }
        }
        if (fundCount == 3) {
          if (countryData == AustraliaName) {
            await getRelationShipApi(context);
            await getTransferPurposeApi(context);
            await getFundTransferCalcStoredData(context);
            await getPhoneNumberData(context);
          } else {
            await getTransferPurposeApiSG(context);
            await getRelationShipApiSG(context);
            SharedPreferencesMobileWeb.instance
                .getReceiveCurrencyId(AppConstants.receiveCurrencyIdData)
                .then((value) => receiverCurrencyId = value);
            SharedPreferencesMobileWeb.instance
                .getSendCurrencyId(AppConstants.sendCurrencyIdData)
                .then((value) => sendCurrencyId = value);
          }
        }
        if (fundCount == 4) {
          await getFundTransferCalcStoredData(context);
        }
        await SharedPreferencesMobileWeb.instance
            .getFundTransferAccountData(AppConstants.accountScreenData)
            .then((value) async {
          Map<String, dynamic> newValue =
              jsonDecode(value) as Map<String, dynamic>;
          sendController.text = newValue["sendAmount"];
          recipientController.text = newValue["receiveAmount"];
          recipientController.text = newValue["receiveAmount"];
          exchangeRateConverted = newValue["exchangeRate"];
          singXData = double.parse(newValue["singXFee"].toString());
          singXDataOld = double.parse(newValue["singXFee"].toString());
          totalPayable = newValue["totalPayable"];
          selectedSenderBankController.text = newValue["selectedBankAccount"];
          selectedBankId = newValue["senderId"];
          selectedSender = newValue["sendCurrency"];
          selectedReceiver = newValue["receiveCurrency"];
          corridorID = newValue["corridorID"];
          selectedAccountType = newValue["selectedAccountType"];
          isAccountTypeSelected = newValue["isAccountTypeSelected"];
          senderCountryId = newValue["senderCountryId"];
          receiverCountryId = newValue["receiverCountryId"];
        });
        await SharedPreferencesMobileWeb.instance
            .getFundTransferReceiverData(AppConstants.receiverScreenData)
            .then((valueR) async {
          Map<String, dynamic> newValueR =
              jsonDecode(valueR) as Map<String, dynamic>;
          selectedReceiverBankController.text =
              newValueR["selectedReceiverBank"];
          selectedBankReceiverId = newValueR["receiverId"];
          receiverNameData = newValueR["receiverName"];
          receiverBankNameData = newValueR["receiverBankName"];
          receiverAccountNumberData = newValueR["receiverAccountNumber"];
          receiverCountryData = newValueR["receiverCountry"];
        });
        await SharedPreferencesMobileWeb.instance
            .getFundTransferReviewData(AppConstants.reviewScreenData)
            .then((valueRe) {
          Map<String, dynamic> newValueRe =
              jsonDecode(valueRe) as Map<String, dynamic>;
          referenceNumber = newValueRe["userTransactionId"];
          bankName = newValueRe["bankName"];
          accountName = newValueRe["accountName"];
          countryData == AustraliaName ?
          accountNumberAus = newValueRe["accountNumber"] :accountNumber = newValueRe["accountNumber"] ;
          bsbCode = newValueRe["bsbCode"];
          bankCode = newValueRe["bankCode"] ?? '';
          branchCode = newValueRe["branchCode"] ?? '';
          selectedPurposeOfTransferController.text =
              newValueRe["transferPurpose"];
          selectedRelationshipWithSenderController.text =
              newValueRe["relationship"];
          promoCodeController.text = newValueRe["promoCode"];
        });
        if (fundCount == 4) {
          if (countryData == AustraliaName) {
            await getCustomerRatingApi(context);
            await FundTransferRepository()
                .validateTransaction(
                    context,
                    ValidateTransactionRequest(
                        contactId: contactId,
                        receiverId: int.parse(selectedBankReceiverId),
                        sendAmount: double.parse(sendController.text),
                        senderId: int.parse(selectedBankId),
                        usrtxnId: referenceNumber,
                        insert: false))
                .then((value) {
              ValidateTransactionResponse responseData =
                  value as ValidateTransactionResponse;
              if (responseData.documentRequired == "No") {
                isDocumentNeedUpload = false;
              } else {
                isDocumentNeedUpload = true;
              }
            });
          } else {
            await getCustomerRatingApiSG(context);
            if(selectedSender == 'HKD' && selectedReceiver == 'KRW' || selectedSender == 'SGD' && selectedReceiver == 'KRW' || selectedSender == 'USD' && selectedReceiver == 'KRW')
            validationPopup(context);
          }
        }
      });
      SharedPreferencesMobileWeb.instance
          .getAccountSelectedScreenData(accountPage)
          .then((value) => _isAccountSelected = value);
      SharedPreferencesMobileWeb.instance
          .getReceiverSelectedScreenData(receiverPage)
          .then((value) => _isReceiverSelected = value);
      SharedPreferencesMobileWeb.instance
          .getReviewSelectedScreenData(reviewPage)
          .then((value) => _isReviewSelected = value);

      scrollController = ScrollController();
    }
  }

  notifyListenerUpdate() {
    notifyListeners();
  }

  validationPopup(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppInActiveCheck(
            context: context,
            child:AlertDialog(
             titlePadding: EdgeInsets.zero,
             contentPadding: EdgeInsets.zero,
              title: Container(
                color: orangePantoneTint500,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                      'Note - Receiver Validation Required',
                                      style: TextStyle(color: white)),
                                ))),
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context)),
                        SizedBox(width: 5)
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 12.0),
                child: Container(
                  height: getScreenWidth(context) < 430 ? getScreenHeight(context) * 0.60 : getScreenWidth(context) < 570 ? getScreenHeight(context) * 0.45 : 280,
                  width: 600,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NOTE: The transaction will be successful only once the following has been completed by the Receiver:',
                          style: TextStyle(color: orangePantoneTint600),
                        ),
                        SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                              text:
                                  'If you are sending money to a receiver in South Korea for the ',
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'first time, ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppConstants.sixteen,
                                  ),
                                ),
                                TextSpan(text: 'they will get an '),
                                TextSpan(
                                  text: 'SMS with a link from Sentbe.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppConstants.sixteen,
                                  ),
                                )
                              ]),
                        ),
                        //    Text('If you are sending money to a receiver in South Korea for the first time, they will get an SMS with a link from Sentbe.'),
                        SizedBox(height: 20),
                        Text(
                            'Please inform the receiver that they will be required to open the link and provide the following info:'),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile details',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppConstants.sixteen,
                                ),
                              ),
                              Text(
                                'upload a copy of their national ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppConstants.sixteen,
                                ),
                              ),
                              Text(
                                'Bank account details (which should match the details that you have provided).',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppConstants.sixteen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Divider(),
                SizedBox(height: 5),
                Center(
                  child: buildButton(
                    context,
                    name: "Close & Proceed",
                    width: 180,
                    fontColor: white,
                    color: orangePantoneTint500,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 10)
              ],
            )
        );
      },
    );
  }

  // Repository
  FundTransferRepository repository = FundTransferRepository();

  // Controller
  ScrollController transferPageController = ScrollController();
  JustTheController tooltipController = JustTheController();
  TextEditingController _sendController = TextEditingController();
  TextEditingController _recipientController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController commentsForReceiverController = TextEditingController();
  TextEditingController receiverController = TextEditingController();
  TextEditingController _selectedSenderBankController = TextEditingController();
  TextEditingController _selectedReceiverBankController = TextEditingController();
  TextEditingController _selectedPurposeOfTransferController = TextEditingController();
  TextEditingController _selectedRelationshipWithSenderController = TextEditingController();
  ScrollController? scrollController;

  // Keys for validating Form
  final GlobalKey<FormState> accountPageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> receiverPageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> reviewPageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

  // Integer Values
  int _selectedRadioTile = 1;
  int? _fundCount = 0;
  int? selected;
  int contactId = 0;
  int _selectedTile = 0;
  int? _accountNumberAus = 0;
  int _transferPurposeId = 0;
  int _relationshipId = 0;
  int _senderAccountId = 0;
  int _receiverAccountId = 0;
  int _userTransactionId = 0;
  int _selectedTransferMode = 1;

  // Double Values
  double _screenSize = 0;
  double _progressValue = 0.0;
  double _singXData = 0;
  double _singXDataOld = 0;
  double _totalPayable = 0;


  // String Values
  String _selectedSender = '';
  String _selectedReceiver = '';
  String _walletBalance = '0.0';
  String _selectedAccountType = '';
  String ratingUrlSG =
      'https://www.google.com/search?q=singx+google+reviews&rlz=1C1CHBD_en-GBGB801GB801&oq=singx+google+r&aqs=chrome.0.0j69i60l2j69i57j69i60j0.2583j0j7&sourceid=chrome&ie=UTF-8#lrd=0x31da190d964b7945:0x3b559f5fa91fd276,3';
  String ratingUrlAUS =
      'https://www.google.com/search?hl=en-IN&gl=in&q=SingX+Australia+Pty+Ltd,+Level+4/240+Queen+St,+Brisbane+City+QLD+4000,+Australia&ludocid=3146377801956279332&lsig=AB86z5UspnPAewU4QB07k8TC7ucz#lrd=0x6b915b4771669bcb:0x2baa2df0cec74424,3';
  String _errorExchangeValue = "";
  String _exchangeSelectedSender = "";
  String _exchangeSelectedReceiver = "";
  String? _accountNumber = '';
  String _selectedFrom = '1';
  String _exchangeRateInitial = "1";
  String _exchangeRateConverted = "0";
  String _corridorID = "2";
  String _selectedTo = '1';
  String? _purposeOfTransfer;
  String? _relationshipWithSender;
  String? selectedBank;
  String? _selectedReceiverBank;
  String? _selectedBankId;
  String? _selectedBankReceiverId;
  String _receiverAccountNumberData = "";
  String _receiverBankNameData = "";
  String _receiverNameData = "";
  String _receiverCountryData = "";
  String _sendCurrencyId = "";
  String _receiverCurrencyId = "";
  String _senderCountryId = "";
  String _receiverCountryId = "";
  String countryData = "";
  String _errorMessage = "";
  String _OTPErrorMessage = "";
  String? _referenceNumber = "";
  String? _bankName = "";
  String _bankCode = "";
  String _branchCode = "";
  String? _accountName = "";
  String? _bsbCode = "";
  String? size;
  String _checkTransferLimit = '';
  String _selectedMobileNumber = '';


  // List Values
  List<String> _senderData = [];
  List<String> _receiverData = [];
  List<int> _receiverCountryIDData = [];
  List<SenderListResponseAus> _senderAccountResponse = [];
  List<GetSenderAccountDetails> _senderAccountResponseSG = [];
  List<GetReceiverAccountDetails> _receiverAccountResponseSG = [];
  List<ReceiverListAusResponse> _receiverAccountResponse = [];
  List<TransferPurposeAustraliaResponse> _transferPurposeResponseData = [];
  List<TransferPurposeSingResponse> _transferPurposeResponseDataSing = [];
  List<RelationShipAustraliaResponse> _relationshipResponseData = [];
  List<RelationshipDropdownResponse> _relationshipResponseDataSing = [];
  List<String> _senderBankAccounts = [];
  List<String> _receiverBankAccounts = [];
  List<String> _receiverBankId = [];
  List<String> _receiverBankName = [];
  List<String> _receiverBankAccountNumber = [];
  List<String> _receiverName = [];
  List<String> _receiverCountry = [];
  List _senderBankId = [];
  List<String> _relationshipData = [];
  List<String> _transferPurposeData = [];
  List<String> titles = [
    'PayNow via QR Code',
    'PayNow via UEN Number',
    'Bank Transfer'
  ];
  List<String> titlesHKG = ['Bank Transfer', 'FPS'];
  List<String> titlesAus = [
    'PayId - Faster Processing',
    'Bank Transfer',
    'RTGS Transfer'
  ];
  List<String> subTitles = [
    'Instant payment to SingX by scanning our QR code',
    'Instant payment using SingX UEN number',
    'Manually transfer money from your online banking account'
  ];
  List<String> subTitlesHKG = [
    'Manually transfer money from your online banking account',
    '',
  ];
  List<String> subTitlesAus = [
    "",
    'Manually transfer money from your online banking account',
    ""
  ];

  // Boolean Values
  bool _isFileLoading = true;
  bool _isFileAdded = false;
  bool _isFileAddedVerification = false;
  bool _isDocumentNeedUpload = false;
  bool _uenCopied = false;
  bool _referenceCopied = false;
  bool _accountNameCopied = false;
  bool _accountNumberCopied = false;
  bool _bsbCodeCopied = false;
  bool _isAccountTypeSelected = true;
  bool isJointAccount = false;
  bool? _isAccountSelected, _isReceiverSelected, _isReviewSelected;
  bool isPaymentSelectedOption1 = true;
  bool isPaymentSelectedOption2 = false;
  bool isPaymentSelectedOption3 = false;
  bool _isRatingDone = false;
  bool _isTopUpVisible = false;
  bool _isSwift = false;
  bool _isCash = false;
  bool _isWallet = false;
  bool _isLoading = false;
  var isExpanded = List.filled(3, false, growable: true);

  //
  File_Data_Model? file;
  File? files;
  PlatformFile? platformFile;

  getSenderBankAccounts(BuildContext context) {
    SenderRepository().senderListAus(context, contactId).then((value) {
      List<SenderListResponseAus> response =
      value as List<SenderListResponseAus>;
      senderAccountResponse = response;
      response.forEach((element) {
        senderBankAccounts.add(
            "${element.firstName} ${element.bankName} ${element.accountNumber}");
        senderBankId.add(element.customerBankAcctId!);
      });
    });
  }

  getCorridorApi(BuildContext context) async {
    if(countryData == AppConstants.australia){
      if(selectedReceiver == "PHP" && isSwift == true){
        await FxRepository()
            .apiExchangePHPAustralia(
            ExchangeAustraliaRequest(
              contactId: contactId,
              customerType: "Individual",
              fromAmount: double.parse(sendController.text),
              fromcurrencycode: selectedSender,
              isswift: isSwift,
              label: "Second",
              toAmount: double.parse(recipientController.text),
              tocurrencycode: selectedReceiver,
            ),
            context)
            .then((value) {
          if (value.runtimeType == ExchangeAustraliaResponse) {
            ExchangeAustraliaResponse exchangeResponseData =
            value as ExchangeAustraliaResponse;
            singXData = double.parse(
                exchangeResponseData.response!.singxFee!.toString());
            totalPayable = double.parse(sendController.text) + singXData;
            exchangeRateConverted =
                exchangeResponseData.response!.exchangeRate.toString();
            sendController.text =
                exchangeResponseData.response!.sendamount.toString();
            corridorID = exchangeResponseData.response!.corridorId.toString();
            recipientController.text =
                exchangeResponseData.response!.receiveamount.toString();
            exchangeSelectedReceiver = selectedReceiver;
            exchangeSelectedSender = selectedSender;
          } else {
            errorExchangeValue = value as String;
          }
        });
      }else{
        await FxRepository()
            .apiExchangeAustralia(
            ExchangeAustraliaRequest(
              contactId: contactId,
              customerType: "Individual",
              fromAmount: double.parse(sendController.text),
              fromcurrencycode: selectedSender,
              isswift: isSwift,
              label: "Second",
              toAmount: double.parse(recipientController.text),
              tocurrencycode: selectedReceiver,
            ),
            context)
            .then((value) {
          if (value.runtimeType == ExchangeAustraliaResponse) {
            ExchangeAustraliaResponse exchangeResponseData =
            value as ExchangeAustraliaResponse;
            singXData = double.parse(
                exchangeResponseData.response!.singxFee!.toString());
            totalPayable = double.parse(sendController.text) + singXData;
            exchangeRateConverted =
                exchangeResponseData.response!.exchangeRate.toString();
            sendController.text =
                exchangeResponseData.response!.sendamount.toString();
            corridorID = exchangeResponseData.response!.corridorId.toString();
            recipientController.text =
                exchangeResponseData.response!.receiveamount.toString();
            exchangeSelectedReceiver = selectedReceiver;
            exchangeSelectedSender = selectedSender;
          } else {
            errorExchangeValue = value as String;
          }
        });
      }
    }else{
      await FxRepository()
          .apiExchange(
          ExchangeRequest(
            fromCurrency: selectedSender,
            toCurrency: selectedReceiver,
            amount: double.parse(recipientController.text),
            type: "Receive",
            swift: isSwift,
            cash: isCash,
            wallet: isWallet,
          ),
          context)
          .then((value) {
        if (value.runtimeType == ExchangeResponse) {
          ExchangeResponse exchangeResponseData = value as ExchangeResponse;
          singXData = exchangeResponseData.singxFee!;
          totalPayable = exchangeResponseData.totalPayable!;
          exchangeRateConverted =
              exchangeResponseData.exchangeRate!.toString();
          sendController.text = exchangeResponseData.sendAmount.toString();
          recipientController.text =
              exchangeResponseData.receiveAmount.toString();
          senderCountryId = exchangeResponseData.fromCountryId!;
          receiverCountryId = exchangeResponseData.toCountryId!;
          errorExchangeValue = exchangeResponseData.errors!.isEmpty ? '' : exchangeResponseData.errors!.first;
        } else {
          errorExchangeValue = value as String;
        }
      });
    }
  }

  getCheckTransferLimit(BuildContext context) async {
    await FundTransferRepository()
        .apiChecktransferLimit(
      context,
      CheckTransferLimitRequest(
        fromcurrency: selectedSender,
        receiveAmount: double.parse(recipientController.text),
        sendAmount: double.parse(sendController.text),
        tocurrency: selectedReceiver,
      ),
    )
        .then((value) {
      if (value.runtimeType == String) {
        errorExchangeValue = value as String;
      }
    });
  }

  getSendCountryApi(BuildContext context) async {
    await FundTransferRepository()
        .apiSendCountry(
      context,
    )
        .then((value) {
      List<SendCountryResponse> response = value as List<SendCountryResponse>;
      for (int i = 0; i < senderData.length; i++) {
        if (selectedSender == response[i].currencyCode) {
          sendCurrencyId = response[i].countryId!;
        }
      }
      SharedPreferencesMobileWeb.instance
          .setSendCurrencyId(AppConstants.sendCurrencyIdData, sendCurrencyId);
    });
    senderBankAccounts.clear();
    senderBankId.clear();
    senderAccountResponseSG.clear();
    await getSenderBankAccountsSG(context);
  }

  getReceiverCountryApi(BuildContext context) async {
    await FundTransferRepository()
        .apiReceiveCountry(
      context,
    )
        .then((value) {
      List<ReceiveCountryResponse> response =
      value as List<ReceiveCountryResponse>;
      print("Hello");
      print(response.length);
      print(receiverData.length);
      //for saving country Id
      for (int i = 0; i < receiverData.length; i++) {
        if (selectedReceiver == response[i].currencyCode) {
          receiverCurrencyId = response[i].countryId!;
        }
      }
      receiverCurrencyId = receiverCountryId;
      SharedPreferencesMobileWeb.instance
          .setReceiveCurrencyId(AppConstants.receiveCurrencyIdData, receiverCurrencyId);
    });
  }

  getReceiverBankAccounts(BuildContext context, int countryID) async {
    var data = await ReceiverRepository()
        .getReceiverDetailByCountryID(context, countryID);
    receiverAccountResponse = data;

    receiverBankAccounts.clear();
    receiverBankId.clear();
    receiverBankAccountNumber.clear();
    receiverBankName.clear();
    receiverName.clear();
    receiverCountry.clear();
    data.forEach((element) {
      receiverBankAccounts.add("${element.firstName} ${element.accountNumber}");
      receiverBankId.add(element.receiverAccountId.toString());
      receiverBankAccountNumber.add(element.accountNumber.toString());
      receiverName.add(element.firstName.toString());
    });

    notifyListeners();
  }

  getPhoneNumberData(BuildContext context)async{
    await SharedPreferencesMobileWeb.instance.getPhoneNumber(AppConstants.phoneNumber).then((value) {
      selectedMobileNumber = value.substring(1, value.length);
    });
  }

  getBankNameAndCountryAUS(BuildContext context) async {
    await ReceiverRepository().receiverAusList(context).then((value) {
      List<ReceiverListAusResponse> receiveData =
      value as List<ReceiverListAusResponse>;
      receiveData.forEach((element) {
        if (element.receiverAccountId == int.parse(selectedBankReceiverId)) {
          receiverBankNameData =
          element.bankName == null ? " - " : element.bankName.toString();
          receiverCountryData = element.country.toString();
        }
      });
    });
  }

  getBankNameAndCountry(BuildContext context) async {
    await ReceiverRepository()
        .receiverDataById(context, selectedBankReceiverId)
        .then((value) {
      ReceiverDataByIdResponse res = value as ReceiverDataByIdResponse;
      receiverBankNameData =
      res.bankName == null ? " - " : res.bankName.toString();
      receiverCountryData = res.country.toString();
      receiverAccountNumberData = res.accountNumber.toString();
      receiverNameData = res.name!;
    });
  }

  getRelationShipApi(BuildContext context) {
    FundTransferRepository().apiRelationShipDataAus(context).then((value) {
      List<RelationShipAustraliaResponse> relationshipResponse =
      value as List<RelationShipAustraliaResponse>;
      relationshipResponseData = relationshipResponse;
      relationshipResponse.forEach((element) {
        relationshipData.add(element.relationshipName!);
      });
    });
  }

  getTransferPurposeApi(BuildContext context) {
    FundTransferRepository().apiTransferPurposeAus(context).then((value) {
      List<TransferPurposeAustraliaResponse> transferPurposeResponse =
      value as List<TransferPurposeAustraliaResponse>;
      transferPurposeResponseData = transferPurposeResponse;
      transferPurposeResponse.forEach((element) {
        transferPurposeData.add(element.transferPurposeName!);
      });
    });
  }

  getCustomerRatingApi(BuildContext context) {
    FundTransferRepository().customerRating(context, contactId).then((value) {
      CustomerRatingResponse response = value as CustomerRatingResponse;
      isRatingDone = response.isratingdone!;
      if (!isRatingDone) buildAlertDialog(context);
    });
  }

  transactionFileUpload(filePath, fileName, field, userTransactionId, context) {
    FundTransferRepository().apiTransactionFileUpload(
        filePath, fileName, contactId, field, userTransactionId, context).then((value) {
      TransactionFileUploadResponse transactionFileUploadResponse=value as TransactionFileUploadResponse;
      if(transactionFileUploadResponse.status == 200){
        showAlertDocumentUpload(context);
        isDocumentNeedUpload = false;
      }
    });
  }

  Future showAlertDocumentUpload(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppInActiveCheck(
        context: context,
        child: AppInActiveCheck(
          context: context,
          child: new AlertDialog(
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
              title: Text("Document Submitted Successfully!",textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thank you for submitting the document(s)."),
                  sizedBoxHeight10(context),
                  Text("Please proceed to make the payment to us for the transaction, if you have not already done so."),
                ],
              )
          ),
        ),
      ),
    );
  }

  exchangeApi(BuildContext context, String fromCurrency, String toCurrency,
      String typeData, double textEdit, bool canChangeExchange) async {
    errorExchangeValue = "";
    countryData == AppConstants.australia
        ? (selectedReceiver == "PHP" && isSwift == true) ? await FxRepository()
        .apiExchangePHPAustralia(
        ExchangeAustraliaRequest(
          tocurrencycode: toCurrency,
          label: typeData,
          toAmount: double.parse(recipientController.text),
          isswift: isSwift,
          fromcurrencycode: fromCurrency,
          fromAmount: double.parse(sendController.text),
          customerType: "Individual",
          contactId: contactId,
        ),
        context)
        .then((value) async{
      if (value.runtimeType == ExchangeAustraliaResponse) {
        ExchangeAustraliaResponse exchangeResponseData =
        value as ExchangeAustraliaResponse;
        singXData = double.parse(
            exchangeResponseData.response!.singxFee!.toString());
        totalPayable = double.parse(sendController.text) + singXData;
        if(canChangeExchange == true) exchangeRateConverted =
            exchangeResponseData.response!.exchangeRate.toString();
        corridorID = exchangeResponseData.response!.corridorId.toString();
        typeData == "Second"
            ? sendController.text =
            exchangeResponseData.response!.sendamount.toString()
            : recipientController.text =
            exchangeResponseData.response!.receiveamount.toString();
        await SharedPreferencesMobileWeb.instance
            .setCountryId(exchangeResponseData.response!.tocountryId!);
      } else {
        errorExchangeValue = value as String;
      }
    })
        : await FxRepository()
        .apiExchangeAustralia(
        ExchangeAustraliaRequest(
          tocurrencycode: toCurrency,
          label: typeData,
          toAmount: double.parse(recipientController.text),
          isswift: isSwift,
          fromcurrencycode: fromCurrency,
          fromAmount: double.parse(sendController.text),
          customerType: "Individual",
          contactId: contactId,
        ),
        context)
        .then((value) async{
      if (value.runtimeType == ExchangeAustraliaResponse) {
        ExchangeAustraliaResponse exchangeResponseData =
        value as ExchangeAustraliaResponse;
        singXData = double.parse(
            exchangeResponseData.response!.singxFee!.toString());
        totalPayable = double.parse(sendController.text) + singXData;
        if(canChangeExchange == true) exchangeRateConverted =
            exchangeResponseData.response!.exchangeRate.toString();
        corridorID = exchangeResponseData.response!.corridorId.toString();
        typeData == "Second"
            ? sendController.text =
            exchangeResponseData.response!.sendamount.toString()
            : recipientController.text =
            exchangeResponseData.response!.receiveamount.toString();
        await SharedPreferencesMobileWeb.instance
            .setCountryId(exchangeResponseData.response!.tocountryId!);
      } else {
        errorExchangeValue = value as String;
      }
    })         : await FxRepository()
        .apiExchange(
        ExchangeRequest(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          amount: textEdit,
          type: typeData,
          swift: isSwift,
          cash: isCash,
          wallet: isWallet,
        ),
        context)
        .then((value) async{
      if (value.runtimeType == ExchangeResponse) {
        ExchangeResponse exchangeResponseData = value as ExchangeResponse;
        singXData = exchangeResponseData.singxFee!;
        totalPayable = exchangeResponseData.totalPayable!;
        if(canChangeExchange == true) exchangeRateConverted =
            exchangeResponseData.exchangeRate!.toString();
        errorExchangeValue = exchangeResponseData.errors!.isEmpty ? '' : exchangeResponseData.errors!.first;
        senderCountryId = exchangeResponseData.fromCountryId!;
        receiverCountryId = exchangeResponseData.toCountryId!;
        typeData == "Send"
            ? null
            : sendController.text =
            exchangeResponseData.sendAmount.toString();
        typeData == "Send"
            ? recipientController.text =
            exchangeResponseData.receiveAmount.toString()
            : null;
      } else {
        errorExchangeValue = value as String;
      }
    });
  }

  corridorApi(BuildContext context) async {
    countryData == AppConstants.australia
        ? {
      await FxRepository().apiSenderCurrency(context).then((value) {
        List<GetSenderCurrencyAustraliaResponse> corridorData =
        value as List<GetSenderCurrencyAustraliaResponse>;
        corridorData.forEach((element) {
          senderData.add(element.currencyCode!);
        });
        selectedSender = senderData.first;
        exchangeSelectedSender = selectedSender;
      }),
      await FxRepository().apiReceiverCurrency(context).then((value) {
        if (receiverCountryIDData.isNotEmpty) {
          receiverCountryIDData.clear();
        }
        List<GetReceiverCurrencyAustraliaResponse> corridorData =
        value as List<GetReceiverCurrencyAustraliaResponse>;
        corridorData.forEach((element) {
          receiverData.add(element.currencyCode!);
          receiverCountryIDData.add(element.countryId!);
        });
        selectedReceiver = receiverData.first;
        exchangeSelectedReceiver = selectedReceiver;
        selectedReceiverCountryID = receiverCountryIDData.first;
      })
    }
        : countryData == AppConstants.hongKong
        ? {
      await FxRepository().apiCorridors(context).then((value) {
        Map<String, List<CorridorsResponse>> corridorData =
        value as Map<String, List<CorridorsResponse>>;
        corridorData.forEach((key, value) {
          if (countryData == HongKongName) {
            if (key == "HKD") senderData.add(key);
          }
        });
        selectedSender = senderData.first;
        exchangeSelectedSender = selectedSender;

        FxRepository().corridorResponseData.forEach((key, value) {
          if (_selectedSender == key) {
            value.forEach((element) {
              receiverData.add(element.key!);
            });
          }
        });
        selectedReceiver = receiverData.first;
      })
    }
        : await FxRepository().apiCorridors(context).then((value) {
      Map<String, List<CorridorsResponse>> corridorData =
      value as Map<String, List<CorridorsResponse>>;
      corridorData.forEach((key, value) {
        senderData.add(key);
      });
      selectedSender = senderData.first;
      exchangeSelectedSender = selectedSender;

      FxRepository().corridorResponseData.forEach((key, value) {
        if (_selectedSender == key) {
          value.forEach((element) {
            receiverData.add(element.key!);
          });
        }
      });
      selectedReceiver = receiverData.first;
    });
  }

  getWalletBalance(BuildContext context) {
    SGWalletRepository().SGWalletBalance(context).then((value) {
      SgWalletBalance sgWalletBalance = value as SgWalletBalance;
      walletBalance = sgWalletBalance.balance!;
      if (walletBalance != '0.0' && double.parse(sendController.text) < double.parse(walletBalance) && selectedSender == 'SGD') {
        isAccountTypeSelected = false;
        isTopUpVisible = false;
      } else {
        isAccountTypeSelected = true;
        isTopUpVisible = true;
      }

    });
  }

  getFundTransferCalcStoredData(BuildContext context) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.containsKey(dashboardCalc)
        ? await SharedPreferencesMobileWeb.instance
        .getDashboardCalculatorData(dashboardCalc)
        .then((dashboardValue) async {
      Map<String, dynamic> newDashboardValue =
      jsonDecode(dashboardValue) as Map<String, dynamic>;
      sendController.text = newDashboardValue["sendAmount"];
      recipientController.text = newDashboardValue["receiveAmount"];
      selectedSender = newDashboardValue["sendCurrency"];
      exchangeSelectedSender = newDashboardValue["sendCurrency"];
      selectedReceiver = newDashboardValue["receiveCurrency"];
      selectedTransferMode = newDashboardValue["selectedTransferMode"];
      isSwift = newDashboardValue["isSwift"];
      isCash = newDashboardValue["isCash"];
      (selectedReceiver == "PHP" &&  countryData != AustraliaName)? (selectedRadioTile = isCash == false ? 1 : 2) : (selectedRadioTile = isSwift == false ? 1 : 2);
      selectedRadioTile = newDashboardValue["selectedRadioTile"];
      if(selectedReceiver == "PHP" &&  countryData != AustraliaName) isCash = selectedRadioTile == 2 ? true : false;
      if(selectedReceiver == "BDT") isWallet = selectedRadioTile == 2 ? true : false;
      exchangeSelectedReceiver = selectedReceiver;
    })
        : '';
  }

  getCustomerRatingApiSG(BuildContext context) async {
    String userId = "";
    await SharedPreferencesMobileWeb.instance.getUserData(AppConstants.user).then((value) {
      Map<String, dynamic> loginData =
      jsonDecode(value) as Map<String, dynamic>;
      userId = loginData['userinfo']['userId'];
    });
    FundTransferRepository().customerRatingSG(context, userId).then((value) {
      CustomerRatingResponseSg response = value as CustomerRatingResponseSg;
      isRatingDone = response.response!.ratingPopcliked!;
      if (!isRatingDone) buildAlertDialog(context, isSG: true, userId: userId);
    });
  }

  getRelationShipApiSG(BuildContext context) {
    FundTransferRepository().apiRelationshipDropdown(context).then((value) {
      List<RelationshipDropdownResponse> relationshipResponse =
      value as List<RelationshipDropdownResponse>;
      relationshipResponseDataSing = relationshipResponse;
      relationshipResponse.forEach((element) {
        relationshipData.add(element.relationshipName!);
      });
    });
  }

  getSenderBankAccountsSG(BuildContext context) {
    repository.apiSenderAccountDetails(sendCurrencyId).then((value) {
      List<GetSenderAccountDetails> response =
      value as List<GetSenderAccountDetails>;
      senderAccountResponseSG = response;
      response.forEach((element) {
        senderBankAccounts.add(
            "${element.name} ${element.bankName} ${element.accountNumber}");
        senderBankId.add(element.id!);
      });
    });
  }

  getReceiverBankAccountsSG(BuildContext context) async {
    // await repository
    //     .apiReceieverAccountList(context, receiverCurrencyId)
    //     .then((value) {
    //   List<ReceiverListResponse> response =
    //       value as List<ReceiverListResponse>;
    //   receiverAccountResponseSG = response;
    //   response.forEach((element) {
    //     receiverBankAccounts.add("${element.accInfo} ");
    //     receiverBankId.add(element.receiverId!);
    //   });
    // });
    await SharedPreferencesMobileWeb.instance
        .getFundTransferAccountData(AppConstants.accountScreenData)
        .then((value) async {
      Map<String, dynamic> newValue =
      jsonDecode(value) as Map<String, dynamic>;
      receiverCurrencyId = newValue["receiverCountryId"];
    });
    await repository
        .apiReceieverAccountDetails(context, receiverCurrencyId)
        .then((value) {
      List<GetReceiverAccountDetails> response =
      value as List<GetReceiverAccountDetails>;
      receiverAccountResponseSG = response;
      response.forEach((element) {
        if(selectedReceiver == "BDT"){
          if(selectedRadioTile == 1 && element.bankTypeId == 1){
            receiverBankAccounts.add("${element.accInfo} ");
            receiverBankId.add(element.receiverId!);
          }else if(selectedRadioTile == 2 && element.bankTypeId == 2) {
            receiverBankAccounts.add("${element.accInfo} ");
            receiverBankId.add(element.receiverId!);
          }
        }else{
          receiverBankAccounts.add("${element.accInfo} ");
          receiverBankId.add(element.receiverId!);
        }
      });
    });
  }

  getTransferPurposeApiSG(BuildContext context) {
    FundTransferRepository()
        .apiTransferPurposeAusSingapore(context)
        .then((value) {
      List<TransferPurposeSingResponse> transferPurposeResponse =
      value as List<TransferPurposeSingResponse>;
      transferPurposeResponseDataSing = transferPurposeResponse;
      transferPurposeResponse.forEach((element) {
        transferPurposeData.add(element.transferPurposeName!);
      });
    });
  }

  buildAlertDialog(context, {bool isSG = false, String? userId}) {
    Widget rateUsButton = Center(
      child: buildButton(
        context,
        name: "Rate Us Now",
        width: 150,
        fontColor: white,
        color: orangePantoneTint500,
        onPressed: () {
          if (isSG) {
            repository.customerRatingReviewPopupClicked(context, userId!);
          }
          launchUrlString(isSG ? ratingUrlSG : ratingUrlAUS);
        },
      ),
    );

    Widget title = Row(
      children: [
        buildText(
            text: "Thank You", fontColor: orangePantoneTint600, fontSize: 24),
        Spacer(),
        GestureDetector(
          onTap: () {
            MyApp.navigatorKey.currentState!.maybePop();
            // Navigator.pop(context);
          },
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.close,
              color: orangePantone,
              size: 15,
            ),
          ),
        ),
      ],
    );
    Widget content = SizedBox(
        height: 20,
        child: Center(
            child: buildText(
                text: "Please take a moment  to rate our services!")));

    AlertDialog alert = AlertDialog(
      title: title,
      content: content,
      actions: [rateUsButton, SizedBox(height: 10)],
    );

    CupertinoAlertDialog alertIos = CupertinoAlertDialog(
      title: title,
      content: content,
      actions: [rateUsButton, SizedBox(height: 10)],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // if (Theme.of(context).platform == TargetPlatform.iOS) {
        //   return AppInActiveCheck(context: context, child: alertIos);
        // }
        return AppInActiveCheck(context: context, child: alert);
      },
    );
  }

  // Getter and Setter

  get screenSize => _screenSize;

  set screenSize(value) {
    if(value == _screenSize)return;
    _screenSize = value;
    notifyListeners();
  }

  setSelectedRadioTile(int val) {
    selectedRadioTile = val;
  }

  int get selectedRadioTile => _selectedRadioTile;

  set selectedRadioTile(int value) {
    if (value == _selectedRadioTile) return;
    _selectedRadioTile = value;
    notifyListeners();
  }
  String get selectedAccountType => _selectedAccountType;

  set selectedAccountType(String value) {
    if (value == _selectedAccountType) return;
    _selectedAccountType = value;
    notifyListeners();
  }

  String get walletBalance => _walletBalance;

  set walletBalance(String value) {
    if (walletBalance == value) return;
    _walletBalance = value;
    notifyListeners();
  }

  double get singXDataOld => _singXDataOld;

  set singXDataOld(double value) {
    if (singXDataOld == value) return;
    _singXDataOld = value;
    notifyListeners();
  }

  List<String> get receiverData => _receiverData;

  set receiverData(List<String> value) {
    if (value == _receiverData) return;
    _receiverData = value;
    notifyListeners();
  } //boolean value

  List<int> get receiverCountryIDData => _receiverCountryIDData;

  set receiverCountryIDData(List<int> value) {
    _receiverCountryIDData = value;
    notifyListeners();
  }

  List<String> get senderData => _senderData;

  set senderData(List<String> value) {
    if (value == _senderData) return;
    _senderData = value;
    notifyListeners();
  }

  List<SenderListResponseAus> get senderAccountResponse =>
      _senderAccountResponse;

  set senderAccountResponse(List<SenderListResponseAus> value) {
    if (value == _senderAccountResponse) return;
    _senderAccountResponse = value;
    notifyListeners();
  }

  List<GetSenderAccountDetails> get senderAccountResponseSG =>
      _senderAccountResponseSG;

  set senderAccountResponseSG(List<GetSenderAccountDetails> value) {
    if (value == _senderAccountResponseSG) return;
    _senderAccountResponseSG = value;
    notifyListeners();
  }

  List<GetReceiverAccountDetails> get receiverAccountResponseSG =>
      _receiverAccountResponseSG;

  set receiverAccountResponseSG(List<GetReceiverAccountDetails> value) {
    if (value == _receiverAccountResponseSG) return;
    _receiverAccountResponseSG = value;
    notifyListeners();
  }

  List<ReceiverListAusResponse> get receiverAccountResponse =>
      _receiverAccountResponse;

  set receiverAccountResponse(List<ReceiverListAusResponse> value) {
    if (value == _receiverAccountResponse) return;
    _receiverAccountResponse = value;
    notifyListeners();
  }

  String get errorExchangeValue => _errorExchangeValue;

  set errorExchangeValue(String value) {
    if (_errorExchangeValue == value) return;
    _errorExchangeValue = value;
    notifyListeners();
  }

  double get totalPayable => _totalPayable;

  set totalPayable(double value) {
    if (value == _totalPayable) return;
    _totalPayable = value;
    notifyListeners();
  }

  String get selectedSender => _selectedSender;

  set selectedSender(String value) {
    if (_selectedSender == value) return;
    _selectedSender = value;
    notifyListeners();
  }

  String get selectedReceiver => _selectedReceiver;

  set selectedReceiver(String value) {
    if (_selectedReceiver == value) return;
    _selectedReceiver = value;
    notifyListeners();
  }

  bool get referenceCopied => _referenceCopied;

  set referenceCopied(bool value) {
    if (_referenceCopied == value) return;
    _referenceCopied = value;
    notifyListeners();
  }

  bool get accountNameCopied => _accountNameCopied;

  set accountNameCopied(bool value) {
    if (_accountNameCopied == value) return;
    _accountNameCopied = value;
    notifyListeners();
  }

  bool get accountNumberCopied => _accountNumberCopied;

  set accountNumberCopied(bool value) {
    if (_accountNumberCopied == value) return;
    _accountNumberCopied = value;
    notifyListeners();
  }

  bool get bsbCodeCopied => _bsbCodeCopied;

  set bsbCodeCopied(bool value) {
    if (_bsbCodeCopied == value) return;
    _bsbCodeCopied = value;
    notifyListeners();
  }

  bool get uenCopied => _uenCopied;

  set uenCopied(bool value) {
    if (_uenCopied == value) return;
    _uenCopied = value;
    notifyListeners();
  }

  bool get isDocumentNeedUpload => _isDocumentNeedUpload;

  set isDocumentNeedUpload(bool value) {
    if (_isDocumentNeedUpload == value) return;
    _isDocumentNeedUpload = value;
    notifyListeners();
  }

  bool get isFileLoading => _isFileLoading;

  set isFileLoading(bool value) {
    if (_isFileLoading == value) {
      return;
    }
    _isFileLoading = value;
    notifyListeners();
  }

  bool get isFileAdded => _isFileAdded;

  set isFileAdded(bool value) {
    if (_isFileAdded == value) {
      return;
    }
    _isFileAdded = value;
    _isFileAdded == true
        ? isFileAddedVerification = false
        : isFileAddedVerification = true;
    notifyListeners();
  }

  bool get isFileAddedVerification => _isFileAddedVerification;

  set isFileAddedVerification(bool value) {
    if (_isFileAddedVerification == value) {
      return;
    }
    _isFileAddedVerification = value;
    notifyListeners();
  }

  double get progressValue => _progressValue;

  set progressValue(double value) {
    if (_progressValue == value) {
      return;
    }

    _progressValue = value;
    notifyListeners();
  }

  double get singXData => _singXData;

  set singXData(double value) {
    if (value == _singXData) return;
    _singXData = value;
    notifyListeners();
  }

  String get selectedMobileNumber => _selectedMobileNumber;

  set selectedMobileNumber(String value) {
    if(_selectedMobileNumber == value) return;
    _selectedMobileNumber = value;
    notifyListeners();
  }

  String get exchangeSelectedSender => _exchangeSelectedSender;

  set exchangeSelectedSender(String value) {
    if (_exchangeSelectedSender == value) return;
    _exchangeSelectedSender = value;
    notifyListeners();
  }

  String get exchangeSelectedReceiver => _exchangeSelectedReceiver;

  set exchangeSelectedReceiver(String value) {
    if (_exchangeSelectedReceiver == value) return;
    _exchangeSelectedReceiver = value;
    notifyListeners();
  }

  int get relationshipId => _relationshipId;

  set relationshipId(int value) {
    if (value == _relationshipId) return;
    _relationshipId = value;
    notifyListeners();
  }

  int get transferPurposeId => _transferPurposeId;

  set transferPurposeId(int value) {
    if (value == _transferPurposeId) return;
    _transferPurposeId = value;
    notifyListeners();
  }

  bool get isWallet => _isWallet;

  set isWallet(bool value) {
    if (_isWallet == value) return;
    _isWallet = value;
    notifyListeners();
  }

  bool get isCash => _isCash;

  set isCash(bool value) {
    if (_isCash == value) return;
    _isCash = value;
    notifyListeners();
  }

  bool get isSwift => _isSwift;

  set isSwift(bool value) {
    if (_isSwift == value) return;
    _isSwift = value;
    notifyListeners();
  }

  bool get isTopUpVisible => _isTopUpVisible;

  set isTopUpVisible(bool value) {
    if (_isTopUpVisible == value) return;
    _isTopUpVisible = value;
    notifyListeners();
  }

  bool get isRatingDone => _isRatingDone;

  set isRatingDone(bool value) {
    if (_isRatingDone == value) return;
    _isRatingDone = value;
    notifyListeners();
  }

  TextEditingController get selectedSenderBankController =>
      _selectedSenderBankController;

  set selectedSenderBankController(TextEditingController value) {
    _selectedSenderBankController = value;
  }

  TextEditingController get selectedReceiverBankController =>
      _selectedReceiverBankController;

  set selectedReceiverBankController(TextEditingController value) {
    _selectedReceiverBankController = value;
  }

  TextEditingController get selectedPurposeOfTransferController =>
      _selectedPurposeOfTransferController;

  set selectedPurposeOfTransferController(TextEditingController value) {
    _selectedPurposeOfTransferController = value;
  }

  TextEditingController get selectedRelationshipWithSenderController =>
      _selectedRelationshipWithSenderController;

  set selectedRelationshipWithSenderController(TextEditingController value) {
    _selectedRelationshipWithSenderController = value;
  }

  String get corridorID => _corridorID;

  set corridorID(String value) {
    if (_corridorID == value) return;
    _corridorID = value;
    notifyListeners();
  }

  String get senderCountryId => _senderCountryId;

  set senderCountryId(String value) {
    if(_sendCurrencyId == value) return;
    _senderCountryId = value;
    notifyListeners();
  }

  String get receiverCountryId => _receiverCountryId;

  set receiverCountryId(String value) {
    if(_receiverCurrencyId == value) return;
    _receiverCountryId = value;
    notifyListeners();
  }

  String get selectedBankReceiverId => _selectedBankReceiverId!;

  set selectedBankReceiverId(String value) {
    if (value == _selectedBankReceiverId) return;
    _selectedBankReceiverId = value;
    notifyListeners();
  }

  String? get selectedReceiverBank => _selectedReceiverBank;

  set selectedReceiverBank(String? value) {
    if (_selectedReceiverBank == value) return;
    _selectedReceiverBank = value;
    notifyListeners();
  }

  String get selectedBankId => _selectedBankId!;

  set selectedBankId(String value) {
    if (_selectedBankId == value) return;
    _selectedBankId = value;
    notifyListeners();
  }

  String get OTPErrorMessage => _OTPErrorMessage;

  set OTPErrorMessage(String value) {
    if(value == _OTPErrorMessage) return;
    _OTPErrorMessage = value;
    notifyListeners();
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    if(value==_branchCode)return;
    _branchCode = value;
    notifyListeners();
  }

  String get bankCode => _bankCode;

  set bankCode(String value) {
    if(value == _bankCode)return;
    _bankCode = value;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    if (value == _errorMessage) return;
    _errorMessage = value;
    notifyListeners();
  }

  int get selectedTile => _selectedTile;

  set selectedTile(int value) {
    if (value == _selectedTile) {
      return;
    }
    _selectedTile = value;
    notifyListeners();
  }

  String get exchangeRateInitial => _exchangeRateInitial;

  set exchangeRateInitial(String value) {
    if (_exchangeRateInitial == value) {
      return;
    }
    _exchangeRateInitial = value;
    notifyListeners();
  }

  String get selectedFrom => _selectedFrom;

  set selectedFrom(String value) {
    if (_selectedFrom == value) {
      return;
    }
    _selectedFrom = value;
    notifyListeners();
  }

  List<TransferPurposeAustraliaResponse> get transferPurposeResponseData =>
      _transferPurposeResponseData;

  set transferPurposeResponseData(
      List<TransferPurposeAustraliaResponse> value) {
    if (value == _transferPurposeResponseData) return;
    _transferPurposeResponseData = value;
    notifyListeners();
  }

  List<TransferPurposeSingResponse> get transferPurposeResponseDataSing =>
      _transferPurposeResponseDataSing;

  set transferPurposeResponseDataSing(List<TransferPurposeSingResponse> value) {
    _transferPurposeResponseDataSing = value;
  }

  List<RelationShipAustraliaResponse> get relationshipResponseData =>
      _relationshipResponseData;

  set relationshipResponseData(List<RelationShipAustraliaResponse> value) {
    if (value == _relationshipResponseData) return;
    _relationshipResponseData = value;
    notifyListeners();
  }

  List<RelationshipDropdownResponse> get relationshipResponseDataSing =>
      _relationshipResponseDataSing;

  set relationshipResponseDataSing(List<RelationshipDropdownResponse> value) {
    if (value == _relationshipResponseData) return;
    _relationshipResponseDataSing = value;
    notifyListeners();
  }

  List<String> get senderBankAccounts => _senderBankAccounts;

  set senderBankAccounts(List<String> value) {
    if (_senderBankAccounts == value) return;
    _senderBankAccounts = value;
    notifyListeners();
  }

  List<String> get receiverBankId => _receiverBankId;

  set receiverBankId(List<String> value) {
    if (value == _receiverAccountId) return;
    _receiverBankId = value;
    notifyListeners();
  }

  List<String> get receiverBankName => _receiverBankName;

  set receiverBankName(List<String> value) {
    if (value == _receiverBankName) return;
    _receiverBankName = value;
    notifyListeners();
  }

  List<String> get receiverName => _receiverName;

  set receiverName(List<String> value) {
    if (value == _receiverName) return;
    _receiverName = value;
    notifyListeners();
  }

  List<String> get receiverCountry => _receiverCountry;

  set receiverCountry(List<String> value) {
    if (value == _receiverCountry) return;
    _receiverCountry = value;
    notifyListeners();
  }

  List<String> get receiverBankAccountNumber => _receiverBankAccountNumber;

  set receiverBankAccountNumber(List<String> value) {
    if (value == _receiverBankAccountNumber) return;
    _receiverBankAccountNumber = value;
    notifyListeners();
  }

  List get senderBankId => _senderBankId;

  set senderBankId(List value) {
    if (value == _selectedBankId) return;
    _senderBankId = value;
    notifyListeners();
  }

  List<String> get receiverBankAccounts => _receiverBankAccounts;

  set receiverBankAccounts(List<String> value) {
    if (_receiverBankAccounts == value) return;
    _receiverBankAccounts = value;
    notifyListeners();
  }

  List<String> get relationshipData => _relationshipData;

  set relationshipData(List<String> value) {
    if (_relationshipData == value) return;
    _relationshipData = value;
    notifyListeners();
  }

  List<String> get transferPurposeData => _transferPurposeData;

  set transferPurposeData(List<String> value) {
    if (_transferPurposeData == value) return;
    _transferPurposeData = value;
    notifyListeners();
  }

  String get selectedTo => _selectedTo;

  set selectedTo(String value) {
    if (_selectedTo == value) {
      return;
    }
    _selectedTo = value;
    notifyListeners();
  }

  String get exchangeRateConverted => _exchangeRateConverted;

  set exchangeRateConverted(String value) {
    if (_exchangeRateConverted == value) {
      return;
    }
    _exchangeRateConverted = value;
    notifyListeners();
  }

  int get fundCount => (_fundCount != null) ? _fundCount! : 2;

  set fundCount(int value) {
    if (_fundCount == value) {
      return;
    }
    _fundCount = value;
    notifyListeners();
  }

  get isAccountSelected => _isAccountSelected;

  set isAccountSelected(value) {
    if (_isAccountSelected == value) {
      return;
    }
    _isAccountSelected = value;
    notifyListeners();
  }

  get isReceiverSelected => _isReceiverSelected;

  set isReceiverSelected(value) {
    if (_isReceiverSelected == value) {
      return;
    }
    _isReceiverSelected = value;
    notifyListeners();
  }

  get isReviewSelected => _isReviewSelected;

  set isReviewSelected(value) {
    if (_isReviewSelected == value) {
      return;
    }
    _isReviewSelected = value;
    notifyListeners();
  }

  bool get isAccountTypeSelected => _isAccountTypeSelected;

  set isAccountTypeSelected(bool value) {
    if (_isAccountTypeSelected == value) {
      return;
    }
    _isAccountTypeSelected = value;
    notifyListeners();
  }

  String get accountNumber => _accountNumber!;

  set accountNumber(String value) {
    if (_accountNumber == value) return;
    _accountNumber = value;
    notifyListeners();
  }

  int get accountNumberAus => _accountNumberAus!;

  set accountNumberAus(int value) {
    if (_accountNumberAus == value) return;
    _accountNumberAus = value;
    notifyListeners();
  }

  String get referenceNumber => _referenceNumber!;

  set referenceNumber(String value) {
    if (_referenceNumber == value) return;
    _referenceNumber = value;
    notifyListeners();
  }

  String get bankName => _bankName!;

  set bankName(String value) {
    if (_bankName == value) return;
    _bankName = value;
    notifyListeners();
  }

  String get accountName => _accountName!;

  set accountName(String value) {
    if (_accountName == value) return;
    _accountName = value;
    notifyListeners();
  }

  String get bsbCode => _bsbCode!;

  set bsbCode(String value) {
    if (_bsbCode == value) return;
    _bsbCode = value;
    notifyListeners();
  }

  TextEditingController get sendController => _sendController;

  set sendController(TextEditingController value) {
    if (_sendController == value) return;
    _sendController = value;
  }

  TextEditingController get recipientController => _recipientController;

  set recipientController(TextEditingController value) {
    if (_recipientController == value) return;
    _recipientController = value;
  }

  int get senderAccountId => _senderAccountId;

  set senderAccountId(int value) {
    if (value == _senderAccountId) return;
    _senderAccountId = value;
    notifyListeners();
  }

  int get receiverAccountId => _receiverAccountId;

  set receiverAccountId(int value) {
    if (value == _receiverAccountId) return;
    _receiverAccountId = value;
    notifyListeners();
  }

  String get checkTransferLimit => _checkTransferLimit;

  set checkTransferLimit(String value) {
    if (value == _checkTransferLimit) return;
    _checkTransferLimit = value;
    notifyListeners();
  }

  String get receiverAccountNumberData => _receiverAccountNumberData;

  set receiverAccountNumberData(String value) {
    if (_receiverAccountNumberData == value) return;
    _receiverAccountNumberData = value;
    notifyListeners();
  }

  String get receiverBankNameData => _receiverBankNameData;

  set receiverBankNameData(String value) {
    if (_receiverBankNameData == value) return;
    _receiverBankNameData = value;
    notifyListeners();
  }

  String get receiverNameData => _receiverNameData;

  set receiverNameData(String value) {
    if (_receiverNameData == value) return;
    _receiverNameData = value;
    notifyListeners();
  }

  String get receiverCountryData => _receiverCountryData;

  set receiverCountryData(String value) {
    if (_receiverCountryData == value) return;
    _receiverCountryData = value;
    notifyListeners();
  }

  int get userTransactionId => _userTransactionId;

  set userTransactionId(int value) {
    if (_userTransactionId == value) return;
    _userTransactionId = value;
    notifyListeners();
  }

  String? get purposeOfTransfer => _purposeOfTransfer;

  set purposeOfTransfer(String? value) {
    if (value == _purposeOfTransfer) return;
    _purposeOfTransfer = value;
    notifyListeners();
  }

  String? get relationshipWithSender => _relationshipWithSender;

  set relationshipWithSender(String? value) {
    if (_relationshipWithSender == value) return;
    _relationshipWithSender = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    if (value == _isLoading) return;
    _isLoading = value;
    notifyListeners();
  }

  String get sendCurrencyId => _sendCurrencyId;

  set sendCurrencyId(String value) {
    if (value == _sendCurrencyId) return;
    _sendCurrencyId = value;
    notifyListeners();
  }

  String get receiverCurrencyId => _receiverCurrencyId;

  set receiverCurrencyId(String value) {
    if (_receiverCurrencyId == value) return;
    _receiverCurrencyId = value;
    notifyListeners();
  }

  int get selectedTransferMode => _selectedTransferMode;

  set selectedTransferMode(int value) {
    if (value == _selectedTransferMode) return;
    _selectedTransferMode = value;
    notifyListeners();
  }

}
