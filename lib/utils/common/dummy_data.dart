//dropdown value

List<String> alertMeVia = ['Email', 'SMS', 'BOTH'];

//dropdown country number
String singapore = '+65';

//validation text
String enterValidMail = "Please enter a valid Email ID.";
String mobileRequired = 'Please enter valid mobile number.';
String enterValidNumber = 'Please enter valid mobile number.';
String postalCodeisRequired = 'Postal code is required';
String unitNumberIsRequired = "Unit Number is required";
String blockNumberIsrequired = "Block Number is required";
String streetNumberIsrequired = "Street Number is required";
String buildingNumberIsrequired = "Building Number is required";
String streetNameIsRequired = "Street name is required";
String buildingNameIsRequired = "Building Name is required";
String suburbIsRequired = "Suburb is required";
String employerNameIsRequired = "Employer name is required";
String employerNameInAdditionalDetails = "Employer Name cannot be blank.";
String otherOccupationIsRequired = "Other Occupation is required";
String houseLotNumberFloorIsRequired = "House /Lot Number/Floor is required";
String cityIsRequired = "City is required";
String fieldIsRequired = "field is required";
String enterCity = "Enter City";
String fINNRICnumberIsRequired = "FIN/NRIC number is required";
String hkidnumberIsRequired = "HKID number is required";
String fINNRICExpiryDateIsRequired = "FIN/NRIC expiry date is required";
String hkidExpiryDateIsRequiredPersonalDetails = "Issue date is required";
String dobIsRequired = "Date of Birth is required";
String otpIsRequired = "OTP is required";
String enterValidOTP = "Enter valid OTP";
String invalidOTP = "Invalid OTP";

//DummyData
String sgd = "SGD ";
String referralCode = "4214544WE5";
String receiverColan = "Receiver : ";
String transactionIDColan = "Transaction ID : ";
String dateColan = "Date : ";
String amountColan = "Amount : ";
String totalAmountPayable = "Total Amount Payable : ";
String status = "Status : ";
String selectedCategoryDummy = "Category";
String download = "Download";
String screenWidth = "screenSize";
String validityExpired = "Validity Expired";
String validityExpiredWallet = "Expired";
String initiated = "Transfer Initiated";
String initiatedWallet = "Initiated";
String getColan = "Get ";
String tenSingXWallet = "\$10 SingX Wallet";
String creditForEveryFriend = " credit for every friend you refer!";
String quote = '201533243WALL';
String profile = "PROFILE";
String kyc = "KYC";
String applicationComplete = "APPLICATION_COMPLETE";
String HKStep2 = "HK_STEP_2";
String HKStep3 = "HK_STEP_3";
String HK_OTP = "HK_OTP";
String completeYourRegistration = "Complete your registration";
String YouAreOneStepAway = "You are one step away. Please proceed to the final step by clicking the below button.";
String YourApplicationIsCurrentlyUnderReviewByOur = "Your application is currently under review by our team, we will send you an email once your account has been activated.";
String cantWaitToGetStartedYour= "Can't wait to get started? You're almost there!";
String thankYouForRegisteringWithUs= "Thank you for registering with us.";
String thankYouYourApplicationIsComplete = "Your application is complete. We will send you an email once your account is activated. Our normal processing time is 1 business day.";
String accountNumber = "511857571";
String country = 'Country';
String userVerified = 'userVerified';
String isManualReg = 'IsManualReg';
String email = 'email';
String userName = 'userName';
String countryCode = 'countryCode';
String phoneNumber = 'phoneNumber';
String totalAmount = 'Total amount';
String transactionNo = 'Transaction no';
String receiverAmount = 'Receive amount';
String egAddress = 'eg. 308215';
String eg20 = "eg. 20";
String streetName = "Street name";
String suburbName = "Suburb";
String No = "No";
String state = "State";
String eg0 = "000000000";
String egdate = "DD/MM/YYYY";
String datePickerDynamic = "YYYY/MM/DD";

//SharedPreference key

String apiToken = "apiTokenKey";
String apiContactId = "apiContactId";
String dashboardCalc = "dashboardCalc";
String emailAddress = "emailAddress";
String passwordAddress = "passwordAddress";
String AustraliaName = "Australia";
String HongKongName = "HongKong";
String SingaporeName = "Singapore";
int AustraliaCountryCode = 10000011;
String accountPage = "AccountPage";
String receiverPage = "ReceiverPage";
String reviewPage = "ReviewPage";
String SGDCurrencyId = "59C3BBD2-5D26-4A47-8FC1-2EFA628049CE";


extension E on String {
  String lastChars(int n) {
    return substring(length - n);
  }
}
