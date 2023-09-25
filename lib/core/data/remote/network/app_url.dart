class AppUrl {
  // static final baseHost = "api-uat.singx.co/central";
  static final baseHostAus = "uatau.singx.co";
  static final baseHost = "api-uat.singx.co/central";
  static final baseHostSGBP = "api-uat.singx.co/central/bp";
  static final baseHostDropdown = "uat.singx.co/centralizecode/";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";
  static final baseImageUrl = '$baseUrl/pub/media/catalog/product/';
  static final baseUrlAus = "$baseHttp$baseHostAus";
  static final baseUrlSGBP = "$baseHttp$baseHostSGBP";
  static final baseUrlDropdown = "$baseHttp$baseHostDropdown";

  //login
  static final pathLogin = "/auth/authenticate"; //POST
  static final pathLoginAustralia = "/singx/customer/verify"; //POST
  //register
  static final pathRegister = "/auth/register"; //POST
  static final pathRegisterAus = "/singx/signup/"; //POST
  static final pathForgetPassword = "/auth/forgotPassword/request"; //POST
  static final pathForgetPasswordStep2 = "/auth/forgotPassword/verify"; //POST
  static final pathChangePassword = "/auth/changePassword"; //POST
  static final pathRefreshToken = "/auth/renew"; //GET
  static final pathLogout = "/auth/logout"; //GET
  static final pathAuthDetail = "/auth/details"; //GET
  static final pathSingPassUrl = "/verification/myinfo/init"; //GET
  static final pathIndustryList = "/industry/list"; //GET
  static final pathGetPostalCode = "sgpost/569934"; //GET
  static final pathPersonalDetailsSg = "/sg-onboarding/profile/step1"; //Post
  static final pathIndividualRegDetail = "/contact/IndividualRegDetail"; //Post
  static final fetchOTP ="/otp/fetch";
  static final pathAddressVerificationSg = "/sg-onboarding/profile/address"; //Post
  static final pathReceiverList = "/receivers/v1/"; //GET
  static final pathReceiverDataById = "/receivers/v1/"; //GET
  static final pathSenderList = "/sender/v1/"; //GET
  static final pathSenderFields = "/sender/v1/add/fields/"; //GET
  static final pathAddSender = "/sender/v1/add";
  static final pathReceiverCountry = "/receivers/v1/add/countries"; //GET
  static final pathReceiverFields = "/receivers/v1/add/"; //GET
  static final pathAddReceiver= "/receivers/v1/add";
  static final pathDeleteReceiverSG_HK = "/receivers/v1/";
  static final pathCorridors = "/fx/corridors"; //GET
  static final pathGetInvoiceSing = "/transaction/v1/invoice/"; //GET
  static final pathViewDocument = "/sg-onboarding/document/view/"; //GET
  static final pathViewDocumentHk = "/hk-onboarding/document/view/"; //GET
  static final pathSenderCurrency = "/transaction/v1/sendcountry"; //GET
  static final pathReceiverCurrency = "/transaction/v1/receivecountry"; //GET
  static final pathSenderAccountDetails = "/transaction/v1/getCustomerAccDetails/"; //GET
  static final pathReceiverAccountDetails = "/transaction/v1/getReceiverAccDetails/"; //GET
  static final pathSendCountry = "/transaction/v1/sendcountry"; //GET
  static final pathReceiveCountry = "/transaction/v1/receivecountry"; //GET
  static final pathTransferLimit = "/transaction/v1/checktransferlimit"; //POST
  static final pathReceiverBankList ="/receivers/v1/bank";
  static final pathExchange = "/fx/exchange"; //POST
  static final pathExchangeAus = "/singx/exchangecal/getratespostlogin"; //POST
  static final pathExchangePHPAus = "/singx/exchangecal/getPhpCashratespostlogin"; //POST
  static final pathReferralAus =
      "/singx/referral/getreferral?contactId="; //POST
  static final pathOtpGenerate = "/otp/generate"; //Post
  static final pathOtpVerify = "/otp/verify"; //Post
  static final pathSGFiledUpload = "/sg-onboarding/docs/upload"; //Post
  static final pathTransactionFiledUpload = "/singx/Fileupload/singleDocupload"; //Post
  static final pathSGPostCodeAddress= "/sg-onboarding/postalcode/";

  static final jumioCallback = "/verification/jumio/verify";
  static final pathSingPassVerify = "/verification/myinfo/verify"; //Post
  static final jumioVerification = "/verification/jumio/init";
  static final pathDashboardNotification = "/sg/notifications"; //Get
  static final pathEditProfile = "/contact/"; //Get
  static final pathActivitesTransaction = "/transaction/v1/"; //Get
  static final pathBranchCodeValidation = "/receivers/v1/bank/";

  // fund transfer
  static final pathTransferPurposeSingapore = "/transaction/v1/getTransferPurpose/";
  static final pathValidatePromoSG ="/transaction/v1/validatepromo";
  static final pathGenerateOTPSG = "/transaction/v1/getOtp"; //POST
  static final pathBankAccountDetails  = "/transaction/v1/getSingxAccountDetails"; //GET
  static final pathCheckTransferLimit  = "/transaction/v1/checktransferlimit"; //GET
  static final pathRelationshipDropdown  = "/transaction/v1/relationship"; //GET
  static final pathSaveTransaction  = "/transaction/v1/add"; //POST
  static final pathCustomerRatingSG  = "/rating/isReviewPopupClicked/"; //GET
  static final pathSetReviewPopupClicked  = "/rating/setReviewPopupClicked/"; //GET

//Rate alert

  static final saveRateAlert = "/rate-alert/?currency=";
  static final deleteRateAlert = "/rate-alert/delete/";
  static final getCorridorID = "/rate-alert/corridors?currency=";
  // static final getCorridorID = "/rate-alert/corridors";
  static final updateRateAlert = "/rate-alert/update?currency=";


  ///////HONGKONG

  static final pathPersonalDetailsHK = "/hk-onboarding/profile/step1";
  static final pathPersonalDetailsStep2HK = "/hk-onboarding/profile/step2";//Post
  static final pathPersonalDetailsStep3HK = "/hk-onboarding/profile/step3";
  static final pathNationalityListHK = "/nationality/list";
 static final pathHKFiledUpload = "/hk-onboarding/docs/upload";
  static final pathHKVerifyOTP ="/hk-onboarding/profile/otp";
  static final pathGoogleAddressApi ="/singx/profilestepone/address?key=";
  static final pathGoogleAddressDetailsApi ="/singx/profilestepone/address/details?placeId=";
// pradheepkumarm@gmail.com
// Pradh3ep1

  static final pathDocumentList = "/sg-onboarding/documentlist"; //GET
  static final pathDocumentListHk = "/hk-onboarding/documentlist"; //GET

/////Australia/////
  static final pathLogoutAus = "/singx/signup/logoutSession"; //GET
  static final getAusDropdownValue = "/singx/profilestepone/getvalues"; //GET
  static final getAusCustomerDetails =
      "/singx/profilestepone/getdata?contactId="; //GET
  static final saveCustomerDetails = "/singx/profilestepone/save"; //POST
  static final updateCustomerDetails = "/singx/profilestepone/update"; //POST
  static final saveCRA = "/registration/profilesteptwo/save"; //POST
  static final nonCRAFileUpload =
      "/registration/profilesteptwo/fileupload"; //POST
  static final getDigitalVerificationStep2 =
      "/singx/profilesteptwo/getvalues"; //GET
  static final pathChangePasswordAUS = '/singx/password/change'; //Post
  static final pathForgetPasswordAUS = '/singx/password/forget'; //Post
  static final pathCustomerStatusAUS = '/singx/customer/status'; //Post
  static final pathSaveSessionAUS = '/singx/signup/saveSession'; //Post
  static final pathDashboardTransaction =
      '/singx/transactionStatement/gettxnhistory'; //Post
  static final pathDashboardChinaTransferLimit =
      '/singx/transaction/checkChinaPayTransferLimit'; //Post
  static final pathDashboardPHPTransferLimit =
      '/singx/transaction/checkPHPCashPickTransferLimit'; //Post

  static final pathGetInvoice =
      '/singx/transactionStatement/getInvoice'; //Post
  static final pathTransactionStatement =
      '/singx/transactionStatement/generateStatement'; //Post
  static final pathSenderListAus = '/singx/managesender/getsendaccdetails'; //GET
  static final pathSenderBanksDropDown = '/singx/bank/getbankdetails'; //GET
  static final pathSenderBankId = '/singx/bankBranch/getbranchdetailsbybankid'; //GET
  static final pathSenderFieldSave = '/singx/managesender/save'; //POST
  static final pathSenderCurrencyAus = "/singx/managesender/getsendercurrency"; //GET
  static final pathReceiverCurrencyAus = "/singx/manageReceiver/getReceiverCountries"; //GET
//Manage Receiver
  static final pathReceiverListAus =
      "/singx/manageReceiver/getReceiverAccDetails"; //Post
  static final pathReceiverCountryListAus =
      "/singx/manageReceiver/getReceiverCountries"; //Post
  static final getTransactionStatusData =
      "/singx/transactionStatement/getstageiddropdown"; //GET
  static final getIFSCData =
      "/singx/bankBranch/getIfscdetails"; //GET
  static final getSortCodeData =
      "/singx/bankBranch/getSortCodeDetails";
  static final getBankNameByID =
      "/singx/bank/getBankNameById";
  static final findByUSSSwiftCode ="/singx/bankBranch/findByUSSSwiftCode";
  static final findByHKBankBranch ="/singx/bankBranch/findByHKBankBranchCode";
  static final findByCADBankBranch ="/singx/bankBranch/findByCADBankBranchCode";

  static final getProfileDetails =
      "/singx/profilestepone/getdata?contactId="; //GET
  static final pathReceiverNationalityListAus = "/singx/country/getAllNationalities";//Post
  static final pathEuropeCountriesListAus = "/singx/manageReceiver/getAllEuroCountries";//Post
  static final pathAllCountriesListAus = "/singx/country/getAllCountries";//Post
  static final pathSwiftCountriesListAus = "/singx/country/getAllSwiftCountries";
  static final pathStateListAus = "/singx/manageReceiver/getStates";
  static final pathDeleteReceiver = "/singx/manageReceiver/deleteReceiverAccDetails";//Post
  static final pathSaveReceiverAccount = "/singx/manageReceiver/save";//Post
  static final pathReceiverDetailsByCountryID ="/singx/manageReceiver/getReceiverByCountryId";
  static final pathFindByRoutingNumber ="/singx/bankBranch/findByRoutingNumber";
//Fund Transfer
  static final pathBankDetailsAus = "/singx/bank/getbankdetails?countryId=10000011"; //GET
  static final pathRelationShipAus = "/singx/transaction/getrelationshipdropdown"; //GET
  static final pathTransferPurposeAus = "/singx/transaction/getpurposeofintdropdown"; //GET
  static final pathVerifyPromo = "/singx/promoCode/verifyPromo"; //POST
  static final pathGenerateOTP = "/singx/OTP/getReceiverOtp"; //POST
  static final pathVerifyOTP = "/singx/OTP/verifyOtp"; //POST
  static final pathTransactionSave = "/singx/transaction/save"; //POST
  static final pathValidateTransaction = "/singx/transaction/validatetransaction"; //POST
  static final pathInitiateTransferEmail = "/singx/mailNotification/initiateTransfer"; //POST
  static final pathCustomerRating = "/singx/customer/getrating"; //POST

//SG Wallet
  static final pathSGWalletBal = "/wallet/balance"; //GET
  static final pathSGWalletHistory = "/wallet/history"; //GET
  static final pathSGWalletFilter = "/wallet/filters"; //GET
  static final pathTopUpLimitCheck = "/wallet/check?amount="; //POST
  static final pathTopUpWallet = "/wallet/topup"; //POST
  static final pathWalletDebit = "/wallet/debit"; //POST

//SG BillPay
  static final pathSGBillCountryList = "/country/"; //GET
  static final pathSGBillCategoryList = "/bill_category/"; //GET
  static final pathSGBillOperatorList = "/operator/"; //GET
  static final pathSGBillOperatorByID = "/operator/"; //GET
  static final pathSGBillViewBill = "/viewbill/"; //POST
  static final pathSGPricing = "/pricing"; //POST
  static final pathSGBillSave = "/transaction/save"; //POST
  static final pathSGBillTransactionHistory = "/transaction/history?filter="; //GET
  static final pathSGTransactionFilterAPI = "/transaction/v1/filters"; //GET
  static final pathSGBankDetails = "/transaction/v1/getSingxAccountDetails"; //GET
  static final pathSGBillFilter = "/transaction/filters"; //GET

//Dropdown
  static final pathSatlutation = "registrationapi/salutation?country="; //GET
  static final pathAnnualIncome = "registrationapi/annualincome?country="; //GET
  static final pathOccupation = "registrationapi/occupation?country="; //GET
  static final pathNationality = "registrationapi/nationality?country="; //GET
  static final pathIndustry = "registrationapi/industry?country="; //GET
  static final pathRegistrationPurpose = "registrationapi/purposeRegistration?country="; //GET
  static final pathCorridorOfInterest = "registrationapi/corridorofinterest?country="; //GET
  static final pathEducationQualification = "registrationapi/educationqualification?country="; //GET
  static final pathEstimatedTransactionAmount = "registrationapi/estimatedTransactionamount?country="; //GET
  static final pathState = "registrationapi/state?country="; //GET
  static final pathRegion = "registrationapi/region?country="; //GET
  static final pathResidenceStatus = "registrationapi/residencetype?country="; //GET
  static final pathGender = "registrationapi/gender?country="; //GET


/////Jumio
  static final jumioAuthToken = "https://auth.apac-1.jumio.ai/oauth2/token";
  static final jumioAccountCreationApi = "https://account.apac-1.jumio.ai/api/v1/accounts";
  static final jumioCallbackUpdated ="/verification/jumio/init";
}
