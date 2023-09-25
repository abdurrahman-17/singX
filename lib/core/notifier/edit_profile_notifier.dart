import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/australia/auth_repository_aus.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/data/remote/service/dropdown_repository.dart';
import 'package:singx/core/models/request_response/australia/customer_status/customer_status_response.dart';
import 'package:singx/core/models/request_response/australia/personal_details/CustomerDetailsResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/DropdownValueResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/search_address_response.dart';
import 'package:singx/core/models/request_response/document/document_list_response.dart';
import 'package:singx/core/models/request_response/dropdown/dropdown_response.dart';
import 'package:singx/core/models/request_response/dropdown/gender_dropdown_response.dart';
import 'package:singx/core/models/request_response/edit_profile/edit_profile_response.dart';
import 'package:singx/core/models/request_response/edit_profile/individual_details.dart';
import 'package:singx/core/models/request_response/get_profile_values/get_profile_value_response.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_request.dart';
import 'package:singx/core/models/request_response/register/get_address_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class EditProfileNotifier extends BaseChangeNotifier {
  EditProfileNotifier(BuildContext context) {
    contactRepository = ContactRepository();
    loadInitialData(context);
  }

  //String Data
  String? _selectedNationality;
  String? _selectedCountry;
  String _firstName = "";
  String _lastName = "";
  String _nationality = "";
  String _residenseCountry = "";
  String _emailAddress = "";
  String _mobileNumber = "";
  String _address = "";
  String _employer = "";
  String _occupation = "";
  String _licenseNumber = "";
  String _passportNumber = "";
  String _dateOfExpiryLicence = "";
  String _dateOfExpiryMedicare = "";
  String _dateOfExpiryPassport = "";
  String _selectedIssuingAuthority = "";
  String _documentErrorMessage = "";
  String _authStatus = "";
  String residenseCountryData = "";
  String removeResidenseCountryData = "";
  String _selectedSalutation = "";
  String _selectedEstimatedIncome = "";
  String _selectedOccupation = "";
  String _selectedResidence = "";
  String _medicareCardNumber = "";
  String _medicareCardType = "";
  String _medicareIndividualReferenceNumber = "";
  String? _countryData="";

  //Integer Values
  int _selectedRadioTile=0;

  //List of data
  List<DropdownResponseResidence> _residenceTypeData = [];
  List<String> _nationalityDatas = [];
  List<String> _occupationDatas = [];
  List<String> _estimatedAnnualIncome = [];
  List<DocumentListResponse> _documentListData = [];
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
  List<String> _salutation = [];

  //Global key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Data Controller
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController flatAndFloorNoController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController unitNoController = TextEditingController();
  TextEditingController blockNoController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController streetNumberController = TextEditingController();
  TextEditingController buildingNameController = TextEditingController();
  TextEditingController suburbController = TextEditingController();
  TextEditingController employerNameController = TextEditingController();
  TextEditingController enterPromoCodeController = TextEditingController();
  TextEditingController noController = TextEditingController();
  TextEditingController buildingNameJohorController = TextEditingController();
  TextEditingController postalCodeJohorController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController searchAddressController = TextEditingController();
  TextEditingController buildingNumberControlller = TextEditingController();
  TextEditingController nameOfVillageController = TextEditingController();
  TextEditingController occupationOthersController = TextEditingController();
  TextEditingController salutationController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController estimatedIncomeController = TextEditingController();
  TextEditingController stateAndProvinceController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController regionController = TextEditingController();

  //Repository
  ContactRepository? contactRepository;

  //Boolean Values
  bool _showLoadingIndicator = false;
  bool _isDigitalKyc = false;
  bool isError = false;
  bool _isManualSearch = false;
  bool _isUserNotVerified = false;
  bool _editNavigation = false;
  bool _isJohorAddress = false;


  //Base64
  Uint8List? _dataPNGType;


  //Getter and Setter
  List<DropdownResponseResidence> get residenceTypeData => _residenceTypeData;

  set residenceTypeData(List<DropdownResponseResidence> value) {
    _residenceTypeData = value;
  }

  bool get isDigitalKyc => _isDigitalKyc;

  set isDigitalKyc(bool value) {
    if(value == _isDigitalKyc)return;
    _isDigitalKyc = value;
    notifyListeners();
  }

  Uint8List get dataPNGType => _dataPNGType!;

  set dataPNGType(Uint8List value) {
    if (_dataPNGType == value) return;
    _dataPNGType = value;
    notifyListeners();
  }

  bool get showLoadingIndicator => _showLoadingIndicator;

  set showLoadingIndicator(bool value) {
    _showLoadingIndicator = value;
    notifyListeners();
  }

  String get authStatus => _authStatus;

  set authStatus(String value) {
    if(value == _authStatus)return;
    _authStatus = value;
    notifyListeners();
  }

  String get documentErrorMessage => _documentErrorMessage;

  set documentErrorMessage(String value) {
    if (_documentErrorMessage == value) return;
    _documentErrorMessage = value;
    notifyListeners();
  }

  List<String> get salutation => _salutation;

  set salutation(List<String> value) {
    _salutation = value;
  }

  List<String> get genderListData => _genderListData;

  set genderListData(List<String> value) {
    if (_genderListData == value) return;
    _genderListData = value;
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

  List<DocumentListResponse> get documentListData => _documentListData;

  set documentListData(List<DocumentListResponse> value) {
    if (_documentListData == value) return;
    _documentListData = value;
    return;
  }

  List<String> get medicareColor => _medicareColor;

  set medicareColor(List<String> value) {
    if (_medicareColor == value) return;
    _medicareColor = value;
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

  String _postCodeMessage = '';

  String get postCodeMessage => _postCodeMessage;

  set postCodeMessage(String value) {
    if (value == _postCodeMessage) return;
    _postCodeMessage = value;
    notifyListeners();
  }

  String get selectedEstimatedIncome => _selectedEstimatedIncome;

  set selectedEstimatedIncome(String value) {
    if (value == _selectedEstimatedIncome) return;
    _selectedEstimatedIncome = value;
    notifyListeners();
  }

  String get selectedSalutation => _selectedSalutation;

  set selectedSalutation(String value) {
    if (value == _selectedSalutation) return;
    _selectedSalutation = value;
    notifyListeners();
  }

  List<SearchAddressResponse> _addressSuggestion = [];

  List<SearchAddressResponse> get addressSuggestion => _addressSuggestion;

  set addressSuggestion(List<SearchAddressResponse> value) {
    if (value == _addressSuggestion) return;
    _addressSuggestion = value;
    notifyListeners();
  }

  String get licenseNumber => _licenseNumber;

  set licenseNumber(String value) {
    _licenseNumber = value;
  }

  get selectedNationality => _selectedNationality;

  set selectedNationality(value) {
    if (value == _selectedNationality) {
      _selectedNationality = value;
      return;
    }
    _selectedNationality = value;
    notifyListeners();
  }

  get selectedCountry => _selectedCountry;

  set selectedCountry(value) {
    if (value == _selectedCountry) {
      _selectedCountry = value;
      return;
    }
    _selectedCountry = value;
    notifyListeners();
  }

  String get selectedResidence => _selectedResidence;

  set selectedResidence(String value) {
    if (value == _selectedResidence) return;
    _selectedResidence = value;
    notifyListeners();
  } //Error bool value

  bool get isUserNotVerified => _isUserNotVerified;

  set isUserNotVerified(bool value) {
    if (value == _isUserNotVerified) return;
    _isUserNotVerified = value;
    notifyListeners();
  } //Selected Country

  String get selectedOccupation => _selectedOccupation;

  set selectedOccupation(String value) {
    if (value == _selectedOccupation) {
      _selectedOccupation = value;
      return;
    }

    _selectedOccupation = value;
    notifyListeners();
  }

  bool get isManualSearch => _isManualSearch;

  set isManualSearch(bool value) {
    if (value == _isManualSearch) {
      _isManualSearch = value;
      return;
    }
    _isManualSearch = value;
    notifyListeners();
  }

  String get countryData => _countryData!;

  set countryData(String value) {
    if (value == _countryData) {
      _countryData = value;
      return;
    }
    _countryData = value;
    notifyListeners();
  }

  int get selectedRadioTile => _selectedRadioTile!;

  set selectedRadioTile(int value) {
    if (value == _selectedRadioTile) {
      return;
    }
    _selectedRadioTile = value;
    notifyListeners();
  }

  bool get editNavigation => _editNavigation;

  set editNavigation(bool value) {
    if (value == _editNavigation) {
      _editNavigation = value;
      return;
    }
    _editNavigation = value;
    notifyListeners();
  }

  List<String> get estimatedAnnualIncome => _estimatedAnnualIncome;

  set estimatedAnnualIncome(List<String> value) {
    if (value == _estimatedAnnualIncome) return;
    _estimatedAnnualIncome = value;
    notifyListeners();
  }

  bool get isJohorAddress => _isJohorAddress;

  set isJohorAddress(bool value) {
    if (value == _isJohorAddress) {
      _isJohorAddress = value;
      return;
    }
    _isJohorAddress = value;
    notifyListeners();
  }

  String get firstName => _firstName;

  set firstName(String value) {
    if (value == _firstName) return;
    _firstName = value;
    notifyListeners();
  }

  String get lastName => _lastName;

  set lastName(String value) {
    if (value == _lastName) return;
    _lastName = value;
    notifyListeners();
  }

  String get nationality => _nationality;

  set nationality(String value) {
    if (value == _nationality) return;
    _nationality = value;
    notifyListeners();
  }

  String get residenseCountry => _residenseCountry;

  set residenseCountry(String value) {
    if (value == _residenseCountry) return;
    _residenseCountry = value;
    notifyListeners();
  }

  String get emailAddress => _emailAddress;

  set emailAddress(String value) {
    if (value == _emailAddress) return;
    _emailAddress = value;
    notifyListeners();
  }

  String get mobileNumber => _mobileNumber;

  set mobileNumber(String value) {
    if (value == _mobileNumber) return;
    _mobileNumber = value;
    notifyListeners();
  }

  String get address => _address;

  set address(String value) {
    if (value == _address) return;
    _address = value;
    notifyListeners();
  }

  String get employer => _employer;

  set employer(String value) {
    if (value == _employer) return;
    _employer = value;
    notifyListeners();
  }

  String get occupation => _occupation;

  set occupation(String value) {
    if (value == _occupation) return;
    _occupation = value;
    notifyListeners();
  }

  List<String> get nationalityDatas => _nationalityDatas;

  set nationalityDatas(List<String> value) {
    if (value == _residenceStatus) return;
    _nationalityDatas = value;
  }

  List<String> get occupationDatas => _occupationDatas;

  set occupationDatas(List<String> value) {
    if (value == _occupationDatas) return;
    _occupationDatas = value;
    notifyListeners();
  }

  String get passportNumber => _passportNumber;

  set passportNumber(String value) {
    if (value == _passportNumber) return;
    _passportNumber = value;
    notifyListeners();
  }

  String get dateOfExpiryLicence => _dateOfExpiryLicence;

  set dateOfExpiryLicence(String value) {
    if (value == _dateOfExpiryLicence) return;
    _dateOfExpiryLicence = value;
    notifyListeners();
  }

  String get dateOfExpiryMedicare => _dateOfExpiryMedicare;

  set dateOfExpiryMedicare(String value) {
    if (value == _dateOfExpiryMedicare) return;
    _dateOfExpiryMedicare = value;
    notifyListeners();
  }

  String get dateOfExpiryPassport => _dateOfExpiryPassport;

  set dateOfExpiryPassport(String value) {
    if (value == _dateOfExpiryPassport) return;
    _dateOfExpiryPassport = value;
    notifyListeners();
  }

  String get selectedIssuingAuthority => _selectedIssuingAuthority;

  set selectedIssuingAuthority(String value) {
    if (value == _selectedIssuingAuthority) return;
    _selectedIssuingAuthority = value;
    notifyListeners();
  }

  String get medicareCardNumber => _medicareCardNumber;

  set medicareCardNumber(String value) {
    if (value == _medicareCardNumber) return;
    _medicareCardNumber = value;
    notifyListeners();
  }

  String get medicareCardType => _medicareCardType;

  set medicareCardType(String value) {
    if (value == _medicareCardType) return;
    _medicareCardType = value;
    notifyListeners();
  }

  String get medicareIndividualReferenceNumber =>
      _medicareIndividualReferenceNumber;

  set medicareIndividualReferenceNumber(String value) {
    if (value == _medicareIndividualReferenceNumber) return;
    _medicareIndividualReferenceNumber = value;
    notifyListeners();
  }

  //API Initialization
  loadInitialData(context) async {
    countryData = await SharedPreferencesMobileWeb.instance.getCountry(country);
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
    if (countryData == AustraliaName) {
      EditProfileData(context);
    } else {
      editProfileApiData(context);
    }
  }

  editProfileApiData(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
      authDetailCheck(context);
      if (value == SingaporeName &&
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool ==
              false)
        ContactRepository().getPersonalDetailsSG(context).then((value) {
          showLoadingIndicator = false;
          PersonalDetailsRequestSg res = value as PersonalDetailsRequestSg;
          residenseCountry = res.residentStatus ?? '';
          selectedResidence = res.residentStatus ?? '';
          employer = res.employerName ?? '';
          employerNameController.text = res.employerName ?? '';
        });
      ContactRepository().getIndividualRegDetailSG(context).then((value) {
        IndividualRegDetail individualRegDetail = value as IndividualRegDetail;
        nationality = individualRegDetail.nationalityId ?? '';
        nationalityController.text = individualRegDetail.nationalityId ?? '';
        residenceController.text = individualRegDetail.residenceType!.name ?? '';
      });
      ContactRepository().apiEditProfile(context).then((value) {
        EditProfileResponse editProfileResponse =
        value as EditProfileResponse;
        firstName = editProfileResponse.firstName ?? "";
        firstNameController.text = editProfileResponse.firstName ?? "";
        middleNameController.text = editProfileResponse.middleName ?? "";
        lastName = editProfileResponse.lastName ?? "";
        lastNameController.text = editProfileResponse.lastName ?? "";
        address = editProfileResponse.unitNo != null && editProfileResponse.streetName != null ? (editProfileResponse.unitNo ??
            "") +
            ", " +
            (editProfileResponse.streetName ?? "") +
            ", " +
            (editProfileResponse.blockNo ?? "") +
            ", " +
            (editProfileResponse.buildingName ?? "") : '';
        isDigitalKyc = editProfileResponse.verificationType !=null ? true:false;
        salutationController.text = editProfileResponse.prefixId ?? "";
        emailAddress = editProfileResponse.emailId ?? "";
        emailController.text = editProfileResponse.emailId ?? "";
        mobileNumber = editProfileResponse.mobile ?? "";
        mobileNumberController.text = editProfileResponse.phoneNumber ?? "";
        employer = editProfileResponse.employerName ?? "";
        employerNameController.text = editProfileResponse.employerName ?? "";
        occupation = editProfileResponse.occupation ?? "";
        occupationController.text = editProfileResponse.occupation ?? "";
        selectedOccupation = editProfileResponse.occupation ?? "";
        occupationOthersController.text = editProfileResponse.otherOccupation ?? "";
        postalCodeController.text = editProfileResponse.postalCode ?? "";
        unitNoController.text = editProfileResponse.unitNo ?? "";
        blockNoController.text = editProfileResponse.blockNo ?? "";
        streetNameController.text = editProfileResponse.streetName ?? "";
        streetNumberController.text = editProfileResponse.blockNo ?? "";
        buildingNameController.text = editProfileResponse.blockNo ?? "";
        buildingNumberControlller.text = editProfileResponse.streetName ?? "";
        buildingNameJohorController.text = editProfileResponse.buildingName ?? "";
        suburbController.text = editProfileResponse.buildingName ?? '';
        postalCodeJohorController.text = editProfileResponse.postalCode ?? "";
        noController.text = editProfileResponse.unitNo ?? "";
        dobController.text = editProfileResponse.dateOfBirth ?? "";
        stateController.text = editProfileResponse.state ?? "";
        cityController.text = editProfileResponse.city ?? "";
        nameOfVillageController.text = editProfileResponse.buildingName ?? "";
        regionController.text = editProfileResponse.state ?? "";
        flatAndFloorNoController.text = editProfileResponse.unitNo ?? "";
        stateController.text.isNotEmpty?isJohorAddress = true:isJohorAddress = false;
      });
      if (Provider.of<CommonNotifier>(context, listen: false)
          .updateUserVerifiedBool ==
          false) {
        if (countryData == SingaporeName) {
          ContactRepository().apiDocumentListSg(context).then((value) {
            if (value.runtimeType == List<DocumentListResponse>) {
              List<DocumentListResponse> documentList =
              value as List<DocumentListResponse>;
              documentListData.addAll(documentList);
            } else {
              documentErrorMessage = value as String;
            }
          });
        } else {
          ContactRepository().apiDocumentListHk(context).then((value) {
            if (value.runtimeType == List<DocumentListResponse>) {
              List<DocumentListResponse> documentList =
              value as List<DocumentListResponse>;
              documentListData.addAll(documentList);
            } else {
              documentErrorMessage = value as String;
            }
          });
        }
      }
    });
    getAuthStatus(context);
  }

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
          } else if (status == AppConstants.status_hk_step2) {
            authStatus = AppConstants.status_hk_step2;
          } else if (status == AppConstants.status_hk_step3) {
            authStatus = AppConstants.status_hk_step3;
          } else if (status == AppConstants.status_hk_otp) {
            authStatus = AppConstants.status_hk_otp;
          } else if (status == AppConstants.status_application_complete) {
            authStatus = AppConstants.status_application_complete;
          } else if (status == AppConstants.status_onboarded) {
            authStatus = AppConstants.status_onboarded;
          }
        }else if (value == SingaporeName) {
          if (status == AppConstants.status_profile) {
            authStatus = AppConstants.status_profile;
          } else if (status == AppConstants.status_address) {
            authStatus = AppConstants.status_address;
          } else if (status == AppConstants.status_kyc) {
            authStatus = AppConstants.status_kyc;
          } else if (status == AppConstants.status_application_complete) {
            authStatus = AppConstants.status_application_complete;
          } else if (status == AppConstants.status_onboarded) {
            authStatus = AppConstants.status_onboarded;
          }
        }
      });
    });
    return status;
  }

  authDetailCheck(BuildContext context) {
    AuthRepository().apiAuthDetail(context).then((value) {
      String authDetailResponse = value as String;
      if (countryData == HongKongName) {
        if (authDetailResponse == AppConstants.status_profile) {
          isUserNotVerified = true;
        } else if (authDetailResponse == AppConstants.status_hk_step2) {
          isUserNotVerified = true;
        } else if (authDetailResponse == AppConstants.status_hk_step3) {
          isUserNotVerified = true;
        } else if (authDetailResponse == AppConstants.status_hk_otp) {
          isUserNotVerified = true;
        } else if (authDetailResponse ==
            AppConstants.status_application_complete) {
          isUserNotVerified = false;
        } else if (authDetailResponse == AppConstants.status_onboarded) {
          isUserNotVerified = false;
        }
      } else if (countryData == SingaporeName) {
        if (authDetailResponse == AppConstants.status_profile) {
          isUserNotVerified = true;
        } else if (authDetailResponse == AppConstants.status_address) {
          isUserNotVerified = true;
        } else if (authDetailResponse == AppConstants.status_kyc) {
          isUserNotVerified = true;
        } else if (authDetailResponse ==
            AppConstants.status_application_complete) {
          isUserNotVerified = false;
        } else if (authDetailResponse == AppConstants.status_onboarded) {
          isUserNotVerified = false;
        }
      }
    });
  }

  viewDocumentData(String documentId, BuildContext context) async {
    if (countryData == SingaporeName) {
      await ContactRepository()
          .apiViewDocument(documentId, context)
          .then((value) {
        Uint8List dataPNG = value as Uint8List;
        dataPNGType = dataPNG;
      });
    } else {
      await ContactRepository()
          .apiViewDocumentHk(documentId, context)
          .then((value) {
        Uint8List dataPNG = value as Uint8List;
        dataPNGType = dataPNG;
      });
    }
  }

  EditProfileData(BuildContext context) async {
    SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) {
      AuthRepository().apiCustomerStatus(value, context).then((value) {
        CustomerStatusResponse customerStatusResponse =
        value as CustomerStatusResponse;
        if (customerStatusResponse.statusId == 10000004 ||
            // customerStatusResponse.statusId == 10000005 ||
            customerStatusResponse.statusId == 10000012 ||
            customerStatusResponse.statusId == 10000013) {
          isUserNotVerified = true;
        } else {
          isUserNotVerified = false;
        }
      });
    });
    await AuthRepositoryAus().getDropdownValue(context).then((value) {
      DropdownValueResponse dropdownValueResponse = value;
      occupationDatas = dropdownValueResponse.occupation!;
      nationalityDatas = dropdownValueResponse.nationality!;
      residenceStatus = dropdownValueResponse.residenceType!;
      salutation = dropdownValueResponse.salutation!;
      estimatedAnnualIncome = dropdownValueResponse.estimatedTxnAmount!;
    });
    await ContactRepository().apiProfileDetails(context).then((value) async {
      GetProfileValues getProfileValues = value as GetProfileValues;
      await SharedPreferencesMobileWeb.instance
          .setUserName(userName, getProfileValues.firstName!);
      if((getProfileValues.addressLine2=="NA"||getProfileValues.addressLine2!.isEmpty) && (getProfileValues.addressLine3 =="NA" ||getProfileValues.addressLine3!.isEmpty)){
        isManualSearch=false;
      }else{
        isManualSearch=true;
      }
      if (getProfileValues.firstName!.isNotEmpty && getProfileValues.cra == true) {
        selectedRadioTile = 1;
      } else {
        selectedRadioTile = 2;
      }
      firstName = getProfileValues.firstName ?? '';
      lastName = getProfileValues.lastName ?? '';
      residenseCountry = getProfileValues.country ?? '';
      emailAddress = getProfileValues.email ?? '';
      mobileNumber = '${getProfileValues.countryCode ?? ''} ${getProfileValues.phoneNumber ?? ""}';
      address = getProfileValues.address ?? '';
      employer = getProfileValues.employerName ?? '';
      occupation = getProfileValues.occupation ?? '';
      occupationController.text = getProfileValues.occupation ?? '';
      selectedOccupation = getProfileValues.occupation ?? "";
      occupationOthersController.text = getProfileValues.otherOccupation ?? "";
      firstNameController.text = getProfileValues.firstName ?? '';
      middleNameController.text = getProfileValues.middleName ?? '';
      lastNameController.text = getProfileValues.lastName ?? '';
      dobController.text = getProfileValues.dateOfBirth ?? '';
      emailController.text = getProfileValues.email ?? '';
      nationality = getProfileValues.nationality ?? '';
      nationalityController.text = getProfileValues.nationality ?? '';
      residenceController.text = getProfileValues.residenceId ?? '';
      searchAddressController.text = getProfileValues.address ?? '';
      unitNoController.text = getProfileValues.addressLine1 ?? '';
      streetNumberController.text = getProfileValues.addressLine2?? '';
      streetNameController.text = getProfileValues.addressLine3?? '';
      suburbController.text = getProfileValues.addressLine4?? '';
      cityController.text = getProfileValues.addressLine5?? '';
      stateAndProvinceController.text = getProfileValues.state?? '';
      employerNameController.text = getProfileValues.employerName ?? '';
      salutationController.text = getProfileValues.tittle ?? '';
      postalCodeController.text = getProfileValues.postalCode ?? '';
      getProfileValues.otherOccupation == null
          ? null
          : occupationOthersController.text = getProfileValues.otherOccupation ?? '';
      estimatedIncomeController.text = getProfileValues.estimatedTxnamount ?? '';
      licenseNumber = getProfileValues
          .custOnboardDocBeans!.australianDrivingLicense!.referenceNumber ?? '';
      dateOfExpiryLicence = getProfileValues
          .custOnboardDocBeans!.australianDrivingLicense!.expiryDate ?? '';
      _selectedIssuingAuthority = getProfileValues
          .custOnboardDocBeans!.australianDrivingLicense!.issuingAuthority ?? '';
      _medicareCardNumber =
          getProfileValues.custOnboardDocBeans?.medicareCard?.referenceNumber ?? '';
      dateOfExpiryMedicare =
          getProfileValues.custOnboardDocBeans?.medicareCard?.expiryDate ?? '';
      medicareCardType =
          getProfileValues.custOnboardDocBeans?.medicareCard?.cardColour ?? '';
      medicareIndividualReferenceNumber =
          getProfileValues.custOnboardDocBeans?.medicareCard?.individualRefNo ?? '';
      passportNumber =
          getProfileValues.custOnboardDocBeans!.passport!.referenceNumber ?? '';
      dateOfExpiryPassport =
          getProfileValues.custOnboardDocBeans!.passport!.expiryDate! ?? '';
      referralCode = getProfileValues.promoCode! ?? '';
    });
  }

  getCustomerDetails(context) async {
    showLoadingIndicator = true;
    int? contactId =
    await SharedPreferencesMobileWeb.instance.getContactId(apiContactId);
    CustomerDetailsResponse? response =
    await contactRepository?.getCustomerDetails(context, "$contactId");
    if (response != null) {
      firstName = response.firstName ?? "---";
      lastName = response.lastName ?? "";
      nationality = response.nationality ?? "";

      residenseCountry = response.country ?? "---";
      emailAddress = "---";
      mobileNumber = response.phoneNumber ?? "";
      address = response.address ?? "";
      employer = response.employerName ?? "";
      occupation = response.occupation ?? "";
    }

    showLoadingIndicator = false;
  }

  getSGPostCodeAddress(String postCode) async {
    showLoadingIndicator = true;
    await AuthRepositoryAus().getSGPostCodeAddress(postCode).then((value) {
      showLoadingIndicator = false;
      GetAddressResponse response = value as GetAddressResponse;

      if(postalCodeController.text.isEmpty){
        postCodeMessage = "Enter Postal Code";
      }else if (response.status == 404) {
        postCodeMessage = "Invalid Postal Code";
      } else {
        postCodeMessage = "";
        blockNoController.text = response.bldgno ?? "";
        streetNameController.text = response.streetname ?? "";
        buildingNameController.text = response.bldgname ?? "";
      }
    });
  }

  getSuggestedAddress(String input) async {
    await AuthRepositoryAus()
        .fetchAddress(input, AppConstants.googlePlaceApi)
        .then((value) {
      addressSuggestion = value;
    });
  }

  //Dropdown Api
  apiSalutation(BuildContext context) {
    DropdownRepository().apiSalutaion(context).then((value) {
      DropdownResponse salutationResponse = value as DropdownResponse;
      salutationListData.addAll(salutationResponse.list!);
    });
  }

  apiAnnualIncome(BuildContext context) {
    DropdownRepository().apiAnnualIncome(context).then((value) {
      DropdownResponse annualIncomeResponse = value as DropdownResponse;
      annualIncomeListData.addAll(annualIncomeResponse.list!);
    });
  }

  apiOccupation(BuildContext context) {
    DropdownRepository().apiOccupation(context).then((value) {
      DropdownResponse occupationResponse = value as DropdownResponse;
      occupationListData.addAll(occupationResponse.list!);
    });
  }

  apiNationality(BuildContext context) {
    DropdownRepository().apiNationality(context).then((value) {
      DropdownResponse occupationResponse = value as DropdownResponse;
      nationalityListData.addAll(occupationResponse.list!);
    });
  }

  apiIndustry(BuildContext context) {
    DropdownRepository().apiIndustry(context).then((value) {
      DropdownResponse industryResponse = value as DropdownResponse;
      industryListData.addAll(industryResponse.list!);
    });
  }

  apiRegisterPurpose(BuildContext context) {
    DropdownRepository().apiRegistrationPurpose(context).then((value) {
      DropdownResponse registerPurposeResponse = value as DropdownResponse;
      registrationPurposeListData.addAll(registerPurposeResponse.list!);
    });
  }

  apiCorridorOfInterest(BuildContext context) {
    DropdownRepository().apiCorridorOfInterest(context).then((value) {
      DropdownResponse corridorOfInterestResponse = value as DropdownResponse;
      corridorOfInterestListData.addAll(corridorOfInterestResponse.list!);
    });
  }

  apiEducationQualification(BuildContext context) {
    DropdownRepository().apiEducationQualification(context).then((value) {
      DropdownResponse educationQualificationResponse =
          value as DropdownResponse;
      educationQualificationListData
          .addAll(educationQualificationResponse.list!);
    });
  }

  apiEstimatedTransactionAmount(BuildContext context) {
    DropdownRepository().apiEstimatedTransactionAmount(context).then((value) {
      DropdownResponse estimatedTransactionAmountResponse =
          value as DropdownResponse;
      estimatedTransactionAmountListData
          .addAll(estimatedTransactionAmountResponse.list!);
    });
  }

  apiState(BuildContext context) {
    DropdownRepository().apiState(context).then((value) {
      DropdownResponse stateResponse = value as DropdownResponse;
      stateListData.addAll(stateResponse.list!);
    });
  }

  apiRegion(BuildContext context) {
    DropdownRepository().apiRegion(context).then((value) {
      DropdownResponse regionResponse = value as DropdownResponse;
      regionListData.addAll(regionResponse.list!);
    });
  }

  apiResidenceStatus(BuildContext context) {
    DropdownRepository().apiResidenceStatus(context).then((value) {
      List<DropdownResponseResidence> res =
          value as List<DropdownResponseResidence>;
      residenceTypeData = res;
      res.forEach((element) {
        _residenceStatus.add(element.value!);
      });
    });
  }

  apiGender(BuildContext context) {
    DropdownRepository().apiGender(context).then((value) {
      List<GenderDropdownResponse> genderResponse =
          value as List<GenderDropdownResponse>;

      genderResponse.forEach((element) {
        genderListData.add(element.value!);
      });
    });
  }
}
