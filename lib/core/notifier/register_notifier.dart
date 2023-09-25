import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumio_mobile_sdk_flutter/jumio_mobile_sdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/australia/auth_repository_aus.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/data/remote/service/dropdown_repository.dart';
import 'package:singx/core/models/request_response/australia/personal_details/DropdownValueResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/SaveCustomerRequest.dart';
import 'package:singx/core/models/request_response/australia/personal_details/SaveCustomerResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/searchAddressDetailsResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/search_address_response.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/digi_verify_send_step_2/digi_verify_send_request_step_2.dart';
import 'package:singx/core/models/request_response/digital_verification_step_2_aus/digital_verification_step_2_aus_response.dart';
import 'package:singx/core/models/request_response/dropdown/dropdown_response.dart';
import 'package:singx/core/models/request_response/dropdown/gender_dropdown_response.dart';
import 'package:singx/core/models/request_response/edit_profile/edit_profile_response.dart';
import 'package:singx/core/models/request_response/get_profile_values/get_profile_value_response.dart';
import 'package:singx/core/models/request_response/hongkong/personal_details/SaveAdditionalDetailRequestHk.dart';
import 'package:singx/core/models/request_response/hongkong/personal_details/SaveCustomerRequestHk.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_request.dart';
import 'package:singx/core/models/request_response/register/get_address_response.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'common_notifier.dart';

class RegisterNotifier extends BaseChangeNotifier {

  //To Load Initial Data From API and Local Storage
  RegisterNotifier(context, {selected, fundCountValue, from,isOtp, referenceNumber}) {
    SharedPreferencesMobileWeb.instance.getScreenSize(screenWidth).then((value)=> screenSize=value);
    SharedPreferencesMobileWeb.instance.getIsManualVerification().then((value) {
      isRegistrationSelected = value;
    });
    occupationController.text = "";
    if (from == "View Profile") {
    } else {
      SharedPreferencesMobileWeb.instance
          .getMethodSelectedAUS('methodSelectedAUS')
          .then((value) async{
        await SharedPreferencesMobileWeb.instance.getScreenSize(screenWidth).then((value)=> screenSize=value);
        isMethodSelectedAus = value;
      });
      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {

        if(selected == 6 && value == SingaporeName) checkUploadJumioVerify(context, referenceNumber);


        await SharedPreferencesMobileWeb.instance.getScreenSize(screenWidth).then((value)=> screenSize=value);
        if (from == "PersonalDetailScreen") {
          await apiSalutation(context);
          await apiOccupation(context);
          await apiResidenceStatus(context);

          getPersonalDetailsSG(context);
        }

        if (value == AppConstants.singapore) {
          await SharedPreferencesMobileWeb.instance
              .getResidentStatus(AppConstants.residentStatusSata)
              .then((value) {
            residentStatus = value;
          });
        }

        if (value == HongKongName) {
          AutraliaAuthRepo = AuthRepositoryAus();
          if(from == AustraliaName){
            await apiSalutation(context);
            await apiAnnualIncome(context);
            await apiOccupation(context);
            await apiNationality(context);
            await apiIndustry(context);
            await apiRegisterPurpose(context);
            await apiCorridorOfInterest(context);
            await apiEducationQualification(context);
            await apiEstimatedTransactionAmount(context);
            await apiState(context);
            await apiRegion(context);
            await apiResidenceStatus(context);
            await apiGender(context);
          }
          if ("additional" == from) {
            if(isOtp) {
              ContactRepository().apiOtpGenerate().then((value) {
                CommonResponse res = value as CommonResponse;
                if(res.success == true) {
                  openPopUpDialog(context);
                  OTPErrorMessage = '';
                } else {
                  OTPErrorMessage = 'Unable to send OTP.';
                }
              });
            }
            await apiSalutation(context);
            await apiAnnualIncome(context);
            await apiOccupation(context);
            await apiNationality(context);
            await apiIndustry(context);
            await apiRegisterPurpose(context);
            await apiCorridorOfInterest(context);
            await apiEducationQualification(context);
            await apiEstimatedTransactionAmount(context);
            await apiState(context);
            await apiRegion(context);
            await apiResidenceStatus(context);
            await apiGender(context);
            getCustomerAdditionalDetailsHK(context);
          }
          await getCustomerDetailsHK(context);
        }
        await value == AppConstants.singapore ? _selected = selected : null;

        _isMethodSelected = Provider.of<CommonNotifier>(context, listen: false)
            .registerMethodScreen;
        _isPersonalDetail = Provider.of<CommonNotifier>(context, listen: false)
            .personalDetailScreen;
        _isVerificationFinished =
            Provider.of<CommonNotifier>(context, listen: false)
                .verificationScreen;
        _fundCount = fundCountValue;
        await SharedPreferencesMobileWeb.instance
            .getContactId(apiContactId)
            .then((valueContact) async {
          contactId = valueContact;
          if (from == AustraliaName && value != HongKongName) {
            AutraliaAuthRepo = AuthRepositoryAus();
            await apiSalutation(context);
            await apiAnnualIncome(context);
            await apiOccupation(context);
            await apiNationality(context);
            await apiIndustry(context);
            await apiRegisterPurpose(context);
            await apiCorridorOfInterest(context);
            await apiEducationQualification(context);
            await apiEstimatedTransactionAmount(context);
            await apiState(context);
            await apiRegion(context);
            await apiResidenceStatus(context);
            await apiGender(context);
            await loadInitialApi(context);
          }
          if(from == "digitalVerification") {
            await loadInitialApi(context);
            await apiGender(context);

          }
        });
      });
    }
  }

  ////Repository
  AuthRepositoryAus? AutraliaAuthRepo;

  //Global key
  final GlobalKey<FormState> personalDetailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> uploadAddressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> australianDrivingLicenceFormKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> passportFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> medicareFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> uploadMobileBillKey = GlobalKey<FormState>();

  //Data Controller
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final postalCodeController = TextEditingController();
  final unitNoController = TextEditingController();
  final blockNoController = TextEditingController();
  final streetNameController = TextEditingController();
  final buildingNameController = TextEditingController();
  final employerNameController = TextEditingController();
  final graduationYearController = TextEditingController();
  final enterPromoCodeController = TextEditingController();
  final noController = TextEditingController();
  final searchAddressController = TextEditingController();
  final buildingNameJohorController = TextEditingController();
  final postalCodeJohorController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final dobController = TextEditingController();
  final hkidDobController = TextEditingController();
  final finNumberController = TextEditingController();
  final finExpiryDateController = TextEditingController();
  final hkidNumberController = TextEditingController();
  final otpController = TextEditingController();
  final dobAustraliaController = TextEditingController();
  final nationalityController = TextEditingController();
  final buildingNumberControlller = TextEditingController();
  final nameOfVillageController = TextEditingController();
  final flatAndFloorNoController = TextEditingController();
  final selectCountryController = TextEditingController();
  final occupationOthersController = TextEditingController();

  //Australian Driver licence Controller
  final firstNameControllerADL = TextEditingController();
  final middleNameControllerADL = TextEditingController();
  final lastNameControllerADL = TextEditingController();
  final licenceNumberControllerADL = TextEditingController();
  final dateOfExpiryControllerADL = TextEditingController();
  final cardNumberControllerADL = TextEditingController();
  final issuingAuthorityControllerADL = TextEditingController();

  //Passport Controller
  final firstNameControllerPassport = TextEditingController();
  final middleNameControllerPassport = TextEditingController();
  final lastNameControllerPassport = TextEditingController();
  final dateOfExpiryControllerPassport = TextEditingController();
  final passportNumberControllerADL = TextEditingController();
  final GenderControllerADL = TextEditingController();

  //Medicare Controller
  final nameControllerMedicare = TextEditingController();
  final medicareNumberControllerMedicare = TextEditingController();
  final individualReferenceNumberControllerMedicare = TextEditingController();
  final dateOfExpiryControllerMedicare = TextEditingController();
  final cardColorControllerMedicare = TextEditingController();

  final salutationController = TextEditingController();
  final residenceStatusController = TextEditingController();
  final occupationController = TextEditingController();
  final annualIncomeController = TextEditingController();
  final stateAndProvinceController = TextEditingController();
  final regionController = TextEditingController();
  final industryValueController = TextEditingController();
  final educationQualificationController = TextEditingController();
  final genderController = TextEditingController();
  final estimatedAmountController = TextEditingController();
  final scrollController = ScrollController();

  // List Data
  List<String> _industryName = [];
  List<String> _medicareColor = [];
  List<String> _issuingAuthority = [];
  List<String> _salutationListData = [];
  List<String> _annualIncomeListData = [];
  List<String> _occupationListData = [];
  List<String> _nationalityListData = [];
  List<String> _industryListData = [];
  List<String> _registrationPurposeListData = [];
  List<String> _corridorOfInterestListData = [];
  List<String> _educationQualificationListData = [];
  List<String> _estimatedTransactionAmountListData = [];
  List<String> _stateListData = [];
  List<String> _regionListData = [];
  List<String> _genderListData = [];
  List<String> _residenceStatus = [];
  List<String> _corridorOfInterest = [];
  List<String> _purposeOfOpeningACValue = [];
  List<File_Data_Model>? fileAdditional = [];
  List<File_Data_Model>? _fileNonDigital1 = [];
  List<File_Data_Model>? _fileNonDigital2 = [];
  List<File> filesAdditionalMob = [];
  List<String> sizeAdditional = [];
  List<PlatformFile> platformFileAdditional = [];
  List<File> filesAdditionalMob1 = [];
  List<String> sizeAdditional1 = [];
  List<PlatformFile> platformFileAdditional1 = [];
  List<File> filesAdditionalMob2 = [];
  List<String> sizeAdditional2 = [];
  List<PlatformFile> platformFileAdditional2 = [];
  List<SearchAddressResponse> _addressSuggestion = [];
  List<String> _nationalityName = [];
  List _errorList = [];
  List<String> _salutation = [];
  List<String> _stateList = [];
  List<String> _nationality = [];
  List<String> _residenceType = [];
  List<String> _residenceTypeCitizen = [];
  List<String> _occupation = [];
  List<String> _annualIncome = [];
  List<CustomerDocument> _apiDigitalData = [];

  //String Data
  String? extrasize;
  String _selectedCountry = "";
  String? _selectedNationality;
  String? _selectedOccupation = "";
  String? _selectedRegion = "";
  String? _residentStatus;
  String? _industryValue;
  String? _educationValue;
  String? _stateOrProvinceValue;
  String? _selectedCardColor;
  String? _selectedGender;
  String _errorListStep2 = "";
  String _errorMessage = "";
  String? size;
  String? _selectedIssuingAuthority;
  String? _authStatus;
  String? _genderValue;
  String? _estimatedTransactionAmountValue;
  String? _annualIncomeValue;
  String? _salutationStr;
  String _nationalityStr = '';
  String? _residenceIdStr;
  String? _estimatedTxnAmountStr;
  String _countryStr = '';
  String _dobStr = '';
  String? _otpMessage = '';
  String _postCodeMessage = '';
  String _OTPErrorMessage = "";


  //Integer Data
  int? _selected = 0;
  int _selectedRadioTile = 1;
  int _radioValue = 0;
  int? _fundCount;
  int? _contactId;

  //Double Data
  double _progressValue = 0.0;
  double _extraprogressValue = 0.0;

  //boolean Data
  bool _showLoadingIndicator = false;
  bool _isRegistrationSelected = false;
  bool _purposeLOfOpening = false;
  bool _corridorOfInterestBool = false;
  bool _isError = false;
  bool _isJohorAddress = false;
  bool _isManualSearch = false;
  bool _isVerificationSelected = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isFileLoading = true;
  bool _isFileAdded = false;
  bool _isFileUploadedToServer = false;
  bool _isFileUploadedToServer2 = false;
  bool _isFileAddedVerification = false;
  bool _isCheckBoxValidated = false;
  bool _isTimer = false;
  bool _isFileLoadingAdditional = true;
  bool _isFileAddedAdditional = false;
  bool _isFileAddedAdditionalVerification = false;
  bool _isTimerAdditional = false;
  bool _isADLNotVerified = false;
  bool _isADLVerified = false;
  bool _isADLNotVerifiedRestricted = false;
  bool _isFieldAreEmpty = false;
  bool _isPassportNotVerified = false;
  bool _isPassportVerified = false;
  bool _isPassportNotVerifiedRestricted = false;
  bool _isMedicareNotVerified = false;
  bool _isMedicareVerified = false;
  bool _isMedicareNotVerifiedRestricted = false;
  bool _additionalDetailsIndustryValidation = false;
  bool _isVerificationRadioTile = false;
  bool _isVerificationADl = false;
  bool _additionalDetailsEducationValidation = false;
  bool _isADLOpen = false;
  bool _isPassportOpen = false;
  bool? _isMethodSelected;
  bool? _isPersonalDetail;
  bool? _isVerificationFinished;
  bool? isMethodSelectedAus;
  bool _isResidenceStatus = true;
  bool _medicareValidation = false;
  bool _drivingValidation = false;
  bool _passportValidation = false;

  //Date Time
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedDatePicker;


  //Custom data
  File_Data_Model? file;
  File? files;
  PlatformFile? platformFile;
  File_Data_Model? extraFile;
  File? extraFiles;
  PlatformFile? extraplatformFile;



  //Functions
  notifyListenersUpdate() {
    notifyListeners();
  }

  //To Store error response
  addErrorList(String value) {
    _errorList.clear();
    _errorList.add(value);
    notifyListeners();
  }

  //Calling API to get Initial Data
  loadInitialApi(context) async {
    await getDropdownValue(context);
    await ContactRepository().apiProfileDetails(context).then((value) {
      GetProfileValues getProfileValues = value as GetProfileValues;
      // if (getProfileValues.stepTwoAttempts! >= 2) {
      //   isADLNotVerified = true;
      // }
      if(getProfileValues.custOnboardDocBeans!.australianDrivingLicense != null) {
        firstNameControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.dlFName!;
        middleNameControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.dlMName!;
        lastNameControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.dlLName!;
        licenceNumberControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.referenceNumber!;
        dateOfExpiryControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.expiryDate!;
        selectedIssuingAuthority = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.issuingAuthority!;
        issuingAuthorityControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.issuingAuthority!;
        // cardNumberControllerADL.text = getProfileValues.custOnboardDocBeans!.australianDrivingLicense!.issuingAuthority!;
        if (getProfileValues.custOnboardDocBeans!.australianDrivingLicense!
            .isDocVerified == 0) {
          isADLNotVerified = true;
          if (getProfileValues.custOnboardDocBeans!.australianDrivingLicense!
              .isDocVerified == 0 && getProfileValues.stepTwoAttempts! >= 2) {
            isADLNotVerifiedRestricted = true;
          }
        }
      }
        if( getProfileValues.custOnboardDocBeans!.passport != null) {
          passportNumberControllerADL.text = getProfileValues.custOnboardDocBeans!.passport!.referenceNumber!;
          firstNameControllerPassport.text = getProfileValues.custOnboardDocBeans!.passport!.ppFName!;
          middleNameControllerPassport.text = getProfileValues.custOnboardDocBeans!.passport!.ppMName!;
          lastNameControllerPassport.text = getProfileValues.custOnboardDocBeans!.passport!.ppLName!;
          dateOfExpiryControllerPassport.text = getProfileValues.custOnboardDocBeans!.passport!.expiryDate!;
          selectedGender = getProfileValues.custOnboardDocBeans!.passport!.gender!;
          GenderControllerADL.text = getProfileValues.custOnboardDocBeans!.passport!.gender!;
          if (getProfileValues.custOnboardDocBeans!.passport!.isDocVerified ==
              0) {
            isPassportNotVerified = true;
            if (getProfileValues.custOnboardDocBeans!.passport!.isDocVerified ==
                0 && getProfileValues.stepTwoAttempts! >= 2) {
              isPassportNotVerifiedRestricted = true;
            }
          }
        }
        if(getProfileValues.custOnboardDocBeans!.medicareCard != null) {
          medicareNumberControllerMedicare.text = getProfileValues.custOnboardDocBeans!.medicareCard!.referenceNumber!;
          nameControllerMedicare.text = getProfileValues.custOnboardDocBeans!.medicareCard!.medicareCardName!;
          individualReferenceNumberControllerMedicare.text = getProfileValues.custOnboardDocBeans!.medicareCard!.individualRefNo!;
          selectedCardColor = getProfileValues.custOnboardDocBeans!.medicareCard!.cardColour!;
          cardColorControllerMedicare.text = getProfileValues.custOnboardDocBeans!.medicareCard!.cardColour!;
          dateOfExpiryControllerMedicare.text = getProfileValues.custOnboardDocBeans!.medicareCard!.expiryDate!;
          if (getProfileValues.custOnboardDocBeans!.medicareCard!
              .isDocVerified == 0) {
            isMedicareNotVerified = true;
            if (getProfileValues.custOnboardDocBeans!.medicareCard!
                .isDocVerified == 0 && getProfileValues.stepTwoAttempts! >= 2) {
              isMedicareNotVerifiedRestricted = true;
            }
          }
        }
      getProfileValues.errorList!.isNotEmpty
          ? errorListStep2 = getProfileValues.errorList!.first
          : null;
      selectedRadioTile = getProfileValues.firstName!.isEmpty?1:getProfileValues.cra == false ? 2 : 1;
      if((getProfileValues.addressLine2=="NA"||getProfileValues.addressLine2!.isEmpty) && (getProfileValues.addressLine3 =="NA" ||getProfileValues.addressLine3!.isEmpty)){
        isManualSearch=false;
      }else{
        isManualSearch=true;
      }
      salutationController.text = getProfileValues.tittle ?? "";
      dateOfExpiryControllerPassport.text = getProfileValues.custOnboardDocBeans?.passport?.expiryDate ?? '';
      firstNameController.text = getProfileValues.firstName ?? "";
      middleNameController.text = getProfileValues.middleName ?? "";
      lastNameController.text = getProfileValues.lastName ?? "";
      employerNameController.text = getProfileValues.employerName ?? "";
      annualIncomeController.text = getProfileValues.estimatedTxnamount == "null"?"": getProfileValues.estimatedTxnamount ?? "";
      dobController.text = getProfileValues.dateOfBirth ?? "";
      nationalityController.text = getProfileValues.nationality ?? "";
      residenceStatusController.text = getProfileValues.residenceId ?? "";
      residenceIdStr = getProfileValues.residenceId ?? "";
      searchAddressController.text = getProfileValues.address ?? "";
      occupationController.text = getProfileValues.occupation ?? "Others";
      selectedOccupation = getProfileValues.occupation ?? "Others";
      occupationOthersController.text = getProfileValues.otherOccupation ?? "";
      enterPromoCodeController.text = getProfileValues.promoCode ?? "";
      postalCodeController.text = getProfileValues.postalCode ?? "";
      stateAndProvinceController.text = getProfileValues.state ?? "";
      unitNoController.text = getProfileValues.addressLine1 ?? "";
      blockNoController.text = getProfileValues.addressLine2 ?? "";
      streetNameController.text = getProfileValues.addressLine3 ?? "";
      buildingNameController.text = getProfileValues.addressLine4 ?? "";
      cityController.text = getProfileValues.addressLine5 ?? "";
      if(firstNameControllerPassport.text.isEmpty) firstNameControllerPassport.text =  getProfileValues.firstName ?? '';
      if(firstNameControllerADL.text.isEmpty) firstNameControllerADL.text = getProfileValues.firstName ?? '';
      if(nameControllerMedicare.text.isEmpty) nameControllerMedicare.text = getProfileValues.firstName! +
          ' ' +
          getProfileValues.middleName! +
          ' ' +
          getProfileValues.lastName!;
      if(middleNameControllerPassport.text.isEmpty)middleNameControllerPassport.text = getProfileValues.middleName ?? '';
      if(middleNameControllerADL.text.isEmpty)middleNameControllerADL.text = getProfileValues.middleName ?? '';
      if(lastNameControllerPassport.text.isEmpty)lastNameControllerPassport.text = getProfileValues.lastName ?? '';
      if(lastNameControllerADL.text.isEmpty)lastNameControllerADL.text = getProfileValues.lastName ?? '';
    });
    await AuthRepository().apiDigitalVerificationGetData().then((value) {
      DigitalVerificationStepTwoResponseAus
      digitalVerificationStepTwoResponseAus =
      value as DigitalVerificationStepTwoResponseAus;
      medicareColor = digitalVerificationStepTwoResponseAus.cardType!;
      issuingAuthority = digitalVerificationStepTwoResponseAus.stateofIssue!;
    });
  }

  //Getting Dropdown Values from API
  getDropdownValue(context) async {
    showLoadingIndicator = true;
    DropdownValueResponse? response = DropdownValueResponse();
    response = await AutraliaAuthRepo?.getDropdownValue(context);

    annualIncome = response?.annaulIncome ?? [];
    occupation = response?.occupation ?? [];
    residenceType = response?.residenceType ?? [];
    residenceTypeCitizen = response?.residenceType ?? [];
    residenceTypeCitizen.remove('Citizen');
    nationality = response?.nationality ?? [];
    salutation = response?.salutation ?? [];
    stateList = response?.state ?? [];
    showLoadingIndicator = false;
  }

  //Upload Screen Checking Jumio Verification
  checkUploadJumioVerify(context, transactionReference) async {
    if (transactionReference!.length > 2) {

      await userCheck(context);
      apiLoader(context, from: "web");
      SharedPreferencesMobileWeb.instance.getJumioReference('jumioRefernce').then((value) async{

        Timer.periodic(Duration(seconds: 3), (timer) async{
          // Call your function here

          await ContactRepository()
              .jumioCallBack(value ?? "", context)
              .then((value) async {
            MyApp.navigatorKey.currentState!.maybePop();

            if (value == true) {
              timer.cancel();
              await RegisterNotifier(context).getAuthStatus(context, from: "web");
            }else if(timer.tick >= 10){
              timer.cancel();
              Provider.of<CommonNotifier>(context, listen: false)
                  .updateUserVerifiedBool = false;
              SharedPreferencesMobileWeb.instance.setUserVerified(false);
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            }
          });
        });
      });

    }
  }

  //To Save Customer Details In Backend
  saveCustomerDetails(context) async {
    SaveCustomerResponse? response = SaveCustomerResponse();
    String? country_ =
    await SharedPreferencesMobileWeb.instance.getCountry(country);
    String? country_code =
    await SharedPreferencesMobileWeb.instance.getCountry(countryCode);
    String? phone_number =
    await SharedPreferencesMobileWeb.instance.getCountry(phoneNumber);
    String address = isManualSearch == true
        ? "${unitNoController.text}, ${blockNoController.text}, ${streetNameController.text},${blockNoController.text},${cityController.text},${stateOrProvinceValue},${country_}"
        : searchAddressController.text;
    String addressLine1 =
    isManualSearch == true ? unitNoController.text : unitNoController.text;
    String addressLine2 =
    isManualSearch == true ? blockNoController.text : blockNoController.text;
    String addressLine3 = isManualSearch == true
        ? streetNameController.text
        : streetNameController.text;
    String addressLine4 =
    isManualSearch == true ? buildingNameController.text : buildingNameController.text;
    String addressLine5 = isManualSearch == true ? cityController.text : cityController.text;

    showLoadingIndicator = true;
    response = await AutraliaAuthRepo?.saveCustomerDetails(
        SaveCustomerRequest(
            tittle: "$salutationStr",
            firstName: firstNameController.text,
            middleName: middleNameController.text,
            lastName: lastNameController.text,
            dateOfBirth: dobController.text,
            nationality: "$selectedNationality",
            residenceId: "$residenceIdStr",
            occupation: "$selectedOccupation",
            otherOccupation: "${occupationOthersController.text}",
            employerName: employerNameController.text,
            estimatedTxnamount: "$estimatedTxnAmountStr",
            annualIncome: "",
            countryCode: "$country_code",
            phoneNumber: "$phone_number",
            address: address,
            addressLine1: addressLine1.isEmpty ? "NA" : addressLine1,
            addressLine2: addressLine2.isEmpty ? "NA" : addressLine2,
            addressLine3: addressLine3.isEmpty ? "NA" : addressLine3,
            addressLine4: addressLine4.isEmpty ? "NA" : addressLine4,
            addressLine5: addressLine5.isEmpty ? "NA" : addressLine5,
            country: "$country_",
            postalCode:
            isManualSearch == true ? postalCodeController.text : postalCodeController.text,
            cra: _selectedRadioTile == 1 ? true : false,
            promoCode: enterPromoCodeController.text,
            contactId: _contactId,
            state: "$stateOrProvinceValue"),
        context);
    if (response?.status == 200) {
      selectedRadioTile == 0
          ? isVerificationRadioTile = true
          : isVerificationRadioTile = false;
      if (selectedRadioTile == 1) {
        Provider.of<CommonNotifier>(context, listen: false)
            .updatePersonalDetailScreenData(true);
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, digitalVerificationAustralia);
        });

        SharedPreferencesMobileWeb.instance
            .setMethodSelectedAUS('methodSelectedAUS', true);
      } else if (selectedRadioTile == 2) {
        Provider.of<CommonNotifier>(context, listen: false)
            .updatePersonalDetailScreenData(true);
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, nonDigitalVerificationAustralia);
        });

        SharedPreferencesMobileWeb.instance
            .setMethodSelectedAUS('methodSelectedAUS', true);
      }
    }
    showLoadingIndicator = false;
  }

  //Get Customer Details For HK Flow From API
  getCustomerDetailsHK(context) async {
    showLoadingIndicator = true;
    await AutraliaAuthRepo?.getCustomerDetailsHK(context).then((value){
      SaveCustomerRequestHk?
      response = value as SaveCustomerRequestHk;
      if(response!=null)
      {
        salutationController.text = (response.salutation == null || response.salutation == " ") ? salutationController.text : response.salutation!;
        salutationStr = (response.salutation == null || response.salutation == " ") ? salutationStr : response.salutation!;
        firstNameController.text  = (response.firstName == null || response.firstName == " ") ? firstNameController.text : response.firstName!;
        middleNameController.text = (response.middleName == null || response.middleName == " ") ? middleNameController.text : response.middleName!;
        lastNameController.text = (response.lastName == null || response.lastName == " ") ? lastNameController.text : response.lastName!;
        dobController.text = (response.dateOfBirth == null || response.dateOfBirth == " ") ? dobController.text : response.dateOfBirth!;
        nationalityController.text = (response.nationality == null || response.nationality == " " || response.nationality == "87") ? nationalityController.text : response.nationality!;
        flatAndFloorNoController.text = (response.address == null || response.address == " ") ? flatAndFloorNoController.text : response.address!;
        searchAddressController.text = (response.address == null || response.address == " ") ? searchAddressController.text : response.address!;
        enterPromoCodeController.text= (response.promoCode == null || response.promoCode == " ") ? enterPromoCodeController.text : response.promoCode!;
        occupationController.text = (response.occupation == null || response.occupation == " ") ? occupationController.text : response.occupation!;
        occupationOthersController.text = (response.occupationOthers == null || response.occupationOthers == " ") ? occupationOthersController.text : response.occupationOthers!;
        streetNameController.text = (response.streetName == null || response.streetName == " ") ? streetNameController.text : response.streetName!;
        buildingNameController.text = (response.buildingName == null || response.buildingName == " ") ? buildingNameController.text : response.buildingName!;
        buildingNumberControlller.text = (response.streetName == null || response.streetName == " ") ? buildingNumberControlller.text : response.streetName!;
        nameOfVillageController.text = (response.district == null || response.district == " ") ? nameOfVillageController.text : response.district!;
        selectedNationality =  (response.nationality == null || response.nationality == " " || response.nationality == "87") ? nationalityController.text : response.nationality!;
        selectedOccupation =  (response.occupation == null || response.occupation == " ") ? selectedOccupation : response.occupation!;
        selectedRegion = (response.state == null || response.state == " ") ? selectedRegion : response.state!;
        regionController.text = (response.state == null || response.state == " ") ? regionController.text : response.state!;
        residenceIdStr= (response.residentStatus == null || response.residentStatus == " ") ? residenceIdStr : response.residentStatus!;
        residenceStatusController.text = (response.residentStatus == null || response.residentStatus == " ") ? residenceStatusController.text : response.residentStatus!;
        selectedRegion = (response.state == null || response.state == " ") ? selectedRegion : response.state!;
      }
    });
    showLoadingIndicator = false;
  }

  //Get Customer Details For SG Flow From API
  getPersonalDetailsSG(context) async {
    showLoadingIndicator = true;
    await ContactRepository().apiEditProfile(context).then((value) {
      EditProfileResponse editProfileResponse = value as EditProfileResponse;
      mobileNumberController.text = editProfileResponse.phoneNumber!;
      emailController.text = editProfileResponse.emailId!;
    });
    ContactRepository().getPersonalDetailsSG(context).then((value) {
      showLoadingIndicator = false;
      PersonalDetailsRequestSg res = value as PersonalDetailsRequestSg;
      if (res.firstName!.length >= 1 && res.firstName != " ") {
        firstNameController.text = res.firstName ?? "";
      }
      if (res.middleName!.length >= 1&& res.middleName != " ") {
        middleNameController.text = res.middleName ?? "";
      }

      if (res.lastName!.length >= 1&& res.lastName != " ") {
        lastNameController.text = res.lastName ?? "";
      }
      cityController.text = res.city ?? cityController.text;
      employerNameController.text =
          res.employerName ?? employerNameController.text;
      mobileNumberController.text =
          res.phoneNumber ?? mobileNumberController.text;
      enterPromoCodeController.text =
          res.promoCode ?? enterPromoCodeController.text;
      blockNoController.text = res.blockNo ?? blockNoController.text;
      buildingNameController.text =
          res.buildingName ?? buildingNameController.text;
      buildingNameJohorController.text =
          res.buildingName ?? buildingNameController.text;
      occupationOthersController.text =
          res.occupationOthers ?? occupationOthersController.text;
      postalCodeController.text = res.postalCode ?? postalCodeController.text;
      postalCodeJohorController.text = res.postalCode ?? postalCodeController.text;
      stateController.text = res.state ?? stateController.text;
      streetNameController.text = res.streetName ?? streetNameController.text;
      unitNoController.text = res.unitNo ?? unitNoController.text;
      noController.text = res.unitNo ?? unitNoController.text;
      residenceStatusController.text =
          res.residentStatus ?? residenceStatusController.text;
      residenceIdStr =
          res.residentStatus ?? residenceStatusController.text;
      residentStatus =
          res.residentStatus ?? residenceStatusController.text;
      selectedOccupation = res.occupation ?? selectedOccupation;
      occupationController.text = res.occupation ?? occupationController.text;
      stateController.text != "" ? isJohorAddress = true : isJohorAddress = false;
    });
  }

  //To Save Customer Details For HK FLow In Backend
  saveCustomerDetailsHK(context) async {
    showLoadingIndicator = true;

    await AutraliaAuthRepo?.saveCustomerDetailsHK(
        SaveCustomerRequestHk(
          salutation: "$salutationStr",
          firstName: firstNameController.text,
          middleName: middleNameController.text,
          lastName: lastNameController.text,
          dateOfBirth: dobController.text,
          nationality: "$selectedNationality",
          occupation: "${selectedOccupation}",
          address: flatAndFloorNoController.text,
          promoCode: enterPromoCodeController.text,
          residentStatus: residenceIdStr,
          occupationOthers: occupationOthersController.text,
          streetName: buildingNumberControlller.text.isEmpty?"NA":buildingNumberControlller.text,
          buildingName: buildingNameController.text.isEmpty?"NA":buildingNameController.text,
          district: nameOfVillageController.text.isEmpty?"NA":nameOfVillageController.text,
          state: selectedRegion,
          buildingNumber: buildingNumberControlller.text.isEmpty?"NA":buildingNumberControlller.text,
        ),
        context).then((value)async{

      CommonResponse?
      response = value as CommonResponse;
      if(response.success==true)
      {
        await getAuthStatus(context);
      }
      else
      {
        _errorList.add(response.error);
        notifyListeners();

      }
      if (response.success == true) {
        return;
      }
    });

    showLoadingIndicator = false;
  }

  //Get Additional Details Page Data From Backend
  getCustomerAdditionalDetailsHK(context) async {
    showLoadingIndicator = true;
    await AutraliaAuthRepo?.getCustomerAdditionalDetailsHK(context)
        .then((value) {
      showLoadingIndicator = false;
      SaveAdditionalDetailRequestHk? response =
      value as SaveAdditionalDetailRequestHk;
      industryValueController.text = response.industry ?? "";
      industryValue = response.industry ?? "";
      employerNameController.text = response.employerName ?? "";

      if (response.openingPurpose == null) {
      } else {
        var openingPurposeValue = response.openingPurpose!.split(',');
        purposeOfOpeningACValue = openingPurposeValue;
      }
      if (response.corridorInterest == null) {
      } else {
        var corridorInterestValue = response.corridorInterest!.split(',');
        corridorOfInterest = corridorInterestValue;
      }

      estimatedAmountController.text = response.estTransAmt ?? "";
      annualIncomeController.text = response.annualIncome ?? "";
      educationQualificationController.text = response.educationQualification ?? "";
      graduationYearController.text = response.yearOfGraduation ?? "";
      genderController.text = response.gender ?? "";
      genderValue = response.gender ?? "";
      estimatedTransactionAmountValue = response.estTransAmt ?? "";
      annualIncomeValue = response.annualIncome ?? "";
      educationValue = response.educationQualification ?? "";
    });
    showLoadingIndicator = false;
  }

  //Get Address Suggestion From API for Australia Automatic address Field
  getSuggestedAddress(String input) async {
    await AutraliaAuthRepo!.fetchAddress(
        input, AppConstants.googlePlaceApi)
        .then((value) {
      addressSuggestion = value;
    });
  }

  getAddressDetails(String input) async {
    await AutraliaAuthRepo!.getAddressDetails(input)
        .then((value) {
          SearchAddressDetailsResponse addressDetails = value as SearchAddressDetailsResponse;

          addressDetails.result!.addressComponents!.forEach((element) { 
            if(element.types!.contains("administrative_area_level_2")){
              cityController.text = element.shortName ?? "NA";
            }
            if(element.types!.contains("administrative_area_level_1")){
              stateOrProvinceValue = element.longName ?? "NA";
            }
            if(element.types!.contains("route")){
              streetNameController.text = element.shortName ?? "NA";
            }
            if(element.types!.contains("locality")){
              buildingNameController.text = element.shortName ?? "NA";
            }
            if(element.types!.contains("postal_code")){
              postalCodeController.text = element.shortName ?? "NA";
            }
            if(element.types!.contains("street_number")){
              blockNoController.text = element.shortName ?? "NA";
            }
          });
    });
  }
  //Get Address Via Postal Code From API for Singapore
  getSGPostCodeAddress(String postCode) async {
    showLoadingIndicator = true;
    await AuthRepositoryAus().getSGPostCodeAddress(postCode).then((value) {
      showLoadingIndicator = false;
      GetAddressResponse response = value as GetAddressResponse;

      if(postalCodeController.text.isEmpty){
        postCodeMessage = "Enter Postal Code";
      } else if (response.status == 404) {
        postCodeMessage = "Invalid Postal Code";
      } else {
        postCodeMessage = "";
        blockNoController.text = response.bldgno ?? blockNoController.text;
        streetNameController.text = response.streetname ?? streetNameController.text;
        buildingNameController.text = response.bldgname ?? buildingNameController.text;
      }
    });
  }

  //Get Step 2 Data From API
  getAddressVerificationDetailsHK(
      BuildContext context,
      ) async {
    await ContactRepository()
        .getAddressVerificationDetailsHK(context)
        .then((value) {
      if (value != null) {
        final result = json.decode(value.toString());
        String refNo = result["refNo"];
        String issueDate = result["issueDate"];

        hkidNumberController.text = refNo;
        hkidDobController.text = issueDate;
      }
    });
  }

  //E-Verification Or Selfie Based Verification Uploading Image Or Pdf File Via API
  FileUploadOnVerifySG(filePath, BuildContext context, String route) async {
    await ContactRepository()
        .apiSGFileUpload(filePath, context, "", "PROOF_OF_ADDRESS")
        .then((value) async {
      await ContactRepository()
          .apiAddressVerifySG(
          context, finNumberController.text, finExpiryDateController.text)
          .then((value) async {
        if (value == true) {
          await getAuthStatus(context);
        }
      });
    });
  }

  //Get Salutation List From API
  apiSalutation(BuildContext context) {
    DropdownRepository().apiSalutaion(context).then((value) {
      DropdownResponse salutationResponse = value as DropdownResponse;
      salutationListData.addAll(salutationResponse.list!);
    });
  }

  //Get AnnualIncome List From API
  apiAnnualIncome(BuildContext context) {
    DropdownRepository().apiAnnualIncome(context).then((value) {
      DropdownResponse annualIncomeResponse = value as DropdownResponse;
      annualIncomeListData.addAll(annualIncomeResponse.list!);
    });
  }

  //Get Occupation List From API
  apiOccupation(BuildContext context) async{
    DropdownRepository().apiOccupation(context).then((value) {
      DropdownResponse occupationResponse = value as DropdownResponse;
      occupationListData.addAll(occupationResponse.list!);
    });

    await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
      if(value == AustraliaName) {
        occupationController.text =  "Others";
        selectedOccupation =  "Others";
      }
    } );

  }

  //Get Nationality List From API
  apiNationality(BuildContext context) {
    DropdownRepository().apiNationality(context).then((value) {
      DropdownResponse occupationResponse = value as DropdownResponse;
      nationalityListData.addAll(occupationResponse.list!);
      nationalityListData.sort();
    });
  }

  //Get Industry List From API
  apiIndustry(BuildContext context) {
    DropdownRepository().apiIndustry(context).then((value) {
      DropdownResponse industryResponse = value as DropdownResponse;
      industryListData.addAll(industryResponse.list!);
    });
  }

  //Get Register Purpose List From API
  apiRegisterPurpose(BuildContext context) {
    DropdownRepository().apiRegistrationPurpose(context).then((value) {
      DropdownResponse registerPurposeResponse = value as DropdownResponse;
      registrationPurposeListData.addAll(registerPurposeResponse.list!);
    });
  }

  //Get Corridor Of Interest List From API
  apiCorridorOfInterest(BuildContext context) {
    DropdownRepository().apiCorridorOfInterest(context).then((value) {
      DropdownResponse corridorOfInterestResponse = value as DropdownResponse;
      corridorOfInterestListData.addAll(corridorOfInterestResponse.list!);
    });
  }

  //Get Education Qualification List From API
  apiEducationQualification(BuildContext context) {
    DropdownRepository().apiEducationQualification(context).then((value) {
      DropdownResponse educationQualificationResponse =
      value as DropdownResponse;
      educationQualificationListData
          .addAll(educationQualificationResponse.list!);
    });
  }

  //Get Estimated Transaction Amount List From API
  apiEstimatedTransactionAmount(BuildContext context) {
    DropdownRepository().apiEstimatedTransactionAmount(context).then((value) {
      DropdownResponse estimatedTransactionAmountResponse =
      value as DropdownResponse;
      estimatedTransactionAmountListData
          .addAll(estimatedTransactionAmountResponse.list!);
    });
  }

  //Get State List From API
  apiState(BuildContext context) {
    DropdownRepository().apiState(context).then((value) {
      DropdownResponse stateResponse = value as DropdownResponse;
      stateListData.addAll(stateResponse.list!);
    });
  }

  //Get Region List From API
  apiRegion(BuildContext context) {
    DropdownRepository().apiRegion(context).then((value) {
      DropdownResponse regionResponse = value as DropdownResponse;
      regionListData.addAll(regionResponse.list!);
    });
  }

  //Get User Current Position to check whether he is onboarded or not
  getAuthStatus(context, {from}) async {
    apiLoader(context, from: from);
    await AuthRepository().apiAuthDetail(context).then((value) {
      MyApp.navigatorKey.currentState!.maybePop();
      String status = value ?? "";
      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        if (value == HongKongName) {
          if (status == AppConstants.status_profile) {
            authStatus = AppConstants.status_profile;
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, personalDetailsAustraliaRoute);
            });
          } else if (status == AppConstants.status_hk_step2) {
            authStatus = AppConstants.status_hk_step2;
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(true);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, uploadHKIDProofRoute);
            });
            SharedPreferencesMobileWeb.instance
                .setMethodSelectedAUS('methodSelectedAUS', true);
          } else if (status == AppConstants.status_hk_step3) {
            authStatus = AppConstants.status_hk_step3;
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(true);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, additionalDetailsRoute);
            });
          } else if (status == AppConstants.status_hk_otp) {
            authStatus = AppConstants.status_hk_otp;
            Navigator.pushNamed(context, additionalDetailsRouteOtp);
          } else if (status == AppConstants.status_application_complete) {
            authStatus = AppConstants.status_application_complete;

            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_onboarded) {
            authStatus = AppConstants.status_onboarded;

            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = true;
            await SharedPreferencesMobileWeb.instance.setUserVerified(true);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          }
        } else if (value == SingaporeName) {
          if (status == AppConstants.status_profile) {
            Navigator.popAndPushNamed(context, personalDetailsRoute);
          } else if (status == AppConstants.status_address) {
            Navigator.pushNamed(context, addressVerifyRoute);
          } else if (status == AppConstants.status_kyc) {
            Navigator.pushNamed(context, verificationMethodRoute);
          } else if (status == AppConstants.status_application_complete) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
                  (route) => false,
            );
          } else if (status == AppConstants.status_onboarded) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = true;
            await SharedPreferencesMobileWeb.instance.setUserVerified(true);
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
                  (route) => false,
            );
          }
        }
      });
    });
    return status;
  }

  getVerifiedStatus(context) async {
    await AuthRepository().apiAuthDetail(context).then((value) {
      String status = value ?? "";

      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        if (value == HongKongName) {
          if (status == AppConstants.status_profile) {
            authStatus = AppConstants.status_profile;
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_hk_step2) {
            authStatus = AppConstants.status_hk_step2;
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_hk_step3) {
            authStatus = AppConstants.status_hk_step3;
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_hk_otp) {
            authStatus = AppConstants.status_hk_otp;
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_application_complete) {
            authStatus = AppConstants.status_application_complete;

            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_onboarded) {
            authStatus = AppConstants.status_onboarded;

            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = true;
            await SharedPreferencesMobileWeb.instance.setUserVerified(true);
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          }
        } else if (value == SingaporeName) {
          if (status == AppConstants.status_profile) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_address) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_kyc) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_application_complete) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            await SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_onboarded) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = true;
            await SharedPreferencesMobileWeb.instance.setUserVerified(true);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                    (route) => false,
              );
            });
          }
        }
      });
    });
    return status;
  }

  getAuthStatusProfile(context) async {
    await AuthRepository().apiAuthDetail(context).then((value) {
      String status = value ?? "";

      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        if (value == HongKongName) {
          if (status == AppConstants.status_profile) {
            authStatus = AppConstants.status_profile;
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, personalDetailsAustraliaRoute);
            });
          } else if (status == AppConstants.status_hk_step2) {
            authStatus = AppConstants.status_hk_step2;
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(true);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, uploadHKIDProofRoute);
            });
            SharedPreferencesMobileWeb.instance
                .setMethodSelectedAUS('methodSelectedAUS', true);
          } else if (status == AppConstants.status_hk_step3) {
            authStatus = AppConstants.status_hk_step3;
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(true);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, additionalDetailsRoute);
            });
          } else if (status == AppConstants.status_hk_otp) {
            authStatus = AppConstants.status_hk_otp;
            Navigator.pushNamed(context, additionalDetailsRouteOtp);
          } else if (status == AppConstants.status_application_complete) {
            authStatus = AppConstants.status_application_complete;

            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                editProfileRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_onboarded) {
            authStatus = AppConstants.status_onboarded;
            Provider.of<CommonNotifier>(context, listen: false)
                .updatePersonalDetailScreenData(false);
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(false);

            MyApp.navigatorKey.currentState!.maybePop();
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                editProfileRoute,
                    (route) => false,
              );
            });
          }
        } else if (value == SingaporeName) {
          if (status == AppConstants.status_profile) {
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.popAndPushNamed(context, personalDetailsRoute);
            });
          } else if (status == AppConstants.status_address) {
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, addressVerifyRoute);
            });
          } else if (status == AppConstants.status_kyc) {
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamed(context, verificationMethodRoute);
            });
          } else if (status == AppConstants.status_application_complete) {
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                editProfileRoute,
                    (route) => false,
              );
            });
          } else if (status == AppConstants.status_onboarded) {
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                editProfileRoute,
                    (route) => false,
              );
            });
          }
        }
      });
    });
    return status;
  }

  //Get Residence Status List From API
  apiResidenceStatus(BuildContext context) {
    DropdownRepository().apiResidenceStatus(context).then((value) {
      List<DropdownResponseResidence> res =
      value as List<DropdownResponseResidence>;
      res.forEach((element) {
        _residenceStatus.add(element.value!);
      });
    });
  }

  //Get Gender List From API
  apiGender(BuildContext context) {
    DropdownRepository().apiGender(context).then((value) {
      List<GenderDropdownResponse> genderResponse =
      value as List<GenderDropdownResponse>;

      genderResponse.forEach((element) {
        genderListData.add(element.value!);
      });
    });
  }

  //Calling Jumio for verification url
  callJumioApis(context, String transRef, url) async {
    await Jumio.init("$url", "SG");
    await Jumio.start({
      "loadingCircleIcon": "#000000",
      "loadingCirclePlain": "#000000",
      "loadingCircleGradientStart": "#000000",
      "loadingCircleGradientEnd": "#000000",
      "loadingErrorCircleGradientStart": "#000000",
      "loadingErrorCircleGradientEnd": "#000000",
      "primaryButtonBackground": {"light": "#FFC0CB", "dark": "#FF1493"}
    }).then((value) async {
      Map<dynamic, dynamic> result = value;
      Map<String, dynamic> data = Map<String, dynamic>();
      for (dynamic type in result.keys) {
        data[type.toString()] = result[type];
      }
      String? id = data['accountId'];
      if (id != null) {
        apiLoader(context);
        jumioCallBack(context, transRef, url);

      } else {
        await _showDialogWithMessage(
            "Jumio has completed. Result: $value", context);
      }
    }).onError((error, stackTrace) {});
  }

  //jumioCallBack
  jumioCallBack(context, String transRef, url)async{

    Timer.periodic(Duration(seconds: 3), (timer) async{
      // Call your function here
      await ContactRepository()
          .jumioCallBack("${transRef}", context)
          .then((value) async {
         MyApp.navigatorKey.currentState!.maybePop();
        if (value == true) {
          timer.cancel();
          await getAuthStatus(context);
        } else if (timer.tick >= 10){
          addErrorList("$value");
          timer.cancel();
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            dashBoardRoute,
                (route) => false,
          );// Stop the timer after 30 seconds
        }
      });
    });

  }

  //Show API Response with Pop-Up Dialog
  Future<void> _showDialogWithMessage(String message, context,
      [String title = "Result"]) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                MyApp.navigatorKey.currentState!.maybePop();
              },
            ),
          ],
        );
      },
    );
  }

  openPopUpDialog(BuildContext context3) {
    isError = false;
    return showDialog(
        barrierDismissible: false,
        builder: (BuildContext context1) {

          return BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: AppConstants.four, sigmaY: AppConstants.four),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: SizedBox(
                  width: AppConstants.fourHundredTwenty,
                  height: getScreenWidth(context) < 340
                      ? 340
                      : getScreenHeight(context) < 700
                      ? AppConstants.twoHundredSixty
                      : 310,
                  child: SingleChildScrollView(
                    controller:scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText(
                                text: S.of(context).otpVerification,
                                fontWeight: FontWeight.w700,
                                fontSize: getScreenWidth(context) < 340
                                    ? 14
                                    : AppConstants.twentyTwo),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: AppConstants.twenty,
                                color: oxfordBlueTint400,
                              ),
                              onPressed: () {
                                MyApp.navigatorKey.currentState!.maybePop();
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: getScreenHeight(context) * 0.02),
                        buildText(
                            text: S.of(context).enterTheOtpSendtoMobile,
                            fontSize: AppConstants.sixteen,
                            fontColor: oxfordBlueTint400),
                        SizedBox(height: getScreenHeight(context) * 0.04),
                        Form(
                          key: uploadAddressFormKey,
                          child: CommonTextField(
                              controller: otpController,
                              maxLength: 6,
                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                              validatorEmptyErrorText: otpIsRequired,
                              isOTPNumberValidator: true,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              onChanged: (val){
                                setState((){
                                  isError = false;
                                });
                              },
                              hintText: S.of(context).enterOtpHere,
                              hintStyle: hintStyle(context),
                              maxWidth: AppConstants.oneHundredAndSixty,
                              width: getScreenWidth(context),
                              maxHeight: 50,
                              suffixIcon: getScreenWidth(context) < 340
                                  ? null
                                  : isTimer == false
                                  ? Padding(
                                padding: px8DimenAll(context),
                                child: TweenAnimationBuilder<
                                    Duration>(
                                    duration: Duration(seconds: 120),
                                    tween: Tween(
                                        begin: Duration(seconds: 120),
                                        end: Duration.zero),
                                    onEnd: () {
                                      setState(() {
                                        isTimer =
                                        true;
                                      });
                                    },
                                    builder: (BuildContext context,
                                        Duration value,
                                        Widget? child) {
                                      final minutes = value.inMinutes;
                                      final seconds =
                                          value.inSeconds % 60;
                                      var sec = seconds < 10 ? 0 : '';
                                      return Padding(
                                        padding: px5DimenVerticale(
                                            context),
                                        child: buildText(
                                            text:
                                            '${S.of(context).resendIn} 0$minutes: $sec$seconds ',
                                            fontWeight: AppFont
                                                .fontWeightRegular,
                                            fontColor: black),
                                      );
                                    }),
                              )
                                  : TextButton(
                                onPressed: () {
                                  ContactRepository()
                                      .apiOtpGenerate();
                                  setState(() {
                                    isTimer = false;
                                  });
                                },
                                child: buildText(
                                    text: S.of(context).resendOtp,
                                    fontWeight:
                                    AppFont.fontWeightSemiBold,
                                    fontColor: orangePantone),
                              )),
                        ),
                        getScreenWidth(context) > 340
                            ? Text('')
                            : isTimer == false
                            ? Padding(
                          padding: px8DimenAll(context),
                          child: TweenAnimationBuilder<Duration>(
                              duration: Duration(seconds: 120),
                              tween: Tween(
                                  begin: Duration(seconds: 120),
                                  end: Duration.zero),
                              onEnd: () {
                                isTimer = true;
                              },
                              builder: (BuildContext context,
                                  Duration value, Widget? child) {
                                final minutes = value.inMinutes;
                                final seconds = value.inSeconds % 60;
                                var sec = seconds < 10 ? 0 : '';
                                return buildText(
                                    text:
                                    '${S.of(context).resendIn} 0$minutes: $sec$seconds ',
                                    fontWeight:
                                    AppFont.fontWeightRegular,
                                    fontColor: black);
                              }),
                        )
                            : TextButton(
                            onPressed: () {
                              ContactRepository().apiOtpGenerate();
                              isTimer = false;
                            },
                            child: buildText(
                                text: S.of(context).resendOtp,
                                fontWeight: AppFont.fontWeightSemiBold,
                                fontColor: orangePantone)),
                        isError == true
                            ? buildText(text: invalidOTP, fontColor: error)
                            : Text(''),
                        SizedBoxHeight(context,
                            getScreenWidth(context) > 380 ? 0.03 : 0.0),
                        buildButton(context, onPressed: () async {
                          if (uploadAddressFormKey.currentState!
                              .validate()) {
                            isError = false;
                            ContactRepository()
                                .apiOtpVerifyHK(
                                otpController.text,
                                context)
                                .then((value) async {
                              if (value! == false) {
                                setState(() {
                                  isError = true;
                                });
                              } else {
                                MyApp.navigatorKey.currentState!.maybePop();
                                setState(() {
                                  isError = false;
                                });
                                SharedPreferencesMobileWeb.instance
                                    .setMethodSelectedAUS('methodSelectedAUS',false);
                                await getAuthStatus(context3);
                              }
                            });
                          }
                        },
                            width: getScreenWidth(context),
                            height: AppConstants.fortyFive,
                            name: S.of(context).verify,
                            fontColor: white,
                            color: hanBlue),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
        context: context3);
  }


  //Getter And Setter
  bool get showLoadingIndicator => _showLoadingIndicator;

  set showLoadingIndicator(bool value) {
    if (value == _showLoadingIndicator) return;
    _showLoadingIndicator = value;
    notifyListeners();
  }

  DateTime? get selectedDatePicker => _selectedDatePicker;

  set selectedDatePicker(DateTime? value) {
    if (_selectedDatePicker == value) return;
    _selectedDatePicker = value;
    notifyListeners();
  }

  List<String> get genderListData => _genderListData;

  set genderListData(List<String> value) {
    if (_genderListData == value) return;
    _genderListData = value;
    notifyListeners();
  }
  double _screenSize=0;

  get screenSize => _screenSize;

  set screenSize(value) {
    if(value == _screenSize)return;
    _screenSize = value;
    notifyListeners();
  }
  List<String> get residenceStatus => _residenceStatus;

  set residenceStatus(List<String> value) {
    if (_residenceStatus == value) return;
    _residenceStatus = value;
    notifyListeners();
  }

  List<String> get regionListData => _regionListData;

  set regionListData(List<String> value) {
    if (_regionListData == value) return;
    _regionListData = value;
    notifyListeners();
  }

  List<String> get stateListData => _stateListData;

  set stateListData(List<String> value) {
    if (_stateListData == value) return;
    _stateListData = value;
    notifyListeners();
  }

  List<String> get estimatedTransactionAmountListData =>
      _estimatedTransactionAmountListData;

  set estimatedTransactionAmountListData(List<String> value) {
    if (_estimatedTransactionAmountListData == value) return;
    _estimatedTransactionAmountListData = value;
    notifyListeners();
  }

  List<String> get educationQualificationListData =>
      _educationQualificationListData;

  set educationQualificationListData(List<String> value) {
    if (_educationQualificationListData == value) return;
    _educationQualificationListData = value;
    notifyListeners();
  }

  List<String> get corridorOfInterestListData => _corridorOfInterestListData;

  set corridorOfInterestListData(List<String> value) {
    if (_corridorOfInterestListData == value) return;
    _corridorOfInterestListData = value;
    notifyListeners();
  }

  List<String> get registrationPurposeListData => _registrationPurposeListData;

  set registrationPurposeListData(List<String> value) {
    if (_registrationPurposeListData == value) return;
    _registrationPurposeListData = value;
    notifyListeners();
  }

  List<String> get industryListData => _industryListData;

  set industryListData(List<String> value) {
    if (_industryListData == value) return;
    _industryListData = value;
    notifyListeners();
  }

  List<String> get nationalityListData => _nationalityListData;

  set nationalityListData(List<String> value) {
    if (_nationalityListData == value) return;
    _nationalityListData = value;
    notifyListeners();
  }

  List<String> get occupationListData => _occupationListData;

  set occupationListData(List<String> value) {
    if (_occupationListData == value) return;
    _occupationListData = value;
    notifyListeners();
  }

  List<String> get annualIncomeListData => _annualIncomeListData;

  set annualIncomeListData(List<String> value) {
    if (_annualIncomeListData == value) return;
    _annualIncomeListData = value;
    notifyListeners();
  }

  List<String> get salutationListData => _salutationListData;

  set salutationListData(List<String> value) {
    if (_salutationListData == value) return;
    _salutationListData = value;
    notifyListeners();
  }

  List<String> get issuingAuthority => _issuingAuthority;

  set issuingAuthority(List<String> value) {
    if (_issuingAuthority == value) return;
    _issuingAuthority = value;
    notifyListeners();
  }

  List<SearchAddressResponse> get addressSuggestion => _addressSuggestion;

  set addressSuggestion(List<SearchAddressResponse> value) {
    if (value == _addressSuggestion) return;
    _addressSuggestion = value;
    notifyListeners();
  }

  List<String> get medicareColor => _medicareColor;

  set medicareColor(List<String> value) {
    if (_medicareColor == value) return;
    _medicareColor = value;
    notifyListeners();
  }



  List<String> get nationalityName => _nationalityName;

  set nationalityName(List<String> value) {
    if (_nationalityName == value) {
      return;
    }
    _nationalityName = value;
    notifyListeners();
  }

  List<String> get industryName => _industryName;

  set industryName(List<String> value) {
    if (_industryName == value) {
      return;
    }
    _industryName = value;
    notifyListeners();
  }



  List get errorList => _errorList;

  set errorList(List value) {
    if (value == _errorList) return;
    _errorList = value;
    notifyListeners();
  }



  bool get corridorOfInterestBool => _corridorOfInterestBool;

  set corridorOfInterestBool(bool value) {
    if(value == _corridorOfInterestBool)return;
    _corridorOfInterestBool = value;
    notifyListeners();
  }

  bool get purposeLOfOpening => _purposeLOfOpening;

  set purposeLOfOpening(bool value) {
    if(value == _purposeLOfOpening)return;
    _purposeLOfOpening = value;
    notifyListeners();
  }



  bool get isFileUploadedToServer => _isFileUploadedToServer;

  set isFileUploadedToServer(bool value) {
    if (value == _isFileUploadedToServer) return;
    _isFileUploadedToServer = value;
    notifyListeners();
  }

  bool get isFileUploadedToServer2 => _isFileUploadedToServer2;

  set isFileUploadedToServer2(bool value) {
    if (value == _isFileUploadedToServer2) return;
    _isFileUploadedToServer2 = value;
    notifyListeners();
  }

  bool get isCheckBoxValidated => _isCheckBoxValidated;

  set isCheckBoxValidated(bool value) {
    if (value == _isCheckBoxValidated) return;
    _isCheckBoxValidated = value;
    notifyListeners();
  }

  bool get isADLOpen => _isADLOpen;

  set isADLOpen(bool value) {
    if(value == _isADLOpen)return;
    _isADLOpen = value;
    notifyListeners();
  }


  String? get residentStatus => _residentStatus;

  set residentStatus(String? value) {
    if (residentStatus == value) return;
    _residentStatus = value;
    notifyListeners();
  }


  get fileNonDigital1 => _fileNonDigital1;

  set fileNonDigital1(value) {
    if (_fileNonDigital1 == value) return;

    _fileNonDigital1?.add(value);
    notifyListeners();
  }

  get fileNonDigital2 => _fileNonDigital2;

  set fileNonDigital2(value) {
    if (_fileNonDigital2 == value) return;
    _fileNonDigital2?.add(value);
    notifyListeners();
  }


  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    if (_errorMessage == value) return;
    _errorMessage = value;
    notifyListeners();
  }



  String get errorListStep2 => _errorListStep2;

  set errorListStep2(String value) {
    if (_errorListStep2 == value) return;
    _errorListStep2 = value;
    notifyListeners();
  }

  int get contactId => _contactId!;

  set contactId(int value) {
    if (_contactId == value) return;
    _contactId = value;
    notifyListeners();
  }

  double get extraprogressValue => _extraprogressValue;

  set extraprogressValue(double value) {
    // if (_extraprogressValue == value) {
    //   return;
    // }
    _extraprogressValue = value;
    notifyListeners();
  }

  double get progressValue => _progressValue;

  set progressValue(double value) {
    // if (_progressValue == value) {
    //   return;
    // }

    _progressValue = value;
    notifyListeners();
  }

  int get fundCount => _fundCount!;

  set fundCount(int value) {
    if (_fundCount == value) {
      return;
    }
    _fundCount = value;
    notifyListeners();
  }

  bool get isVerificationADl => _isVerificationADl;

  set isVerificationADl(bool value) {
    if (_isVerificationADl == value) {
      return;
    }
    _isVerificationADl = value;
    notifyListeners();
  }

  bool get additionalDetailsIndustryValidation =>
      _additionalDetailsIndustryValidation;

  set additionalDetailsIndustryValidation(bool value) {
    if (_additionalDetailsIndustryValidation == value) {
      return;
    }
    _additionalDetailsIndustryValidation = value;
    notifyListeners();
  }

  get isVerificationRadioTile => _isVerificationRadioTile;

  set isVerificationRadioTile(value) {
    if (_isVerificationRadioTile == value) {
      return;
    }
    _isVerificationRadioTile = value;
    notifyListeners();
  }

  get selectedCardColor => _selectedCardColor;

  set selectedCardColor(value) {
    if (selectedCardColor == value) {
      return;
    }
    _selectedCardColor = value;
    notifyListeners();
  }

  set platformFileAdditionalAdd(value) {
    if (platformFileAdditional == value) {
      return;
    }
    platformFileAdditional.add(value);
    notifyListeners();
  }

  get platformFileAdditionalAdd => platformFileAdditional;

  set sizeAdditionalAdd(value) {
    if (sizeAdditionalAdd == value) {
      return;
    }
    sizeAdditional.add(value);
    notifyListeners();
  }

  get sizeAdditionalAdd => sizeAdditional;

  set filesAdditionalMobAdd(value) {
    if (filesAdditionalMobAdd == value) {
      return;
    }
    filesAdditionalMob.add(value);
    notifyListeners();
  }

  get filesAdditionalMobAdd => filesAdditionalMob;

  set fileAdditionalFileAdditionalAdd(value) {
    if (fileAdditional == value) {
      return;
    }
    fileAdditional?.add(value);
    notifyListeners();
  }

  get fileAdditionalFileAdditionalAdd => fileAdditional;



  get educationValue => _educationValue;

  set educationValue(value) {
    if (_educationValue == value) {
      return;
    }
    _educationValue = value;
    notifyListeners();
  }



  get authStatus => _authStatus;

  set authStatus(value) {
    _authStatus = value;
    notifyListeners();
  }



  get genderValue => _genderValue;

  set genderValue(value) {
    if (_genderValue == value) {
      return;
    }
    _genderValue = value;
    notifyListeners();
  }



  get estimatedTransactionAmountValue => _estimatedTransactionAmountValue;

  set estimatedTransactionAmountValue(value) {
    if (_estimatedTransactionAmountValue == value) {
      return;
    }
    _estimatedTransactionAmountValue = value;
    notifyListeners();
  }



  get annualIncomeValue => _annualIncomeValue;

  set annualIncomeValue(value) {
    if (_annualIncomeValue == value) {
      return;
    }
    _annualIncomeValue = value;
    notifyListeners();
  }

  get stateOrProvinceValue => _stateOrProvinceValue;

  set stateOrProvinceValue(value) {
    if (_stateOrProvinceValue == value) {
      return;
    }
    _stateOrProvinceValue = value;
    notifyListeners();
  }

  bool get isMethodSelected => _isMethodSelected!;

  set isMethodSelected(bool value) {
    if (_isMethodSelected == value) {
      return;
    }
    _isMethodSelected = value;
    notifyListeners();
  }

  get isPersonalDetail => _isPersonalDetail;

  set isPersonalDetail(value) {
    if (_isPersonalDetail == value) {
      return;
    }
    _isPersonalDetail = value;
    notifyListeners();
  }


  List<String> get purposeOfOpeningACValue => _purposeOfOpeningACValue;

  set purposeOfOpeningACValue(List<String> value) {
    if(value == _purposeOfOpeningACValue)return;
    _purposeOfOpeningACValue = value;
    notifyListeners();
  }

  get industryValue => _industryValue;

  set industryValue(value) {
    if (_industryValue == value) {
      return;
    }
    _industryValue = value;
    notifyListeners();
  }

  List<String> get corridorOfInterest => _corridorOfInterest;

  set corridorOfInterest(List<String> value) {
    if (_corridorOfInterest == value) {
      return;
    }
    _corridorOfInterest = value;
    notifyListeners();
  }

  get isVerificationFinished => _isVerificationFinished;

  set isVerificationFinished(value) {
    if (_isVerificationFinished == value) {
      return;
    }
    _isVerificationFinished = value;
    notifyListeners();
  }

  bool get isResidenceStatus => _isResidenceStatus;

  set isResidenceStatus(bool value) {
    if (_isResidenceStatus == value) {
      return;
    }
    _isResidenceStatus = value;
    notifyListeners();
  }

  bool get medicareValidation => _medicareValidation;

  set medicareValidation(bool value) {
    if (_medicareValidation == value) {
      return;
    }
    _medicareValidation = value;
    notifyListeners();
  }

  bool get drivingValidation => _drivingValidation;

  set drivingValidation(bool value) {
    if (_drivingValidation == value) {
      return;
    }
    _drivingValidation = value;
    notifyListeners();
  }

  bool get passportValidation => _passportValidation;

  set passportValidation(bool value) {
    if (_passportValidation == value) {
      return;
    }
    _passportValidation = value;
    notifyListeners();
  }

  bool get isRegistrationSelected => _isRegistrationSelected;

  set isRegistrationSelected(bool value) {
    if (_isRegistrationSelected == value) {
      return;
    }
    _isRegistrationSelected = value;
    notifyListeners();
  }

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }

  bool get isJohorAddress => _isJohorAddress;

  set isJohorAddress(bool value) {
    if (_isJohorAddress == value) {
      return;
    }
    _isJohorAddress = value;
    notifyListeners();
  }

  bool get isManualSearch => _isManualSearch;

  set isManualSearch(bool value) {
    if (_isManualSearch == value) {
      return;
    }
    _isManualSearch = value;
    notifyListeners();
  }

  bool get isVerificationSelected => _isVerificationSelected;

  set isVerificationSelected(bool value) {
    if (_isVerificationSelected == value) {
      return;
    }
    _isVerificationSelected = value;
    notifyListeners();
  }

  bool get isChecked1 => _isChecked1;

  set isChecked1(bool value) {
    if (_isChecked1 == value) {
      return;
    }
    _isChecked1 = value;
    notifyListeners();
  }

  bool get isChecked2 => _isChecked2;

  set isChecked2(bool value) {
    if (_isChecked2 == value) {
      return;
    }
    _isChecked2 = value;
    notifyListeners();
  }

  bool get isChecked3 => _isChecked3;

  set isChecked3(bool value) {
    if (_isChecked3 == value) {
      return;
    }
    _isChecked3 = value;
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

  bool get isTimer => _isTimer;

  set isTimer(bool value) {
    if (_isTimer == value) {
      return;
    }
    _isTimer = value;
    notifyListeners();
  }

  bool get isFileLoadingAdditional => _isFileLoadingAdditional;

  set isFileLoadingAdditional(bool value) {
    if (_isFileLoadingAdditional == value) {
      return;
    }
    _isFileLoadingAdditional = value;
    notifyListeners();
  }

  bool get isFileAddedAdditional => _isFileAddedAdditional;

  set isFileAddedAdditional(bool value) {
    if (_isFileAddedAdditional == value) {
      return;
    }
    _isFileAddedAdditional = value;
    notifyListeners();
  }

  bool get isFileAddedAdditionalVerification =>
      _isFileAddedAdditionalVerification;

  set isFileAddedAdditionalVerification(bool value) {
    if (_isFileAddedAdditionalVerification == value) {
      return;
    }
    _isFileAddedAdditionalVerification = value;
    notifyListeners();
  }

  bool get isTimerAdditional => _isTimerAdditional;

  set isTimerAdditional(bool value) {
    if (_isTimerAdditional == value) {
      return;
    }
    _isTimerAdditional = value;
    notifyListeners();
  }

  bool get isADLNotVerified => _isADLNotVerified;

  set isADLNotVerified(bool value) {
    if (_isADLNotVerified == value) {
      return;
    }
    _isADLNotVerified = value;
    notifyListeners();
  }

  bool get isADLVerified => _isADLVerified;

  set isADLVerified(bool value) {
    if (_isADLVerified == value) {
      return;
    }
    _isADLVerified = value;
    notifyListeners();
  }

  bool get isFieldAreEmpty => _isFieldAreEmpty;

  set isFieldAreEmpty(bool value) {
    if (_isFieldAreEmpty == value) {
      return;
    }
    _isFieldAreEmpty = value;
    notifyListeners();
  }

  bool get isPassportNotVerified => _isPassportNotVerified;

  set isPassportNotVerified(bool value) {
    if (_isPassportNotVerified == value) {
      return;
    }
    _isPassportNotVerified = value;
    notifyListeners();
  }

  bool get isPassportVerified => _isPassportVerified;

  set isPassportVerified(bool value) {
    if (_isPassportVerified == value) {
      return;
    }
    _isPassportVerified = value;
    notifyListeners();
  }

  bool get isMedicareNotVerified => _isMedicareNotVerified;

  set isMedicareNotVerified(bool value) {
    if (_isMedicareNotVerified == value) {
      return;
    }
    _isMedicareNotVerified = value;
    notifyListeners();
  }

  bool get isMedicareVerified => _isMedicareVerified;

  set isMedicareVerified(bool value) {
    if (_isMedicareVerified == value) {
      return;
    }
    _isMedicareVerified = value;
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime value) {
    if (_selectedDate == value) {
      return;
    }
    _selectedDate = value;
    notifyListeners();
  }

  int? get selected => _selected!;

  set selected(int? value) {
    if (_selected == value) {
      return;
    }
    _selected = value;
    notifyListeners();
  }

  int get selectedRadioTile => _selectedRadioTile;

  set selectedRadioTile(int value) {
    if (_selectedRadioTile == value) {
      return;
    }
    _selectedRadioTile = value;
    notifyListeners();
  }

  int get radioValue => _radioValue;

  set radioValue(int value) {
    if (_radioValue == value) {
      return;
    }
    _radioValue = value;
    notifyListeners();
  }

  String get selectedCountry => _selectedCountry;

  set selectedCountry(String value) {
    if (_selectedCountry == value) {
      return;
    }
    _selectedCountry = value;
    notifyListeners();
  }

  get selectedNationality => _selectedNationality;

  set selectedNationality(value) {
    if (_selectedNationality == value) {
      return;
    }
    _selectedNationality = value;
    notifyListeners();
  }

  String? get selectedOccupation => _selectedOccupation;

  set selectedOccupation(String? value) {
    if (_selectedOccupation == value) {
      return;
    }
    _selectedOccupation = value;
    notifyListeners();
  }

  String? get selectedRegion => _selectedRegion;

  set selectedRegion(String? value) {
    if (_selectedRegion == value) {
      return;
    }
    _selectedRegion = value;
    notifyListeners();
  }

  bool get additionalDetailsEducationValidation =>
      _additionalDetailsEducationValidation;

  set additionalDetailsEducationValidation(bool value) {
    if (_additionalDetailsEducationValidation == value) {
      return;
    }
    _additionalDetailsEducationValidation = value;
    notifyListeners();
  }

  get selectedGender => _selectedGender;

  set selectedGender(value) {
    if (_selectedGender == value) {
      return;
    }
    _selectedGender = value;
    notifyListeners();
  }

  get selectedIssuingAuthority => _selectedIssuingAuthority;

  set selectedIssuingAuthority(value) {
    if (_selectedIssuingAuthority == value) {
      return;
    }
    _selectedIssuingAuthority = value;
    notifyListeners();
  }



  List<String> get salutation => _salutation;

  set salutation(List<String> value) {
    if (value == _salutation) return;
    _salutation = value;
    notifyListeners();
  }



  List<String> get stateList => _stateList;

  set stateList(List<String> value) {
    if (value == _stateList) return;
    _stateList = value;
    notifyListeners();
  }



  List<String> get nationality => _nationality;

  set nationality(List<String> value) {
    if (value == _nationality) return;
    _nationality = value;
    notifyListeners();
  }



  List<String> get residenceType => _residenceType;

  set residenceType(List<String> value) {
    if (value == _residenceType) return;
    _residenceType = value;
    notifyListeners();
  }

  List<String> get residenceTypeCitizen => _residenceTypeCitizen;

  set residenceTypeCitizen(List<String> value) {
    if (value == _residenceTypeCitizen) return;
    _residenceTypeCitizen = value;
    notifyListeners();
  }



  List<String> get occupation => _occupation;

  set occupation(List<String> value) {
    if (value == _occupation) return;
    _occupation = value;
    notifyListeners();
  }



  List<String> get annualIncome => _annualIncome;

  set annualIncome(List<String> value) {
    if (value == _annualIncome) return;
    _annualIncome = value;
    notifyListeners();
  }


  List<CustomerDocument> get apiDigitalData => _apiDigitalData;

  set apiDigitalData(List<CustomerDocument> value) {
    if (value == _apiDigitalData) return;
    _apiDigitalData = value;
    notifyListeners();
  }



  String? get salutationStr => _salutationStr;

  set salutationStr(String? value) {
    if (value == _salutationStr) return;
    _salutationStr = value;
    notifyListeners();
  }



  String get nationalityStr => _nationalityStr;

  set nationalityStr(String value) {
    if (value == _nationalityStr) return;
    _nationalityStr = value;
    notifyListeners();
  }



  String? get residenceIdStr => _residenceIdStr;

  set residenceIdStr(String? value) {
    if (value == _residenceIdStr) return;
    _residenceIdStr = value;
    notifyListeners();
  }



  String? get estimatedTxnAmountStr => _estimatedTxnAmountStr;

  set estimatedTxnAmountStr(String? value) {
    if (value == _estimatedTxnAmountStr) return;
    _estimatedTxnAmountStr = value;
    notifyListeners();
  }



  String get countryStr => _countryStr;

  set countryStr(String value) {
    if (value == _countryStr) return;
    _countryStr = value;
    notifyListeners();
  }



  String get dobStr => _dobStr;

  set dobStr(String value) {
    if (value == _dobStr) return;
    _dobStr = value;
    notifyListeners();
  }



  String get otpMessage => _otpMessage!;

  set otpMessage(String value) {
    if (value == _otpMessage) return;
    _otpMessage = value;
    notifyListeners();
  }



  String get postCodeMessage => _postCodeMessage;

  set postCodeMessage(String value) {
    if (value == _postCodeMessage) return;
    _postCodeMessage = value;
    notifyListeners();
  }

  bool get isPassportOpen => _isPassportOpen;

  set isPassportOpen(bool value) {
    if(value == _isPassportOpen)return;
    _isPassportOpen = value;
    notifyListeners();
  }

  bool get isPassportNotVerifiedRestricted => _isPassportNotVerifiedRestricted;

  set isPassportNotVerifiedRestricted(bool value) {
    if(value == _isPassportNotVerifiedRestricted) return;
    _isPassportNotVerifiedRestricted = value;
    notifyListeners();
  }

  bool get isMedicareNotVerifiedRestricted => _isMedicareNotVerifiedRestricted;

  set isMedicareNotVerifiedRestricted(bool value) {
    if(value == _isMedicareNotVerifiedRestricted) return;
    _isMedicareNotVerifiedRestricted = value;
    notifyListeners();
  }

  bool get isADLNotVerifiedRestricted => _isADLNotVerifiedRestricted;

  set isADLNotVerifiedRestricted(bool value) {
    if(value == _isADLNotVerifiedRestricted) return;
    _isADLNotVerifiedRestricted = value;
    notifyListeners();
  }



  String get OTPErrorMessage => _OTPErrorMessage;

  set OTPErrorMessage(String value) {
    if(value == _OTPErrorMessage) return;
    _OTPErrorMessage = value;
    notifyListeners();
  }
}
