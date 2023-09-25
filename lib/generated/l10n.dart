// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hi Welcome`
  String get welcomeText {
    return Intl.message(
      'Hi Welcome',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `How are you`
  String get howAreYou {
    return Intl.message(
      'How are you',
      name: 'howAreYou',
      desc: '',
      args: [],
    );
  }

  /// `Wallet balance`
  String get walletBalance {
    return Intl.message(
      'Wallet balance',
      name: 'walletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Top Up`
  String get topUp {
    return Intl.message(
      'Top Up',
      name: 'topUp',
      desc: '',
      args: [],
    );
  }

  /// `You send`
  String get youSend {
    return Intl.message(
      'You send',
      name: 'youSend',
      desc: '',
      args: [],
    );
  }

  /// `Recipient gets`
  String get recipientGets {
    return Intl.message(
      'Recipient gets',
      name: 'recipientGets',
      desc: '',
      args: [],
    );
  }

  /// `Start Your Transfer`
  String get startYourTransfer {
    return Intl.message(
      'Start Your Transfer',
      name: 'startYourTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Manage My Wallet`
  String get manageMyWallet {
    return Intl.message(
      'Manage My Wallet',
      name: 'manageMyWallet',
      desc: '',
      args: [],
    );
  }

  /// `Global Mobile Topup`
  String get globalMobileTopup {
    return Intl.message(
      'Global Mobile Topup',
      name: 'globalMobileTopup',
      desc: '',
      args: [],
    );
  }

  /// `Bill Payment india`
  String get billPaymentindia {
    return Intl.message(
      'Bill Payment india',
      name: 'billPaymentindia',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get invite {
    return Intl.message(
      'Invite',
      name: 'invite',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactUs {
    return Intl.message(
      'Contact us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Rate:`
  String get exchangeRate {
    return Intl.message(
      'Exchange Rate:',
      name: 'exchangeRate',
      desc: '',
      args: [],
    );
  }

  /// `SingX Fee:`
  String get singXFee {
    return Intl.message(
      'SingX Fee:',
      name: 'singXFee',
      desc: '',
      args: [],
    );
  }

  /// `Create Profile`
  String get createProfile {
    return Intl.message(
      'Create Profile',
      name: 'createProfile',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount:`
  String get totalAmount {
    return Intl.message(
      'Total Amount:',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `The Smartest Way to Send Money Overseas`
  String get theSmartestWaytoSendMoneyOverseas {
    return Intl.message(
      'The Smartest Way to Send Money Overseas',
      name: 'theSmartestWaytoSendMoneyOverseas',
      desc: '',
      args: [],
    );
  }

  /// `Country of Residence`
  String get countryofResidence {
    return Intl.message(
      'Country of Residence',
      name: 'countryofResidence',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Hello there, sign in to continue!`
  String get hellothere {
    return Intl.message(
      'Hello there, sign in to continue!',
      name: 'hellothere',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Remember my email`
  String get remembermyemail {
    return Intl.message(
      'Remember my email',
      name: 'remembermyemail',
      desc: '',
      args: [],
    );
  }

  /// `Payment to SingX`
  String get paymenttoSingX {
    return Intl.message(
      'Payment to SingX',
      name: 'paymenttoSingX',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPasswordWeb {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordWeb',
      desc: '',
      args: [],
    );
  }

  /// `Login with Face ID`
  String get loginwithFaceID {
    return Intl.message(
      'Login with Face ID',
      name: 'loginwithFaceID',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account? `
  String get donthaveanaccount {
    return Intl.message(
      'Don’t have an account? ',
      name: 'donthaveanaccount',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get registerNow {
    return Intl.message(
      'Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Topup`
  String get topup {
    return Intl.message(
      'Topup',
      name: 'topup',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Enter Top Up Value`
  String get enterTopUpValue {
    return Intl.message(
      'Enter Top Up Value',
      name: 'enterTopUpValue',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Send to`
  String get sendto {
    return Intl.message(
      'Send to',
      name: 'sendto',
      desc: '',
      args: [],
    );
  }

  /// `Add New Sender Account`
  String get addNewSenderAccount {
    return Intl.message(
      'Add New Sender Account',
      name: 'addNewSenderAccount',
      desc: '',
      args: [],
    );
  }

  /// `Top Up Now`
  String get topUpNow {
    return Intl.message(
      'Top Up Now',
      name: 'topUpNow',
      desc: '',
      args: [],
    );
  }

  /// `Manage Receiver Accounts`
  String get manageReceiverAccounts {
    return Intl.message(
      'Manage Receiver Accounts',
      name: 'manageReceiverAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Manage Sender Accounts`
  String get manageSenderAccounts {
    return Intl.message(
      'Manage Sender Accounts',
      name: 'manageSenderAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Money`
  String get transferMoney {
    return Intl.message(
      'Transfer Money',
      name: 'transferMoney',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get transactionHistory {
    return Intl.message(
      'Transaction History',
      name: 'transactionHistory',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `FAQs`
  String get FAQs {
    return Intl.message(
      'FAQs',
      name: 'FAQs',
      desc: '',
      args: [],
    );
  }

  /// `Global Mobile Top-ups`
  String get globalMobileTopups {
    return Intl.message(
      'Global Mobile Top-ups',
      name: 'globalMobileTopups',
      desc: '',
      args: [],
    );
  }

  /// `Global mobile top-up`
  String get globalMobileTopupsWeb {
    return Intl.message(
      'Global mobile top-up',
      name: 'globalMobileTopupsWeb',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Manage wallet`
  String get manageWallet {
    return Intl.message(
      'Manage wallet',
      name: 'manageWallet',
      desc: '',
      args: [],
    );
  }

  /// `Bill Payments Overseas`
  String get billPaymentsOverseas {
    return Intl.message(
      'Bill Payments Overseas',
      name: 'billPaymentsOverseas',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Select Receiver Account`
  String get selectReceiverAccount {
    return Intl.message(
      'Select Receiver Account',
      name: 'selectReceiverAccount',
      desc: '',
      args: [],
    );
  }

  /// `Search here`
  String get searchhere {
    return Intl.message(
      'Search here',
      name: 'searchhere',
      desc: '',
      args: [],
    );
  }

  /// `Add New Recipient`
  String get addNewRecipient {
    return Intl.message(
      'Add New Recipient',
      name: 'addNewRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Select Sender Account`
  String get selectSenderAccount {
    return Intl.message(
      'Select Sender Account',
      name: 'selectSenderAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add New Sender`
  String get addNewSender {
    return Intl.message(
      'Add New Sender',
      name: 'addNewSender',
      desc: '',
      args: [],
    );
  }

  /// `Review Your Transaction`
  String get reviewYourTransaction {
    return Intl.message(
      'Review Your Transaction',
      name: 'reviewYourTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Amount: `
  String get transferAmount {
    return Intl.message(
      'Transfer Amount: ',
      name: 'transferAmount',
      desc: '',
      args: [],
    );
  }

  /// `Your Cost:`
  String get ourCost {
    return Intl.message(
      'Your Cost:',
      name: 'ourCost',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Amount:`
  String get receiverAmount {
    return Intl.message(
      'Receiver Amount:',
      name: 'receiverAmount',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount You Pay:`
  String get totalAmountYouPay {
    return Intl.message(
      'Total Amount You Pay:',
      name: 'totalAmountYouPay',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Details`
  String get receiverDetails {
    return Intl.message(
      'Receiver Details',
      name: 'receiverDetails',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your mode of payment`
  String get confirmyourmodeofpayment {
    return Intl.message(
      'Confirm your mode of payment',
      name: 'confirmyourmodeofpayment',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Purpose`
  String get transferPurpose {
    return Intl.message(
      'Transfer Purpose',
      name: 'transferPurpose',
      desc: '',
      args: [],
    );
  }

  /// `Enter Promo Code`
  String get enterPromoCode {
    return Intl.message(
      'Enter Promo Code',
      name: 'enterPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Payment`
  String get proceedtoPayment {
    return Intl.message(
      'Proceed to Payment',
      name: 'proceedtoPayment',
      desc: '',
      args: [],
    );
  }

  /// `One-Time Password Verification`
  String get oneTimePasswordVerification {
    return Intl.message(
      'One-Time Password Verification',
      name: 'oneTimePasswordVerification',
      desc: '',
      args: [],
    );
  }

  /// `You will receive an OTP via SMS on your registered mobile. Please enter it to proceed.`
  String get youwillreceiveanOTPviaSMS {
    return Intl.message(
      'You will receive an OTP via SMS on your registered mobile. Please enter it to proceed.',
      name: 'youwillreceiveanOTPviaSMS',
      desc: '',
      args: [],
    );
  }

  /// `Recend OTP in `
  String get recendOTPin {
    return Intl.message(
      'Recend OTP in ',
      name: 'recendOTPin',
      desc: '',
      args: [],
    );
  }

  /// `Verify Now`
  String get verifyNow {
    return Intl.message(
      'Verify Now',
      name: 'verifyNow',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Complete the transaction by transferring the Payment Amount to us. Quote this reference number for faster processing! `
  String get completethetransactionbytransferring {
    return Intl.message(
      'Complete the transaction by transferring the Payment Amount to us. Quote this reference number for faster processing! ',
      name: 'completethetransactionbytransferring',
      desc: '',
      args: [],
    );
  }

  /// `Payment Amount:`
  String get paymentAmount {
    return Intl.message(
      'Payment Amount:',
      name: 'paymentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Reference Number:`
  String get referenceNumber {
    return Intl.message(
      'Reference Number:',
      name: 'referenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Payment Options`
  String get paymentOptions {
    return Intl.message(
      'Payment Options',
      name: 'paymentOptions',
      desc: '',
      args: [],
    );
  }

  /// `PayNow `
  String get payNow {
    return Intl.message(
      'PayNow ',
      name: 'payNow',
      desc: '',
      args: [],
    );
  }

  /// `If you have an account with one of these banks, you can make the payment to us via:`
  String get ifyouhaveanaccountwithoneofthesebanks {
    return Intl.message(
      'If you have an account with one of these banks, you can make the payment to us via:',
      name: 'ifyouhaveanaccountwithoneofthesebanks',
      desc: '',
      args: [],
    );
  }

  /// `UEN Number`
  String get UENNumber {
    return Intl.message(
      'UEN Number',
      name: 'UENNumber',
      desc: '',
      args: [],
    );
  }

  /// `Local Funds Transfer`
  String get localFundsTransfer {
    return Intl.message(
      'Local Funds Transfer',
      name: 'localFundsTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankName {
    return Intl.message(
      'Bank Name',
      name: 'bankName',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get accountName {
    return Intl.message(
      'Account Name',
      name: 'accountName',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get accountNumber {
    return Intl.message(
      'Account Number',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `A copy of the transaction details have been sent to your registered email address for your reference.`
  String get acopyofthetransactiondetails {
    return Intl.message(
      'A copy of the transaction details have been sent to your registered email address for your reference.',
      name: 'acopyofthetransactiondetails',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Account`
  String get createYourAccount {
    return Intl.message(
      'Create Your Account',
      name: 'createYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up in just a few minutes!`
  String get signupinjustafewminutes {
    return Intl.message(
      'Sign up in just a few minutes!',
      name: 'signupinjustafewminutes',
      desc: '',
      args: [],
    );
  }

  /// `Individual`
  String get individual {
    return Intl.message(
      'Individual',
      name: 'individual',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get business {
    return Intl.message(
      'Business',
      name: 'business',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobileNumber {
    return Intl.message(
      'Mobile Number',
      name: 'mobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `I agree to receiving marketing communications from SingX`
  String get iagree {
    return Intl.message(
      'I agree to receiving marketing communications from SingX',
      name: 'iagree',
      desc: '',
      args: [],
    );
  }

  /// `Sign up using`
  String get signupusing {
    return Intl.message(
      'Sign up using',
      name: 'signupusing',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Fill below details and continue`
  String get fillbelowdetailsandcontinue {
    return Intl.message(
      'Fill below details and continue',
      name: 'fillbelowdetailsandcontinue',
      desc: '',
      args: [],
    );
  }

  /// `Personal Details`
  String get personalDetails {
    return Intl.message(
      'Personal Details',
      name: 'personalDetails',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Middle Name (Optional)`
  String get middleName {
    return Intl.message(
      'Middle Name (Optional)',
      name: 'middleName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateofBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateofBirth',
      desc: '',
      args: [],
    );
  }

  /// `Residence`
  String get residence {
    return Intl.message(
      'Residence',
      name: 'residence',
      desc: '',
      args: [],
    );
  }

  /// `Residence Status`
  String get esidenceStatus {
    return Intl.message(
      'Residence Status',
      name: 'esidenceStatus',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get nationality {
    return Intl.message(
      'Nationality',
      name: 'nationality',
      desc: '',
      args: [],
    );
  }

  /// `Occupation`
  String get occupation {
    return Intl.message(
      'Occupation',
      name: 'occupation',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Simply enter your postal code and click “Get address” or enter address manually`
  String get simplyenteryourpostalcode {
    return Intl.message(
      'Simply enter your postal code and click “Get address” or enter address manually',
      name: 'simplyenteryourpostalcode',
      desc: '',
      args: [],
    );
  }

  /// `Postal Code`
  String get postalCode {
    return Intl.message(
      'Postal Code',
      name: 'postalCode',
      desc: '',
      args: [],
    );
  }

  /// `Get Address`
  String get getAddress {
    return Intl.message(
      'Get Address',
      name: 'getAddress',
      desc: '',
      args: [],
    );
  }

  /// `Unit No.`
  String get unitNo {
    return Intl.message(
      'Unit No.',
      name: 'unitNo',
      desc: '',
      args: [],
    );
  }

  /// `Block No.`
  String get blockNo {
    return Intl.message(
      'Block No.',
      name: 'blockNo',
      desc: '',
      args: [],
    );
  }

  /// `Street Name`
  String get streetName {
    return Intl.message(
      'Street Name',
      name: 'streetName',
      desc: '',
      args: [],
    );
  }

  /// `Building Name (Optional)`
  String get buildingNameOptional {
    return Intl.message(
      'Building Name (Optional)',
      name: 'buildingNameOptional',
      desc: '',
      args: [],
    );
  }

  /// `Other Details`
  String get otherDetails {
    return Intl.message(
      'Other Details',
      name: 'otherDetails',
      desc: '',
      args: [],
    );
  }

  /// `Fill below other details too to get best experience with our application`
  String get fillbelowotherdetailstootogetbest {
    return Intl.message(
      'Fill below other details too to get best experience with our application',
      name: 'fillbelowotherdetailstootogetbest',
      desc: '',
      args: [],
    );
  }

  /// `Industry`
  String get industry {
    return Intl.message(
      'Industry',
      name: 'industry',
      desc: '',
      args: [],
    );
  }

  /// `Employer Name`
  String get employerName {
    return Intl.message(
      'Employer Name',
      name: 'employerName',
      desc: '',
      args: [],
    );
  }

  /// `Purpose of Opening this Account`
  String get purposeofOpeningthisAccount {
    return Intl.message(
      'Purpose of Opening this Account',
      name: 'purposeofOpeningthisAccount',
      desc: '',
      args: [],
    );
  }

  /// `Corridors of Interest`
  String get corridorsofInterest {
    return Intl.message(
      'Corridors of Interest',
      name: 'corridorsofInterest',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Transaction Amount (Yearly)`
  String get estimatedTransactionAmount {
    return Intl.message(
      'Estimated Transaction Amount (Yearly)',
      name: 'estimatedTransactionAmount',
      desc: '',
      args: [],
    );
  }

  /// `Annual Income`
  String get annualIncome {
    return Intl.message(
      'Annual Income',
      name: 'annualIncome',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continues {
    return Intl.message(
      'Continue',
      name: 'continues',
      desc: '',
      args: [],
    );
  }

  /// `OPTION 1`
  String get option1 {
    return Intl.message(
      'OPTION 1',
      name: 'option1',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get recommended {
    return Intl.message(
      'Recommended',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `E-Verification`
  String get eVerification {
    return Intl.message(
      'E-Verification',
      name: 'eVerification',
      desc: '',
      args: [],
    );
  }

  /// `Post-Paid Mobile Bill`
  String get postPaidMobileBill {
    return Intl.message(
      'Post-Paid Mobile Bill',
      name: 'postPaidMobileBill',
      desc: '',
      args: [],
    );
  }

  /// `Same mobile number and residential address you’ve registered with`
  String get samemobilenumberandresidentialaddress {
    return Intl.message(
      'Same mobile number and residential address you’ve registered with',
      name: 'samemobilenumberandresidentialaddress',
      desc: '',
      args: [],
    );
  }

  /// `Singapore ID Card`
  String get singaporeIDCard {
    return Intl.message(
      'Singapore ID Card',
      name: 'singaporeIDCard',
      desc: '',
      args: [],
    );
  }

  /// ` Front and Back`
  String get frontandBack {
    return Intl.message(
      ' Front and Back',
      name: 'frontandBack',
      desc: '',
      args: [],
    );
  }

  /// `OPTION 2`
  String get option2 {
    return Intl.message(
      'OPTION 2',
      name: 'option2',
      desc: '',
      args: [],
    );
  }

  /// `Selfie Based Verification`
  String get selfieBasedVerification {
    return Intl.message(
      'Selfie Based Verification',
      name: 'selfieBasedVerification',
      desc: '',
      args: [],
    );
  }

  /// `Selfie`
  String get selfie {
    return Intl.message(
      'Selfie',
      name: 'selfie',
      desc: '',
      args: [],
    );
  }

  /// ` Proof of Address`
  String get proofofAddress {
    return Intl.message(
      ' Proof of Address',
      name: 'proofofAddress',
      desc: '',
      args: [],
    );
  }

  /// `Any utility bill, phone bill or bank statement`
  String get anyutilitybillphonebillorbankstatement {
    return Intl.message(
      'Any utility bill, phone bill or bank statement',
      name: 'anyutilitybillphonebillorbankstatement',
      desc: '',
      args: [],
    );
  }

  /// `Verification Method`
  String get verificationMethod {
    return Intl.message(
      'Verification Method',
      name: 'verificationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Our verification is completely digital, no in-person meeting is required!`
  String get ourverificationiscompletelydigital {
    return Intl.message(
      'Our verification is completely digital, no in-person meeting is required!',
      name: 'ourverificationiscompletelydigital',
      desc: '',
      args: [],
    );
  }

  /// `Option 1 - Selfie Based Verification`
  String get option1SelfieBasedVerification {
    return Intl.message(
      'Option 1 - Selfie Based Verification',
      name: 'option1SelfieBasedVerification',
      desc: '',
      args: [],
    );
  }

  /// `Option 2 - E-Verification`
  String get option2EVerification {
    return Intl.message(
      'Option 2 - E-Verification',
      name: 'option2EVerification',
      desc: '',
      args: [],
    );
  }

  /// `Register via SingPass instead`
  String get registerviaSingPassinstead {
    return Intl.message(
      'Register via SingPass instead',
      name: 'registerviaSingPassinstead',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for registering with us.`
  String get thankyouforregisteringwithus {
    return Intl.message(
      'Thank you for registering with us.',
      name: 'thankyouforregisteringwithus',
      desc: '',
      args: [],
    );
  }

  /// `Your application is complete. We will send you an email once your account is activated. Our normal processing time is 1 business day`
  String get yourapplicationiscomplete {
    return Intl.message(
      'Your application is complete. We will send you an email once your account is activated. Our normal processing time is 1 business day',
      name: 'yourapplicationiscomplete',
      desc: '',
      args: [],
    );
  }

  /// `Add New Receiver`
  String get addNewReceiver {
    return Intl.message(
      'Add New Receiver',
      name: 'addNewReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Please keep these receiver details handy`
  String get pleasekeepthesereceiverdetailshandy {
    return Intl.message(
      'Please keep these receiver details handy',
      name: 'pleasekeepthesereceiverdetailshandy',
      desc: '',
      args: [],
    );
  }

  /// `• Name  • Nationality  • Address  • BSB code• BIC/SWIFT code  • Account Number`
  String get nameNationalityAddressBSBcodeBICSWIFTcodeAccountNumber {
    return Intl.message(
      '• Name  • Nationality  • Address  • BSB code• BIC/SWIFT code  • Account Number',
      name: 'nameNationalityAddressBSBcodeBICSWIFTcodeAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Currency`
  String get receiverCurrency {
    return Intl.message(
      'Receiver Currency',
      name: 'receiverCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Country`
  String get receiverCountry {
    return Intl.message(
      'Receiver Country',
      name: 'receiverCountry',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Type`
  String get receiverType {
    return Intl.message(
      'Receiver Type',
      name: 'receiverType',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `State/Province`
  String get stateProvince {
    return Intl.message(
      'State/Province',
      name: 'stateProvince',
      desc: '',
      args: [],
    );
  }

  /// `BIC/SWIFT code`
  String get bICSWIFTcode {
    return Intl.message(
      'BIC/SWIFT code',
      name: 'bICSWIFTcode',
      desc: '',
      args: [],
    );
  }

  /// `BSB Code`
  String get bSBCode {
    return Intl.message(
      'BSB Code',
      name: 'bSBCode',
      desc: '',
      args: [],
    );
  }

  /// `Click Search`
  String get clickSearch {
    return Intl.message(
      'Click Search',
      name: 'clickSearch',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account Number`
  String get bankAccountNumber {
    return Intl.message(
      'Bank Account Number',
      name: 'bankAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Before you hit save, Please check that all details are correct, especially the account number, Any inaccuracy could result in your money reaching a wrong person’s account`
  String get beforeyouhitsave {
    return Intl.message(
      'Before you hit save, Please check that all details are correct, especially the account number, Any inaccuracy could result in your money reaching a wrong person’s account',
      name: 'beforeyouhitsave',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Remittance`
  String get remittance {
    return Intl.message(
      'Remittance',
      name: 'remittance',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get date {
    return Intl.message(
      'Date:',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Receiver:`
  String get receiver {
    return Intl.message(
      'Receiver:',
      name: 'receiver',
      desc: '',
      args: [],
    );
  }

  /// `Receiver`
  String get receiverWeb {
    return Intl.message(
      'Receiver',
      name: 'receiverWeb',
      desc: '',
      args: [],
    );
  }

  /// `Sender Amount:`
  String get senderAmount {
    return Intl.message(
      'Sender Amount:',
      name: 'senderAmount',
      desc: '',
      args: [],
    );
  }

  /// `Rate:`
  String get rate {
    return Intl.message(
      'Rate:',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Total Payable`
  String get totalPayable {
    return Intl.message(
      'Total Payable',
      name: 'totalPayable',
      desc: '',
      args: [],
    );
  }

  /// `Transaction ID:`
  String get transactionID {
    return Intl.message(
      'Transaction ID:',
      name: 'transactionID',
      desc: '',
      args: [],
    );
  }

  /// `Status:`
  String get status {
    return Intl.message(
      'Status:',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Initiated`
  String get transferInitiated {
    return Intl.message(
      'Transfer Initiated',
      name: 'transferInitiated',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password must contain at least 8 characters with at least one number, one lowercase letter, one uppercase letter and one special character`
  String get yourpasswordmustcontain {
    return Intl.message(
      'Your password must contain at least 8 characters with at least one number, one lowercase letter, one uppercase letter and one special character',
      name: 'yourpasswordmustcontain',
      desc: '',
      args: [],
    );
  }

  /// `Please round off the recieve amount to the nearest multiple of 10 to proceed with the transaction. Round off now`
  String get pleaseroundofftherecieveamount {
    return Intl.message(
      'Please round off the recieve amount to the nearest multiple of 10 to proceed with the transaction. Round off now',
      name: 'pleaseroundofftherecieveamount',
      desc: '',
      args: [],
    );
  }

  /// `For transfers to Sri Lanka (LKR), there is a maximum transfer limit of LKR 50,000,000 per transaction. You can book upto 2 transactions in a day`
  String get fortransferstoSriLanka {
    return Intl.message(
      'For transfers to Sri Lanka (LKR), there is a maximum transfer limit of LKR 50,000,000 per transaction. You can book upto 2 transactions in a day',
      name: 'fortransferstoSriLanka',
      desc: '',
      args: [],
    );
  }

  /// `New Topup`
  String get newTopup {
    return Intl.message(
      'New Topup',
      name: 'newTopup',
      desc: '',
      args: [],
    );
  }

  /// `Check Status`
  String get checkStatus {
    return Intl.message(
      'Check Status',
      name: 'checkStatus',
      desc: '',
      args: [],
    );
  }

  /// `New Mobile Top Up`
  String get newMobileTopUp {
    return Intl.message(
      'New Mobile Top Up',
      name: 'newMobileTopUp',
      desc: '',
      args: [],
    );
  }

  /// `Recipient country`
  String get recipientCountry {
    return Intl.message(
      'Recipient country',
      name: 'recipientCountry',
      desc: '',
      args: [],
    );
  }

  /// `Service provider`
  String get serviceProvider {
    return Intl.message(
      'Service provider',
      name: 'serviceProvider',
      desc: '',
      args: [],
    );
  }

  /// `Topup Now`
  String get topupNow {
    return Intl.message(
      'Topup Now',
      name: 'topupNow',
      desc: '',
      args: [],
    );
  }

  /// `Enter the details below to check your Mobile Top up status.`
  String get enterthedetailsbelowtocheckyourMobileTopupstatus {
    return Intl.message(
      'Enter the details below to check your Mobile Top up status.',
      name: 'enterthedetailsbelowtocheckyourMobileTopupstatus',
      desc: '',
      args: [],
    );
  }

  /// `SingX Transaction ID`
  String get singXTransactionID {
    return Intl.message(
      'SingX Transaction ID',
      name: 'singXTransactionID',
      desc: '',
      args: [],
    );
  }

  /// `Benefits`
  String get benefits {
    return Intl.message(
      'Benefits',
      name: 'benefits',
      desc: '',
      args: [],
    );
  }

  /// `With SingX, You can now Topup mobile data and airtime for your family and friends in India, Indonesia, Malaysia and Philippine!`
  String get withSingXYoucannowTopupmobiledata {
    return Intl.message(
      'With SingX, You can now Topup mobile data and airtime for your family and friends in India, Indonesia, Malaysia and Philippine!',
      name: 'withSingXYoucannowTopupmobiledata',
      desc: '',
      args: [],
    );
  }

  /// `I agree to receiving marketing communications.`
  String get iagreeWeb {
    return Intl.message(
      'I agree to receiving marketing communications.',
      name: 'iagreeWeb',
      desc: '',
      args: [],
    );
  }

  /// `New to SingX?`
  String get newToSingx {
    return Intl.message(
      'New to SingX?',
      name: 'newToSingx',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAnAccount {
    return Intl.message(
      'Create an account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agreed to the `
  String get iAgreePolicyWeb {
    return Intl.message(
      'I have read and agreed to the ',
      name: 'iAgreePolicyWeb',
      desc: '',
      args: [],
    );
  }

  /// `Authorization, `
  String get authorization {
    return Intl.message(
      'Authorization, ',
      name: 'authorization',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Terms & conditions.`
  String get termsAndCondition {
    return Intl.message(
      'Terms & conditions.',
      name: 'termsAndCondition',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get getStartedWeb {
    return Intl.message(
      'Get started',
      name: 'getStartedWeb',
      desc: '',
      args: [],
    );
  }

  /// `Select your registration method`
  String get selectYourRegistrationMethod {
    return Intl.message(
      'Select your registration method',
      name: 'selectYourRegistrationMethod',
      desc: '',
      args: [],
    );
  }

  /// `We have two registration methods for your convenience.`
  String get registationMethods {
    return Intl.message(
      'We have two registration methods for your convenience.',
      name: 'registationMethods',
      desc: '',
      args: [],
    );
  }

  /// `Manual verification`
  String get manualVerification {
    return Intl.message(
      'Manual verification',
      name: 'manualVerification',
      desc: '',
      args: [],
    );
  }

  /// `Simply provide your mobile details,  NRIC/FIN and proof of address`
  String get mobileDetailAndAddress {
    return Intl.message(
      'Simply provide your mobile details,  NRIC/FIN and proof of address',
      name: 'mobileDetailAndAddress',
      desc: '',
      args: [],
    );
  }

  /// `Verify via`
  String get verifyVia {
    return Intl.message(
      'Verify via',
      name: 'verifyVia',
      desc: '',
      args: [],
    );
  }

  /// `The fastest way to get your account!`
  String get fastestWayToGetAccount {
    return Intl.message(
      'The fastest way to get your account!',
      name: 'fastestWayToGetAccount',
      desc: '',
      args: [],
    );
  }

  /// `Back to login`
  String get backToLogin {
    return Intl.message(
      'Back to login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in your profile details to create your account.`
  String get fillDetailToCreateAccount {
    return Intl.message(
      'Please fill in your profile details to create your account.',
      name: 'fillDetailToCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `If you work in Singapore and reside in Johor please click `
  String get workInSingaporeAndJohor {
    return Intl.message(
      'If you work in Singapore and reside in Johor please click ',
      name: 'workInSingaporeAndJohor',
      desc: '',
      args: [],
    );
  }

  /// `here`
  String get here {
    return Intl.message(
      'here',
      name: 'here',
      desc: '',
      args: [],
    );
  }

  /// `Building Name`
  String get buildingName {
    return Intl.message(
      'Building Name',
      name: 'buildingName',
      desc: '',
      args: [],
    );
  }

  /// `We required your employer name to verify that you are a worker.`
  String get employerNameToVerify {
    return Intl.message(
      'We required your employer name to verify that you are a worker.',
      name: 'employerNameToVerify',
      desc: '',
      args: [],
    );
  }

  /// `Select the field or industry that you are currently working on.`
  String get selectTheFieldOrIndustry {
    return Intl.message(
      'Select the field or industry that you are currently working on.',
      name: 'selectTheFieldOrIndustry',
      desc: '',
      args: [],
    );
  }

  /// `Referral code`
  String get referralCode {
    return Intl.message(
      'Referral code',
      name: 'referralCode',
      desc: '',
      args: [],
    );
  }

  /// `Got any referral code from your friend? `
  String get anyReferralcodeFromFriend {
    return Intl.message(
      'Got any referral code from your friend? ',
      name: 'anyReferralcodeFromFriend',
      desc: '',
      args: [],
    );
  }

  /// `Address verification`
  String get addressVerify {
    return Intl.message(
      'Address verification',
      name: 'addressVerify',
      desc: '',
      args: [],
    );
  }

  /// `Verify your address by filling in these details.`
  String get verifyAddressByFillDetail {
    return Intl.message(
      'Verify your address by filling in these details.',
      name: 'verifyAddressByFillDetail',
      desc: '',
      args: [],
    );
  }

  /// `FIN/NRIC number`
  String get finNRICNumber {
    return Intl.message(
      'FIN/NRIC number',
      name: 'finNRICNumber',
      desc: '',
      args: [],
    );
  }

  /// `FIN/NRIC expiry date`
  String get finExpiryDate {
    return Intl.message(
      'FIN/NRIC expiry date',
      name: 'finExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Address proof`
  String get addressProof {
    return Intl.message(
      'Address proof',
      name: 'addressProof',
      desc: '',
      args: [],
    );
  }

  /// `This could be a phone bill, utility bill, bank statement or valid tenancy agreement. Date cannot be older than 3 month.`
  String get addressProofCondition {
    return Intl.message(
      'This could be a phone bill, utility bill, bank statement or valid tenancy agreement. Date cannot be older than 3 month.',
      name: 'addressProofCondition',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Please choose one of the following verification options:`
  String get pleaseChooseOneVerifyOptions {
    return Intl.message(
      'Please choose one of the following verification options:',
      name: 'pleaseChooseOneVerifyOptions',
      desc: '',
      args: [],
    );
  }

  /// `In this method you’ll need to provide,`
  String get needToProvide {
    return Intl.message(
      'In this method you’ll need to provide,',
      name: 'needToProvide',
      desc: '',
      args: [],
    );
  }

  /// `Singapore ID card (Front & back)`
  String get singaporeIDCardFrontAndBackWeb {
    return Intl.message(
      'Singapore ID card (Front & back)',
      name: 'singaporeIDCardFrontAndBackWeb',
      desc: '',
      args: [],
    );
  }

  /// `Verification - Upload your mobile bill`
  String get uploadMobileBill {
    return Intl.message(
      'Verification - Upload your mobile bill',
      name: 'uploadMobileBill',
      desc: '',
      args: [],
    );
  }

  /// `Please check the following points before uploading your document:`
  String get pleaseCheckDocument {
    return Intl.message(
      'Please check the following points before uploading your document:',
      name: 'pleaseCheckDocument',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number and address on this bill are the same as the ones I have registered with SingX.`
  String get mobileNumberAndAddressBill {
    return Intl.message(
      'Mobile number and address on this bill are the same as the ones I have registered with SingX.',
      name: 'mobileNumberAndAddressBill',
      desc: '',
      args: [],
    );
  }

  /// `Mobile bill is in PDF format and contains all the pages.`
  String get mobillBillInPDF {
    return Intl.message(
      'Mobile bill is in PDF format and contains all the pages.',
      name: 'mobillBillInPDF',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded document is mobile bill and not broadband bill.`
  String get uploadDocumnetIsMobileBill {
    return Intl.message(
      'Uploaded document is mobile bill and not broadband bill.',
      name: 'uploadDocumnetIsMobileBill',
      desc: '',
      args: [],
    );
  }

  /// `Verification - Upload your proof of address`
  String get uploadProofOfAdddress {
    return Intl.message(
      'Verification - Upload your proof of address',
      name: 'uploadProofOfAdddress',
      desc: '',
      args: [],
    );
  }

  /// `This could be any of these documents dated less than 3 months old`
  String get documentLessThan3Month {
    return Intl.message(
      'This could be any of these documents dated less than 3 months old',
      name: 'documentLessThan3Month',
      desc: '',
      args: [],
    );
  }

  /// `Phone bill`
  String get phoneBill {
    return Intl.message(
      'Phone bill',
      name: 'phoneBill',
      desc: '',
      args: [],
    );
  }

  /// `Bank statement`
  String get bankStatement {
    return Intl.message(
      'Bank statement',
      name: 'bankStatement',
      desc: '',
      args: [],
    );
  }

  /// `Credit card statement`
  String get creditCardStatement {
    return Intl.message(
      'Credit card statement',
      name: 'creditCardStatement',
      desc: '',
      args: [],
    );
  }

  /// `Utility bill`
  String get utilityBill {
    return Intl.message(
      'Utility bill',
      name: 'utilityBill',
      desc: '',
      args: [],
    );
  }

  /// `Tenancy contract`
  String get tenancyContract {
    return Intl.message(
      'Tenancy contract',
      name: 'tenancyContract',
      desc: '',
      args: [],
    );
  }

  /// `HDB confirmation`
  String get hdbConfirmation {
    return Intl.message(
      'HDB confirmation',
      name: 'hdbConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `FIN or Work permit if your address is displayed on it`
  String get finOrWorkPermit {
    return Intl.message(
      'FIN or Work permit if your address is displayed on it',
      name: 'finOrWorkPermit',
      desc: '',
      args: [],
    );
  }

  /// `Upload your documents`
  String get uploadYourDocument {
    return Intl.message(
      'Upload your documents',
      name: 'uploadYourDocument',
      desc: '',
      args: [],
    );
  }

  /// `We recommend using a colored picture of your ID. Please ensure pop-ups are not blocked and you are not using incognito mode.`
  String get uploadDocumentCondition {
    return Intl.message(
      'We recommend using a colored picture of your ID. Please ensure pop-ups are not blocked and you are not using incognito mode.',
      name: 'uploadDocumentCondition',
      desc: '',
      args: [],
    );
  }

  /// `Choose issuing country/region`
  String get chooseCountryOrRegion {
    return Intl.message(
      'Choose issuing country/region',
      name: 'chooseCountryOrRegion',
      desc: '',
      args: [],
    );
  }

  /// `Select ID type`
  String get selectIdType {
    return Intl.message(
      'Select ID type',
      name: 'selectIdType',
      desc: '',
      args: [],
    );
  }

  /// `Use a valid government issued photo ID`
  String get useValidiGovernmentId {
    return Intl.message(
      'Use a valid government issued photo ID',
      name: 'useValidiGovernmentId',
      desc: '',
      args: [],
    );
  }

  /// `Identity Card`
  String get identityCard {
    return Intl.message(
      'Identity Card',
      name: 'identityCard',
      desc: '',
      args: [],
    );
  }

  /// `Have you checked if your ID is Supported?`
  String get haveYouCheckedYourId {
    return Intl.message(
      'Have you checked if your ID is Supported?',
      name: 'haveYouCheckedYourId',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `OTP verification`
  String get otpVerification {
    return Intl.message(
      'OTP verification',
      name: 'otpVerification',
      desc: '',
      args: [],
    );
  }

  /// `Enter the OTP which we’ve sent to your registered mobile number`
  String get enterTheOtpSendtoMobile {
    return Intl.message(
      'Enter the OTP which we’ve sent to your registered mobile number',
      name: 'enterTheOtpSendtoMobile',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP here`
  String get enterOtpHere {
    return Intl.message(
      'Enter OTP here',
      name: 'enterOtpHere',
      desc: '',
      args: [],
    );
  }

  /// `Resend in`
  String get resendIn {
    return Intl.message(
      'Resend in',
      name: 'resendIn',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendOtp {
    return Intl.message(
      'Resend OTP',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Drop files here or click to upload`
  String get dropFilesToUpload {
    return Intl.message(
      'Drop files here or click to upload',
      name: 'dropFilesToUpload',
      desc: '',
      args: [],
    );
  }

  /// `Supported file formats: jpg, png or pdf and should be less than 5MB`
  String get supportedFileFormat5MB {
    return Intl.message(
      'Supported file formats: jpg, png or pdf and should be less than 5MB',
      name: 'supportedFileFormat5MB',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photoLibrary {
    return Intl.message(
      'Photo',
      name: 'photoLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get welcomeBackWeb {
    return Intl.message(
      'Welcome back!',
      name: 'welcomeBackWeb',
      desc: '',
      args: [],
    );
  }

  /// `Country of residence`
  String get countryofResidenceWeb {
    return Intl.message(
      'Country of residence',
      name: 'countryofResidenceWeb',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get mobileNumberWeb {
    return Intl.message(
      'Mobile number',
      name: 'mobileNumberWeb',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get emailAddressWeb {
    return Intl.message(
      'Email address',
      name: 'emailAddressWeb',
      desc: '',
      args: [],
    );
  }

  /// `Personal details`
  String get personalDetailsWeb {
    return Intl.message(
      'Personal details',
      name: 'personalDetailsWeb',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstNameWeb {
    return Intl.message(
      'First name',
      name: 'firstNameWeb',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastNameWeb {
    return Intl.message(
      'Last name',
      name: 'lastNameWeb',
      desc: '',
      args: [],
    );
  }

  /// `Residence status`
  String get residenceStatusWeb {
    return Intl.message(
      'Residence status',
      name: 'residenceStatusWeb',
      desc: '',
      args: [],
    );
  }

  /// `Postal code`
  String get postalCodeWeb {
    return Intl.message(
      'Postal code',
      name: 'postalCodeWeb',
      desc: '',
      args: [],
    );
  }

  /// `Get address`
  String get getAddressWeb {
    return Intl.message(
      'Get address',
      name: 'getAddressWeb',
      desc: '',
      args: [],
    );
  }

  /// `Unit no.`
  String get unitNoWeb {
    return Intl.message(
      'Unit no.',
      name: 'unitNoWeb',
      desc: '',
      args: [],
    );
  }

  /// `Block no.`
  String get blockNoWeb {
    return Intl.message(
      'Block no.',
      name: 'blockNoWeb',
      desc: '',
      args: [],
    );
  }

  /// `Street name`
  String get streetNameWeb {
    return Intl.message(
      'Street name',
      name: 'streetNameWeb',
      desc: '',
      args: [],
    );
  }

  /// `Building name`
  String get buildingNameWeb {
    return Intl.message(
      'Building name',
      name: 'buildingNameWeb',
      desc: '',
      args: [],
    );
  }

  /// `Employer name`
  String get employerNameWeb {
    return Intl.message(
      'Employer name',
      name: 'employerNameWeb',
      desc: '',
      args: [],
    );
  }

  /// ` Proof of address`
  String get proofofAddressWeb {
    return Intl.message(
      ' Proof of address',
      name: 'proofofAddressWeb',
      desc: '',
      args: [],
    );
  }

  /// `Post-paid mobile bill`
  String get postPaidMobileBillWeb {
    return Intl.message(
      'Post-paid mobile bill',
      name: 'postPaidMobileBillWeb',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpWeb {
    return Intl.message(
      'Sign Up',
      name: 'signUpWeb',
      desc: '',
      args: [],
    );
  }

  /// `Already signed up?`
  String get alreadySignUpWeb {
    return Intl.message(
      'Already signed up?',
      name: 'alreadySignUpWeb',
      desc: '',
      args: [],
    );
  }

  /// `Log In Here`
  String get logInHereWeb {
    return Intl.message(
      'Log In Here',
      name: 'logInHereWeb',
      desc: '',
      args: [],
    );
  }

  /// `Create my account`
  String get createMyAccountWeb {
    return Intl.message(
      'Create my account',
      name: 'createMyAccountWeb',
      desc: '',
      args: [],
    );
  }

  /// `Register with SingPass (fastest)`
  String get registerWithSingPassWeb {
    return Intl.message(
      'Register with SingPass (fastest)',
      name: 'registerWithSingPassWeb',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Bill (Post-Paid)`
  String get mobileBillPostPaid {
    return Intl.message(
      'Mobile Bill (Post-Paid)',
      name: 'mobileBillPostPaid',
      desc: '',
      args: [],
    );
  }

  /// `Please check and confirm the following`
  String get pleasecheckandconfirmthefollowing {
    return Intl.message(
      'Please check and confirm the following',
      name: 'pleasecheckandconfirmthefollowing',
      desc: '',
      args: [],
    );
  }

  /// `1. Mobile number and address on this bill are the same as the ones I have registered with SIngX`
  String
      get mobilenumberandaddressonthisbillarethesameastheonesIhaveregisteredwithSIngX {
    return Intl.message(
      '1. Mobile number and address on this bill are the same as the ones I have registered with SIngX',
      name:
          'mobilenumberandaddressonthisbillarethesameastheonesIhaveregisteredwithSIngX',
      desc: '',
      args: [],
    );
  }

  /// `2. Mobile bill is in PDF formate and contains all pages.`
  String get mobilebillisinPDFformateandcontainsallpages {
    return Intl.message(
      '2. Mobile bill is in PDF formate and contains all pages.',
      name: 'mobilebillisinPDFformateandcontainsallpages',
      desc: '',
      args: [],
    );
  }

  /// `3. Uploaded document is mobile bill and not broadband bill`
  String get uploadeddocumentismobilebillandnotbroadbandbill {
    return Intl.message(
      '3. Uploaded document is mobile bill and not broadband bill',
      name: 'uploadeddocumentismobilebillandnotbroadbandbill',
      desc: '',
      args: [],
    );
  }

  /// `Upload File`
  String get uploadFile {
    return Intl.message(
      'Upload File',
      name: 'uploadFile',
      desc: '',
      args: [],
    );
  }

  /// `Singapore ID`
  String get singaporeID {
    return Intl.message(
      'Singapore ID',
      name: 'singaporeID',
      desc: '',
      args: [],
    );
  }

  /// `A clear photo of your ID is recommended for successful verification.`
  String get aclearphotoofyourIDisrecommendedfor {
    return Intl.message(
      'A clear photo of your ID is recommended for successful verification.',
      name: 'aclearphotoofyourIDisrecommendedfor',
      desc: '',
      args: [],
    );
  }

  /// `Bank transfer`
  String get bankTransfer {
    return Intl.message(
      'Bank transfer',
      name: 'bankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Processed within 1 working day`
  String get processedwithin1workingday {
    return Intl.message(
      'Processed within 1 working day',
      name: 'processedwithin1workingday',
      desc: '',
      args: [],
    );
  }

  /// `Processed Instantly`
  String get processedInstantly {
    return Intl.message(
      'Processed Instantly',
      name: 'processedInstantly',
      desc: '',
      args: [],
    );
  }

  /// `We got your application. It will take around 1-2 business days to review your application and activate your account and you will receive an email once your account is activated. Some features are disabled including fund transactions and wallet access until your account get activated. Thanks for your patience.`
  String get wegotyourapplication {
    return Intl.message(
      'We got your application. It will take around 1-2 business days to review your application and activate your account and you will receive an email once your account is activated. Some features are disabled including fund transactions and wallet access until your account get activated. Thanks for your patience.',
      name: 'wegotyourapplication',
      desc: '',
      args: [],
    );
  }

  /// `Need support? `
  String get needsupport {
    return Intl.message(
      'Need support? ',
      name: 'needsupport',
      desc: '',
      args: [],
    );
  }

  /// `Fair exchange calculator`
  String get fairexchangecalculator {
    return Intl.message(
      'Fair exchange calculator',
      name: 'fairexchangecalculator',
      desc: '',
      args: [],
    );
  }

  /// `Select account`
  String get selectAccount {
    return Intl.message(
      'Select account',
      name: 'selectAccount',
      desc: '',
      args: [],
    );
  }

  /// `Select the account you wish to send money from`
  String get selectAccountYouWishToSend {
    return Intl.message(
      'Select the account you wish to send money from',
      name: 'selectAccountYouWishToSend',
      desc: '',
      args: [],
    );
  }

  /// `Select your bank account`
  String get selectBankAccount {
    return Intl.message(
      'Select your bank account',
      name: 'selectBankAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add a new bank account`
  String get addNewAccount {
    return Intl.message(
      'Add a new bank account',
      name: 'addNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Select receiver`
  String get selectReceiver {
    return Intl.message(
      'Select receiver',
      name: 'selectReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Choose from an existing Receiver or add a new one`
  String get chooseExistingReceiverOrAddNew {
    return Intl.message(
      'Choose from an existing Receiver or add a new one',
      name: 'chooseExistingReceiverOrAddNew',
      desc: '',
      args: [],
    );
  }

  /// `Add a new receiver`
  String get addaNewReceiver {
    return Intl.message(
      'Add a new receiver',
      name: 'addaNewReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Review transaction`
  String get reviewTransaction {
    return Intl.message(
      'Review transaction',
      name: 'reviewTransaction',
      desc: '',
      args: [],
    );
  }

  /// `You’re just one step away from completing your transaction, Simply review the transfer details and proceed to make your transaction`
  String get oneStepAwayFromTransaction {
    return Intl.message(
      'You’re just one step away from completing your transaction, Simply review the transfer details and proceed to make your transaction',
      name: 'oneStepAwayFromTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Sending to`
  String get sendingToWeb {
    return Intl.message(
      'Sending to',
      name: 'sendingToWeb',
      desc: '',
      args: [],
    );
  }

  /// `Transfer amount`
  String get transferAmountWeb {
    return Intl.message(
      'Transfer amount',
      name: 'transferAmountWeb',
      desc: '',
      args: [],
    );
  }

  /// `Exchange rate`
  String get exchangeRateWeb {
    return Intl.message(
      'Exchange rate',
      name: 'exchangeRateWeb',
      desc: '',
      args: [],
    );
  }

  /// `Receiver will get`
  String get receiverWillGet {
    return Intl.message(
      'Receiver will get',
      name: 'receiverWillGet',
      desc: '',
      args: [],
    );
  }

  /// `SingX fee`
  String get singXFeeWeb {
    return Intl.message(
      'SingX fee',
      name: 'singXFeeWeb',
      desc: '',
      args: [],
    );
  }

  /// `Total payable amount`
  String get totalPayableAmountWeb {
    return Intl.message(
      'Total payable amount',
      name: 'totalPayableAmountWeb',
      desc: '',
      args: [],
    );
  }

  /// `Total payable\n amount`
  String get totalPayableAmountMobile {
    return Intl.message(
      'Total payable\n amount',
      name: 'totalPayableAmountMobile',
      desc: '',
      args: [],
    );
  }

  /// `Purpose of transfer`
  String get purposeOfTransfer {
    return Intl.message(
      'Purpose of transfer',
      name: 'purposeOfTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Relationship with sender`
  String get relationshipWithSender {
    return Intl.message(
      'Relationship with sender',
      name: 'relationshipWithSender',
      desc: '',
      args: [],
    );
  }

  /// `If you’re transferring money to your own account, please select your purpose as `
  String get transferMoneyToOwnAccountPleaseSelect {
    return Intl.message(
      'If you’re transferring money to your own account, please select your purpose as ',
      name: 'transferMoneyToOwnAccountPleaseSelect',
      desc: '',
      args: [],
    );
  }

  /// `“Transfer to own account”, `
  String get transferToOwnAccount {
    return Intl.message(
      '“Transfer to own account”, ',
      name: 'transferToOwnAccount',
      desc: '',
      args: [],
    );
  }

  /// `even if you are sending money for purchase of shares, medical expenses, insurance payment etc.`
  String get sendingMoneyForSharesMedicalExpense {
    return Intl.message(
      'even if you are sending money for purchase of shares, medical expenses, insurance payment etc.',
      name: 'sendingMoneyForSharesMedicalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Proceed transaction`
  String get proceedTransactionWeb {
    return Intl.message(
      'Proceed transaction',
      name: 'proceedTransactionWeb',
      desc: '',
      args: [],
    );
  }

  /// `Complete the transaction`
  String get completeTheTransaction {
    return Intl.message(
      'Complete the transaction',
      name: 'completeTheTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Complete this transaction by transferring the payment amount to SingX now`
  String get completeTheTransactionByTransferringPayment {
    return Intl.message(
      'Complete this transaction by transferring the payment amount to SingX now',
      name: 'completeTheTransactionByTransferringPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment amount`
  String get paymentAmountWeb {
    return Intl.message(
      'Payment amount',
      name: 'paymentAmountWeb',
      desc: '',
      args: [],
    );
  }

  /// `Reference Number`
  String get referenceNumberWeb {
    return Intl.message(
      'Reference Number',
      name: 'referenceNumberWeb',
      desc: '',
      args: [],
    );
  }

  /// `Quote this reference number in your internet banking transfer, Not required for DBS/ POSB.`
  String get quoteThisReferenceNumber {
    return Intl.message(
      'Quote this reference number in your internet banking transfer, Not required for DBS/ POSB.',
      name: 'quoteThisReferenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `O P T I O N  1`
  String get option1Transfer {
    return Intl.message(
      'O P T I O N  1',
      name: 'option1Transfer',
      desc: '',
      args: [],
    );
  }

  /// `PAYNOW - Instant transfer`
  String get payNowInstant {
    return Intl.message(
      'PAYNOW - Instant transfer',
      name: 'payNowInstant',
      desc: '',
      args: [],
    );
  }

  /// `If you have an account with one of these banks, you can make the payment to SingX via`
  String get ifYouHaveAnAccountWithOneOfTheseBank {
    return Intl.message(
      'If you have an account with one of these banks, you can make the payment to SingX via',
      name: 'ifYouHaveAnAccountWithOneOfTheseBank',
      desc: '',
      args: [],
    );
  }

  /// `QR Code here`
  String get qrCodeHereWeb {
    return Intl.message(
      'QR Code here',
      name: 'qrCodeHereWeb',
      desc: '',
      args: [],
    );
  }

  /// `UEN number`
  String get UENNumberWeb {
    return Intl.message(
      'UEN number',
      name: 'UENNumberWeb',
      desc: '',
      args: [],
    );
  }

  /// `O P T I O N  2`
  String get option2Banking {
    return Intl.message(
      'O P T I O N  2',
      name: 'option2Banking',
      desc: '',
      args: [],
    );
  }

  /// `Online banking`
  String get onlineBanking {
    return Intl.message(
      'Online banking',
      name: 'onlineBanking',
      desc: '',
      args: [],
    );
  }

  /// `Alternatively, you can send the payment to SingX via internet banking`
  String get alternativelyYouCanSendPaymentToSingX {
    return Intl.message(
      'Alternatively, you can send the payment to SingX via internet banking',
      name: 'alternativelyYouCanSendPaymentToSingX',
      desc: '',
      args: [],
    );
  }

  /// `Quick links to internet banking`
  String get quickLinksToBanking {
    return Intl.message(
      'Quick links to internet banking',
      name: 'quickLinksToBanking',
      desc: '',
      args: [],
    );
  }

  /// `Bank name`
  String get bankNameWeb {
    return Intl.message(
      'Bank name',
      name: 'bankNameWeb',
      desc: '',
      args: [],
    );
  }

  /// `Account name`
  String get accountNameWeb {
    return Intl.message(
      'Account name',
      name: 'accountNameWeb',
      desc: '',
      args: [],
    );
  }

  /// `Account number`
  String get accountNumberWeb {
    return Intl.message(
      'Account number',
      name: 'accountNumberWeb',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get reviewWeb {
    return Intl.message(
      'Review',
      name: 'reviewWeb',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transferWeb {
    return Intl.message(
      'Transfer',
      name: 'transferWeb',
      desc: '',
      args: [],
    );
  }

  /// `Choose an option`
  String get chooseAnOption {
    return Intl.message(
      'Choose an option',
      name: 'chooseAnOption',
      desc: '',
      args: [],
    );
  }

  /// `If you reside in Johor, you can sign up with SingX if you (i) work in Singapore and (ii) have a bank account in Singapore. Enter your residence address below:`
  String get resideInJohorEnterYourAddressBelow {
    return Intl.message(
      'If you reside in Johor, you can sign up with SingX if you (i) work in Singapore and (ii) have a bank account in Singapore. Enter your residence address below:',
      name: 'resideInJohorEnterYourAddressBelow',
      desc: '',
      args: [],
    );
  }

  /// ` If you have a residential address in Singapore, please click `
  String get residentialAddressInSingapore {
    return Intl.message(
      ' If you have a residential address in Singapore, please click ',
      name: 'residentialAddressInSingapore',
      desc: '',
      args: [],
    );
  }

  /// `Salutation`
  String get salutation {
    return Intl.message(
      'Salutation',
      name: 'salutation',
      desc: '',
      args: [],
    );
  }

  /// `Bank Details`
  String get bankDetails {
    return Intl.message(
      'Bank Details',
      name: 'bankDetails',
      desc: '',
      args: [],
    );
  }

  /// `PayNow QR code`
  String get payNowQRcode {
    return Intl.message(
      'PayNow QR code',
      name: 'payNowQRcode',
      desc: '',
      args: [],
    );
  }

  /// `PayNow UEN number`
  String get payNowUENnumber {
    return Intl.message(
      'PayNow UEN number',
      name: 'payNowUENnumber',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Add new receiver`
  String get addNewReceiverWeb {
    return Intl.message(
      'Add new receiver',
      name: 'addNewReceiverWeb',
      desc: '',
      args: [],
    );
  }

  /// `Full name of the account holder`
  String get fullNameOfAccountHolder {
    return Intl.message(
      'Full name of the account holder',
      name: 'fullNameOfAccountHolder',
      desc: '',
      args: [],
    );
  }

  /// `Receiver country`
  String get receiverCountryWeb {
    return Intl.message(
      'Receiver country',
      name: 'receiverCountryWeb',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currencyWeb {
    return Intl.message(
      'Currency',
      name: 'currencyWeb',
      desc: '',
      args: [],
    );
  }

  /// `Receiver bank name`
  String get receiverBankName {
    return Intl.message(
      'Receiver bank name',
      name: 'receiverBankName',
      desc: '',
      args: [],
    );
  }

  /// `SWIFT / BIC code`
  String get swiftOrBicCode {
    return Intl.message(
      'SWIFT / BIC code',
      name: 'swiftOrBicCode',
      desc: '',
      args: [],
    );
  }

  /// `Receiver account number`
  String get receiverAccountNumber {
    return Intl.message(
      'Receiver account number',
      name: 'receiverAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Before you hit save, please check that all details are correct, especially the account number.\nAny inaccuracy could result in your money reaching a wrong person’s account!`
  String get beforeYouHitSavePleaseCheckDetailsAreCorrect {
    return Intl.message(
      'Before you hit save, please check that all details are correct, especially the account number.\nAny inaccuracy could result in your money reaching a wrong person’s account!',
      name: 'beforeYouHitSavePleaseCheckDetailsAreCorrect',
      desc: '',
      args: [],
    );
  }

  /// `Account holder name`
  String get accountHolderName {
    return Intl.message(
      'Account holder name',
      name: 'accountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get countryWeb {
    return Intl.message(
      'Country',
      name: 'countryWeb',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bank {
    return Intl.message(
      'Bank',
      name: 'bank',
      desc: '',
      args: [],
    );
  }

  /// `Send money`
  String get sendMoneyWeb {
    return Intl.message(
      'Send money',
      name: 'sendMoneyWeb',
      desc: '',
      args: [],
    );
  }

  /// `Delete receiver`
  String get deleteReceiver {
    return Intl.message(
      'Delete receiver',
      name: 'deleteReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Manage receivers`
  String get manageReceivers {
    return Intl.message(
      'Manage receivers',
      name: 'manageReceivers',
      desc: '',
      args: [],
    );
  }

  /// `Manage receivers/ add new receiver`
  String get manageReceiversOrAddNewReceiver {
    return Intl.message(
      'Manage receivers/ add new receiver',
      name: 'manageReceiversOrAddNewReceiver',
      desc: '',
      args: [],
    );
  }

  /// `Manage receivers/\nadd new receiver`
  String get manageReceiversOrAddNewReceiverMobile {
    return Intl.message(
      'Manage receivers/\nadd new receiver',
      name: 'manageReceiversOrAddNewReceiverMobile',
      desc: '',
      args: [],
    );
  }

  /// `/ Add new receiver`
  String get OrAddNewReceiverMobile {
    return Intl.message(
      '/ Add new receiver',
      name: 'OrAddNewReceiverMobile',
      desc: '',
      args: [],
    );
  }

  /// `Manage receivers`
  String get manageReceiversOr {
    return Intl.message(
      'Manage receivers',
      name: 'manageReceiversOr',
      desc: '',
      args: [],
    );
  }

  /// `Add your bank account`
  String get addYourBankAccount {
    return Intl.message(
      'Add your bank account',
      name: 'addYourBankAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add new sender`
  String get addNewSenderWeb {
    return Intl.message(
      'Add new sender',
      name: 'addNewSenderWeb',
      desc: '',
      args: [],
    );
  }

  /// `Please note that you may only add bank account(s) where you are either the main or joint account holder. Any other accounts will not be accepted.`
  String get addOnlyOneBankAccount {
    return Intl.message(
      'Please note that you may only add bank account(s) where you are either the main or joint account holder. Any other accounts will not be accepted.',
      name: 'addOnlyOneBankAccount',
      desc: '',
      args: [],
    );
  }

  /// `This is a joint account`
  String get jointAccountWeb {
    return Intl.message(
      'This is a joint account',
      name: 'jointAccountWeb',
      desc: '',
      args: [],
    );
  }

  /// `To edit or delete bank accounts, please write to us at `
  String get editOrDeleteBankAccount {
    return Intl.message(
      'To edit or delete bank accounts, please write to us at ',
      name: 'editOrDeleteBankAccount',
      desc: '',
      args: [],
    );
  }

  /// `help@singx.co`
  String get helpSingX {
    return Intl.message(
      'help@singx.co',
      name: 'helpSingX',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Top-up`
  String get mobileTopup {
    return Intl.message(
      'Mobile Top-up',
      name: 'mobileTopup',
      desc: '',
      args: [],
    );
  }

  /// `Read more about`
  String get readMoreAbout {
    return Intl.message(
      'Read more about',
      name: 'readMoreAbout',
      desc: '',
      args: [],
    );
  }

  /// `Select the plan`
  String get selecttheplan {
    return Intl.message(
      'Select the plan',
      name: 'selecttheplan',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get datewithout {
    return Intl.message(
      'Date',
      name: 'datewithout',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get statuswithout {
    return Intl.message(
      'Status',
      name: 'statuswithout',
      desc: '',
      args: [],
    );
  }

  /// `Amount paid`
  String get amountPaid {
    return Intl.message(
      'Amount paid',
      name: 'amountPaid',
      desc: '',
      args: [],
    );
  }

  /// `Top-up amount`
  String get topUpAmount {
    return Intl.message(
      'Top-up amount',
      name: 'topUpAmount',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Your SingX wallet can be used to pay for a suite of services such as Remittance, Mobile Top ups and Bill payments in India. It is optional to use the wallet, you can still create remittance transactions via bank transfers or PayNow.`
  String get yourSingXWallet {
    return Intl.message(
      'Your SingX wallet can be used to pay for a suite of services such as Remittance, Mobile Top ups and Bill payments in India. It is optional to use the wallet, you can still create remittance transactions via bank transfers or PayNow.',
      name: 'yourSingXWallet',
      desc: '',
      args: [],
    );
  }

  /// `Find out more`
  String get findOut {
    return Intl.message(
      'Find out more',
      name: 'findOut',
      desc: '',
      args: [],
    );
  }

  /// `Top-up now`
  String get topUPWithDAsh {
    return Intl.message(
      'Top-up now',
      name: 'topUPWithDAsh',
      desc: '',
      args: [],
    );
  }

  /// `SingX wallet`
  String get singXWallet {
    return Intl.message(
      'SingX wallet',
      name: 'singXWallet',
      desc: '',
      args: [],
    );
  }

  /// `Introducing your very own SingX wallet - top up once, use many times! Enjoy all these benefits and more:`
  String get introducingYourVeryOwn {
    return Intl.message(
      'Introducing your very own SingX wallet - top up once, use many times! Enjoy all these benefits and more:',
      name: 'introducingYourVeryOwn',
      desc: '',
      args: [],
    );
  }

  /// `Top ups to your wallet are absolutely free!`
  String get topupToYour {
    return Intl.message(
      'Top ups to your wallet are absolutely free!',
      name: 'topupToYour',
      desc: '',
      args: [],
    );
  }

  /// `Use your wallet balance to make transfers to over 35 countries in just 1 simple step.`
  String get useYourWalletBalance {
    return Intl.message(
      'Use your wallet balance to make transfers to over 35 countries in just 1 simple step.',
      name: 'useYourWalletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Pay bills and top-up overseas mobile phones in just a few clicks.`
  String get payBillsAndTopup {
    return Intl.message(
      'Pay bills and top-up overseas mobile phones in just a few clicks.',
      name: 'payBillsAndTopup',
      desc: '',
      args: [],
    );
  }

  /// `Top ups to your wallet are absolutely free!`
  String get topUpToYourWallet {
    return Intl.message(
      'Top ups to your wallet are absolutely free!',
      name: 'topUpToYourWallet',
      desc: '',
      args: [],
    );
  }

  /// `How to Top Up your Wallet`
  String get howToTopUpYour {
    return Intl.message(
      'How to Top Up your Wallet',
      name: 'howToTopUpYour',
      desc: '',
      args: [],
    );
  }

  /// `Select 'Top-up' on your Dashboard`
  String get selectTopUpOnYour {
    return Intl.message(
      'Select \'Top-up\' on your Dashboard',
      name: 'selectTopUpOnYour',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount and choose your Payment Method - Bank Transfer or PayNow (QR Code)`
  String get enterAmountAndChoose {
    return Intl.message(
      'Enter amount and choose your Payment Method - Bank Transfer or PayNow (QR Code)',
      name: 'enterAmountAndChoose',
      desc: '',
      args: [],
    );
  }

  /// `Transfer the funds to us.`
  String get transferTheFund {
    return Intl.message(
      'Transfer the funds to us.',
      name: 'transferTheFund',
      desc: '',
      args: [],
    );
  }

  /// `To withdraw funds from your SingX Wallet to your bank account, please email us at `
  String get toWithdrawFundsFrom {
    return Intl.message(
      'To withdraw funds from your SingX Wallet to your bank account, please email us at ',
      name: 'toWithdrawFundsFrom',
      desc: '',
      args: [],
    );
  }

  /// `help@singx.co`
  String get helpSingXLink {
    return Intl.message(
      'help@singx.co',
      name: 'helpSingXLink',
      desc: '',
      args: [],
    );
  }

  /// `Enter Top Up Value`
  String get enterTopupValue {
    return Intl.message(
      'Enter Top Up Value',
      name: 'enterTopupValue',
      desc: '',
      args: [],
    );
  }

  /// `You can hold a maximum of SGD 5,000 in your wallet`
  String get youCanHoldAMaximum {
    return Intl.message(
      'You can hold a maximum of SGD 5,000 in your wallet',
      name: 'youCanHoldAMaximum',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment Method`
  String get selectPaymentMethod {
    return Intl.message(
      'Select Payment Method',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `PayNow - Quick credit`
  String get payNowQuick {
    return Intl.message(
      'PayNow - Quick credit',
      name: 'payNowQuick',
      desc: '',
      args: [],
    );
  }

  /// `Bank transfer - Credit in few hours`
  String get bankTransferCredit {
    return Intl.message(
      'Bank transfer - Credit in few hours',
      name: 'bankTransferCredit',
      desc: '',
      args: [],
    );
  }

  /// `Add a new account`
  String get addNewAccountNoBank {
    return Intl.message(
      'Add a new account',
      name: 'addNewAccountNoBank',
      desc: '',
      args: [],
    );
  }

  /// `Activities`
  String get activities {
    return Intl.message(
      'Activities',
      name: 'activities',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Transaction no`
  String get transactionno {
    return Intl.message(
      'Transaction no',
      name: 'transactionno',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get ratewithout {
    return Intl.message(
      'Rate',
      name: 'ratewithout',
      desc: '',
      args: [],
    );
  }

  /// `Receive amount`
  String get receiveAmount {
    return Intl.message(
      'Receive amount',
      name: 'receiveAmount',
      desc: '',
      args: [],
    );
  }

  /// `Download statement`
  String get downloadStatement {
    return Intl.message(
      'Download statement',
      name: 'downloadStatement',
      desc: '',
      args: [],
    );
  }

  /// `Manage senders`
  String get manageSenders {
    return Intl.message(
      'Manage senders',
      name: 'manageSenders',
      desc: '',
      args: [],
    );
  }

  /// `Manage senders`
  String get manageSendersOr {
    return Intl.message(
      'Manage senders',
      name: 'manageSendersOr',
      desc: '',
      args: [],
    );
  }

  /// `/ Add your bank account`
  String get OrAddYourAccount {
    return Intl.message(
      '/ Add your bank account',
      name: 'OrAddYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Manage senders/\nAdd your bank account`
  String get manageSendersOrAddYourAccountMobile {
    return Intl.message(
      'Manage senders/\nAdd your bank account',
      name: 'manageSendersOrAddYourAccountMobile',
      desc: '',
      args: [],
    );
  }

  /// `Billing category`
  String get billingCategory {
    return Intl.message(
      'Billing category',
      name: 'billingCategory',
      desc: '',
      args: [],
    );
  }

  /// `Operator name`
  String get operatorName {
    return Intl.message(
      'Operator name',
      name: 'operatorName',
      desc: '',
      args: [],
    );
  }

  /// `Bill amount`
  String get billAmount {
    return Intl.message(
      'Bill amount',
      name: 'billAmount',
      desc: '',
      args: [],
    );
  }

  /// `Transaction ID`
  String get transactionIDTable {
    return Intl.message(
      'Transaction ID',
      name: 'transactionIDTable',
      desc: '',
      args: [],
    );
  }

  /// `Utilities`
  String get utilities {
    return Intl.message(
      'Utilities',
      name: 'utilities',
      desc: '',
      args: [],
    );
  }

  /// `Finances`
  String get finances {
    return Intl.message(
      'Finances',
      name: 'finances',
      desc: '',
      args: [],
    );
  }

  /// `On The Go`
  String get onTheGo {
    return Intl.message(
      'On The Go',
      name: 'onTheGo',
      desc: '',
      args: [],
    );
  }

  /// `India bill payment`
  String get indiaBillPayment {
    return Intl.message(
      'India bill payment',
      name: 'indiaBillPayment',
      desc: '',
      args: [],
    );
  }

  /// `Select your billing Category`
  String get selectYourBillingCategory {
    return Intl.message(
      'Select your billing Category',
      name: 'selectYourBillingCategory',
      desc: '',
      args: [],
    );
  }

  /// `Send money`
  String get sendMoney {
    return Intl.message(
      'Send money',
      name: 'sendMoney',
      desc: '',
      args: [],
    );
  }

  /// `Top-up`
  String get topUpInBetweenDash {
    return Intl.message(
      'Top-up',
      name: 'topUpInBetweenDash',
      desc: '',
      args: [],
    );
  }

  /// `Referral code:`
  String get referralCodeWithColan {
    return Intl.message(
      'Referral code:',
      name: 'referralCodeWithColan',
      desc: '',
      args: [],
    );
  }

  /// `Bill Payments`
  String get billPayment {
    return Intl.message(
      'Bill Payments',
      name: 'billPayment',
      desc: '',
      args: [],
    );
  }

  /// `Recent activities`
  String get recentActivities {
    return Intl.message(
      'Recent activities',
      name: 'recentActivities',
      desc: '',
      args: [],
    );
  }

  /// `See all activities`
  String get seeAllActivities {
    return Intl.message(
      'See all activities',
      name: 'seeAllActivities',
      desc: '',
      args: [],
    );
  }

  /// `Note: Transactions to India: Many states in India have announced a holiday today. While we continue to proceed transactions to India as usual, the credit to your receiver’s account in India may take longer than usual.`
  String get noteTransactionToIndia {
    return Intl.message(
      'Note: Transactions to India: Many states in India have announced a holiday today. While we continue to proceed transactions to India as usual, the credit to your receiver’s account in India may take longer than usual.',
      name: 'noteTransactionToIndia',
      desc: '',
      args: [],
    );
  }

  /// `Transactions to the UK are capped at GBP 50,000. Please enter a smaller value.`
  String get transactionToTheUK {
    return Intl.message(
      'Transactions to the UK are capped at GBP 50,000. Please enter a smaller value.',
      name: 'transactionToTheUK',
      desc: '',
      args: [],
    );
  }

  /// `Before you hit save, please check that all details are correct, especially the account number.Any inaccuracy could result in your money reaching a wrong person’s account!`
  String get beforeYouHitSavePleaseCheckDetailsAreCorrectPopUp {
    return Intl.message(
      'Before you hit save, please check that all details are correct, especially the account number.Any inaccuracy could result in your money reaching a wrong person’s account!',
      name: 'beforeYouHitSavePleaseCheckDetailsAreCorrectPopUp',
      desc: '',
      args: [],
    );
  }

  /// `Top up via PayNow`
  String get topUpViaPayNow {
    return Intl.message(
      'Top up via PayNow',
      name: 'topUpViaPayNow',
      desc: '',
      args: [],
    );
  }

  /// `Top up via Bank Transfer`
  String get topUpViaBankTransfer {
    return Intl.message(
      'Top up via Bank Transfer',
      name: 'topUpViaBankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `DBS Bank/ POSB`
  String get dBSBankPOSB {
    return Intl.message(
      'DBS Bank/ POSB',
      name: 'dBSBankPOSB',
      desc: '',
      args: [],
    );
  }

  /// `SingX Singapore (Client account)`
  String get singXClient {
    return Intl.message(
      'SingX Singapore (Client account)',
      name: 'singXClient',
      desc: '',
      args: [],
    );
  }

  /// `1. Open your mobile banking app and scan this QR code using the app scanner`
  String get openYourMobileBanking {
    return Intl.message(
      '1. Open your mobile banking app and scan this QR code using the app scanner',
      name: 'openYourMobileBanking',
      desc: '',
      args: [],
    );
  }

  /// `2. All transfer details will be auto-populated, check that they are correct and proceed to pay`
  String get allTransferDetails {
    return Intl.message(
      '2. All transfer details will be auto-populated, check that they are correct and proceed to pay',
      name: 'allTransferDetails',
      desc: '',
      args: [],
    );
  }

  /// `UEN Number`
  String get uenNumber {
    return Intl.message(
      'UEN Number',
      name: 'uenNumber',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get searchWithDot {
    return Intl.message(
      'Search...',
      name: 'searchWithDot',
      desc: '',
      args: [],
    );
  }

  /// `Transfer PHP via:`
  String get transferPHPvia {
    return Intl.message(
      'Transfer PHP via:',
      name: 'transferPHPvia',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Category`
  String get receiverCategory {
    return Intl.message(
      'Receiver Category',
      name: 'receiverCategory',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Nationality`
  String get receiverNationality {
    return Intl.message(
      'Receiver Nationality',
      name: 'receiverNationality',
      desc: '',
      args: [],
    );
  }

  /// `Country of Incorporation`
  String get countryofIncorporation {
    return Intl.message(
      'Country of Incorporation',
      name: 'countryofIncorporation',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Company Name`
  String get receiverCompanyName {
    return Intl.message(
      'Receiver Company Name',
      name: 'receiverCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Receiver First Name`
  String get receiverFirstName {
    return Intl.message(
      'Receiver First Name',
      name: 'receiverFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Last Name`
  String get receiverLastName {
    return Intl.message(
      'Receiver Last Name',
      name: 'receiverLastName',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Address`
  String get receiverAddress {
    return Intl.message(
      'Receiver Address',
      name: 'receiverAddress',
      desc: '',
      args: [],
    );
  }

  /// `Receiver City`
  String get receiverCity {
    return Intl.message(
      'Receiver City',
      name: 'receiverCity',
      desc: '',
      args: [],
    );
  }

  /// `Receiver State/Territory`
  String get receiverStateTerritory {
    return Intl.message(
      'Receiver State/Territory',
      name: 'receiverStateTerritory',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Postal Code`
  String get receiverPostalCode {
    return Intl.message(
      'Receiver Postal Code',
      name: 'receiverPostalCode',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Account Type`
  String get receiverAccountType {
    return Intl.message(
      'Receiver Account Type',
      name: 'receiverAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Debit card Number`
  String get receiverDebitCardNumber {
    return Intl.message(
      'Receiver Debit card Number',
      name: 'receiverDebitCardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Mobile Number`
  String get receiverMobileNumber {
    return Intl.message(
      'Receiver Mobile Number',
      name: 'receiverMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Bank Branch Name`
  String get bankBranchName {
    return Intl.message(
      'Bank Branch Name',
      name: 'bankBranchName',
      desc: '',
      args: [],
    );
  }

  /// `Receiver IBAN`
  String get receiverIBAN {
    return Intl.message(
      'Receiver IBAN',
      name: 'receiverIBAN',
      desc: '',
      args: [],
    );
  }

  /// `Receiver BSB Code`
  String get receiverBSBCode {
    return Intl.message(
      'Receiver BSB Code',
      name: 'receiverBSBCode',
      desc: '',
      args: [],
    );
  }

  /// `Receiver IFSC Code`
  String get receiverIFSCCode {
    return Intl.message(
      'Receiver IFSC Code',
      name: 'receiverIFSCCode',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Sort Code`
  String get receiverSortCode {
    return Intl.message(
      'Receiver Sort Code',
      name: 'receiverSortCode',
      desc: '',
      args: [],
    );
  }

  /// `Financial Institution Number`
  String get financialInstitutionNumber {
    return Intl.message(
      'Financial Institution Number',
      name: 'financialInstitutionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Branch Transit Number`
  String get branchTransitNumber {
    return Intl.message(
      'Branch Transit Number',
      name: 'branchTransitNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Bank Code`
  String get enterBankCode {
    return Intl.message(
      'Enter Bank Code',
      name: 'enterBankCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Branch Code`
  String get enterBranchCode {
    return Intl.message(
      'Enter Branch Code',
      name: 'enterBranchCode',
      desc: '',
      args: [],
    );
  }

  /// `Receiver E-Wallet Name`
  String get receiverEWalletName {
    return Intl.message(
      'Receiver E-Wallet Name',
      name: 'receiverEWalletName',
      desc: '',
      args: [],
    );
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message(
      'Branch Name',
      name: 'branchName',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Company Registration Number`
  String get receiverCompanyRegistrationNumber {
    return Intl.message(
      'Receiver Company Registration Number',
      name: 'receiverCompanyRegistrationNumber',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code`
  String get enterTheCode {
    return Intl.message(
      'Enter the code',
      name: 'enterTheCode',
      desc: '',
      args: [],
    );
  }

  /// `House /Lot Number/Floor`
  String get HouseLotNumberFloor {
    return Intl.message(
      'House /Lot Number/Floor',
      name: 'HouseLotNumberFloor',
      desc: '',
      args: [],
    );
  }

  /// `City Name`
  String get cityName {
    return Intl.message(
      'City Name',
      name: 'cityName',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message(
      'Proceed',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `New bill payment`
  String get newBillPayment {
    return Intl.message(
      'New bill payment',
      name: 'newBillPayment',
      desc: '',
      args: [],
    );
  }

  /// `India bill payment`
  String get indiaBillPaymentOr {
    return Intl.message(
      'India bill payment',
      name: 'indiaBillPaymentOr',
      desc: '',
      args: [],
    );
  }

  /// ` / New bill payment`
  String get OrNewBillPayment {
    return Intl.message(
      ' / New bill payment',
      name: 'OrNewBillPayment',
      desc: '',
      args: [],
    );
  }

  /// `India bill payment / New bill payment`
  String get indiaBillPaymentOrNewBillPayment {
    return Intl.message(
      'India bill payment / New bill payment',
      name: 'indiaBillPaymentOrNewBillPayment',
      desc: '',
      args: [],
    );
  }

  /// `India bill payment /\nNew bill payment`
  String get indiaBillPaymentOrNewBillPaymentUpdated {
    return Intl.message(
      'India bill payment /\nNew bill payment',
      name: 'indiaBillPaymentOrNewBillPaymentUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Recipient name`
  String get recipientName {
    return Intl.message(
      'Recipient name',
      name: 'recipientName',
      desc: '',
      args: [],
    );
  }

  /// `Consumer number`
  String get consumerNumber {
    return Intl.message(
      'Consumer number',
      name: 'consumerNumber',
      desc: '',
      args: [],
    );
  }

  /// `Consumer number is required`
  String get consumerNumberIsRequired {
    return Intl.message(
      'Consumer number is required',
      name: 'consumerNumberIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid consumer number`
  String get enterValidConsumerNumber {
    return Intl.message(
      'Enter valid consumer number',
      name: 'enterValidConsumerNumber',
      desc: '',
      args: [],
    );
  }

  /// `Employer name is required`
  String get employerNameIsRequired {
    return Intl.message(
      'Employer name is required',
      name: 'employerNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid employer name`
  String get enterValidEmployerName {
    return Intl.message(
      'Enter valid employer name',
      name: 'enterValidEmployerName',
      desc: '',
      args: [],
    );
  }

  /// `India`
  String get india {
    return Intl.message(
      'India',
      name: 'india',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Running balance`
  String get runningBalance {
    return Intl.message(
      'Running balance',
      name: 'runningBalance',
      desc: '',
      args: [],
    );
  }

  /// `Select currency pair`
  String get selectCurrencyPair {
    return Intl.message(
      'Select currency pair',
      name: 'selectCurrencyPair',
      desc: '',
      args: [],
    );
  }

  /// `Select alert type`
  String get selectAlertType {
    return Intl.message(
      'Select alert type',
      name: 'selectAlertType',
      desc: '',
      args: [],
    );
  }

  /// `Rate alerts`
  String get rateAlerts {
    return Intl.message(
      'Rate alerts',
      name: 'rateAlerts',
      desc: '',
      args: [],
    );
  }

  /// `Change your password`
  String get changeYourPassword {
    return Intl.message(
      'Change your password',
      name: 'changeYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please do not repeat an old password.`
  String get pleaseDontRepeatAnOldPassword {
    return Intl.message(
      'Please do not repeat an old password.',
      name: 'pleaseDontRepeatAnOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Updated Successfully.`
  String get passwordUpdatedSuccessful {
    return Intl.message(
      'Password Updated Successfully.',
      name: 'passwordUpdatedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get oK {
    return Intl.message(
      'Ok',
      name: 'oK',
      desc: '',
      args: [],
    );
  }

  /// `Select Birth Date`
  String get selectDoB {
    return Intl.message(
      'Select Birth Date',
      name: 'selectDoB',
      desc: '',
      args: [],
    );
  }

  /// `Can't find your address?`
  String get cantFindYourAddress {
    return Intl.message(
      'Can\'t find your address?',
      name: 'cantFindYourAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter Manually`
  String get enterManually {
    return Intl.message(
      'Enter Manually',
      name: 'enterManually',
      desc: '',
      args: [],
    );
  }

  /// `Use Automatic Search`
  String get userAutomaticSearch {
    return Intl.message(
      'Use Automatic Search',
      name: 'userAutomaticSearch',
      desc: '',
      args: [],
    );
  }

  /// `Search Address`
  String get searchAddress {
    return Intl.message(
      'Search Address',
      name: 'searchAddress',
      desc: '',
      args: [],
    );
  }

  /// `If Applicable`
  String get ifApplicable {
    return Intl.message(
      'If Applicable',
      name: 'ifApplicable',
      desc: '',
      args: [],
    );
  }

  /// `Street Number`
  String get streetNumber {
    return Intl.message(
      'Street Number',
      name: 'streetNumber',
      desc: '',
      args: [],
    );
  }

  /// `Suburb`
  String get suburb {
    return Intl.message(
      'Suburb',
      name: 'suburb',
      desc: '',
      args: [],
    );
  }

  /// `Choose State`
  String get chooseState {
    return Intl.message(
      'Choose State',
      name: 'chooseState',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Annual Income`
  String get estimatedAnnualIncome {
    return Intl.message(
      'Estimated Annual Income',
      name: 'estimatedAnnualIncome',
      desc: '',
      args: [],
    );
  }

  /// `Self Income`
  String get selfIncome {
    return Intl.message(
      'Self Income',
      name: 'selfIncome',
      desc: '',
      args: [],
    );
  }

  /// `For straight through processing, I would like to choose digital ID verification. I confirm that I am authorised to provide these personal details and I consent to my information being checked with the document issuer or official record holder via third party systems for the purpose of confirming my identity as required.`
  String
      get forStraightThroughProcessingIWouldLikeToChooseDigitalIDVerification {
    return Intl.message(
      'For straight through processing, I would like to choose digital ID verification. I confirm that I am authorised to provide these personal details and I consent to my information being checked with the document issuer or official record holder via third party systems for the purpose of confirming my identity as required.',
      name:
          'forStraightThroughProcessingIWouldLikeToChooseDigitalIDVerification',
      desc: '',
      args: [],
    );
  }

  /// `I do not wish to disclose any personal information to any credit reporting or government agency. I will proceed with the non-digital verification process.`
  String
      get IDoNotWishToDiscloseAnyPersonalInformationToAnyCreditReportingOrGovernmentAgency {
    return Intl.message(
      'I do not wish to disclose any personal information to any credit reporting or government agency. I will proceed with the non-digital verification process.',
      name:
          'IDoNotWishToDiscloseAnyPersonalInformationToAnyCreditReportingOrGovernmentAgency',
      desc: '',
      args: [],
    );
  }

  /// `Identification Details`
  String get identificationDetails {
    return Intl.message(
      'Identification Details',
      name: 'identificationDetails',
      desc: '',
      args: [],
    );
  }

  /// `1. Please upload any ONE of the following documents:`
  String get pleaseUploadAnyONEOfTheFollowingDocuments {
    return Intl.message(
      '1. Please upload any ONE of the following documents:',
      name: 'pleaseUploadAnyONEOfTheFollowingDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Passport - photo page`
  String get passportPhotoPage {
    return Intl.message(
      'Passport - photo page',
      name: 'passportPhotoPage',
      desc: '',
      args: [],
    );
  }

  /// `Driver’s License - Front & Back`
  String get driverLicenseFrontBack {
    return Intl.message(
      'Driver’s License - Front & Back',
      name: 'driverLicenseFrontBack',
      desc: '',
      args: [],
    );
  }

  /// `2. Please also upload any ONE of these additional documents:`
  String get pleaseAlsoUploadAnyONEOfTheseAdditionalDocuments {
    return Intl.message(
      '2. Please also upload any ONE of these additional documents:',
      name: 'pleaseAlsoUploadAnyONEOfTheseAdditionalDocuments',
      desc: '',
      args: [],
    );
  }

  /// `State issued Photo ID card`
  String get stateIssuedPhotoIDCard {
    return Intl.message(
      'State issued Photo ID card',
      name: 'stateIssuedPhotoIDCard',
      desc: '',
      args: [],
    );
  }

  /// `State issued proof of age card`
  String get StateIssuedProofOfAgeCard {
    return Intl.message(
      'State issued proof of age card',
      name: 'StateIssuedProofOfAgeCard',
      desc: '',
      args: [],
    );
  }

  /// `Valid visa approval document showing your name & date of birth`
  String get validVisaApprovalDocumentShowingYourNameDateOfBirth {
    return Intl.message(
      'Valid visa approval document showing your name & date of birth',
      name: 'validVisaApprovalDocumentShowingYourNameDateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Utility Bill - electricity, gas, telephone with current address (less than 3 months old)`
  String get utilityBillElectricityGasTelephoneWithCurrentAddress {
    return Intl.message(
      'Utility Bill - electricity, gas, telephone with current address (less than 3 months old)',
      name: 'utilityBillElectricityGasTelephoneWithCurrentAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please provide details of one or more of these documents for e-verification. For instant approval, please provide more than one document`
  String get pleaseProvideDetailsOfOneOrMoreOfTheseDocumentsForEVerification {
    return Intl.message(
      'Please provide details of one or more of these documents for e-verification. For instant approval, please provide more than one document',
      name: 'pleaseProvideDetailsOfOneOrMoreOfTheseDocumentsForEVerification',
      desc: '',
      args: [],
    );
  }

  /// `Bank statement with current address (less than 3 months old)`
  String get bankStatementWithCurrentAddress {
    return Intl.message(
      'Bank statement with current address (less than 3 months old)',
      name: 'bankStatementWithCurrentAddress',
      desc: '',
      args: [],
    );
  }

  /// `Australian Driver’s License`
  String get australianDriverLicense {
    return Intl.message(
      'Australian Driver’s License',
      name: 'australianDriverLicense',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name here exactly as it appears on your Driver’s Licence.`
  String get enterYourNameHereExactlyAsItAppearsOnYourDriverLicence {
    return Intl.message(
      'Enter your name here exactly as it appears on your Driver’s Licence.',
      name: 'enterYourNameHereExactlyAsItAppearsOnYourDriverLicence',
      desc: '',
      args: [],
    );
  }

  /// `Please use Upper case/ Lower case characters exactly as they appear on your licence.`
  String
      get pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourLicence {
    return Intl.message(
      'Please use Upper case/ Lower case characters exactly as they appear on your licence.',
      name:
          'pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourLicence',
      desc: '',
      args: [],
    );
  }

  /// `As On Driver's Licence`
  String get asOnDriversLicence {
    return Intl.message(
      'As On Driver\'s Licence',
      name: 'asOnDriversLicence',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your First Name here exactly as it appears on your Driver's Licence`
  String get enterFirstNameAsPerDrivingLicence {
    return Intl.message(
      'Enter Your First Name here exactly as it appears on your Driver\'s Licence',
      name: 'enterFirstNameAsPerDrivingLicence',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Middle Name here exactly as it appears on your Driver's Licence`
  String get enterMiddleNameAsPerDrivingLicence {
    return Intl.message(
      'Enter Your Middle Name here exactly as it appears on your Driver\'s Licence',
      name: 'enterMiddleNameAsPerDrivingLicence',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Last Name here exactly as it appears on your Driver's Licence`
  String get enterLastNameAsPerDrivingLicence {
    return Intl.message(
      'Enter Your Last Name here exactly as it appears on your Driver\'s Licence',
      name: 'enterLastNameAsPerDrivingLicence',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your First Name here exactly as it appears on your Passport`
  String get enterFirstNameAsPerPassport {
    return Intl.message(
      'Enter Your First Name here exactly as it appears on your Passport',
      name: 'enterFirstNameAsPerPassport',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Middle Name here exactly as it appears on your Passport`
  String get enterMiddleNameAsPerPassport {
    return Intl.message(
      'Enter Your Middle Name here exactly as it appears on your Passport',
      name: 'enterMiddleNameAsPerPassport',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Last Name here exactly as it appears on your Passport`
  String get enterLastNameAsPerPassport {
    return Intl.message(
      'Enter Your Last Name here exactly as it appears on your Passport',
      name: 'enterLastNameAsPerPassport',
      desc: '',
      args: [],
    );
  }

  /// `License Number`
  String get licenseNumber {
    return Intl.message(
      'License Number',
      name: 'licenseNumber',
      desc: '',
      args: [],
    );
  }

  /// `Driving Licence Number Can Not Contain more than 10 characters`
  String get drivingLicenseNumberCanNotContain {
    return Intl.message(
      'Driving Licence Number Can Not Contain more than 10 characters',
      name: 'drivingLicenseNumberCanNotContain',
      desc: '',
      args: [],
    );
  }

  /// `Date of Expiry`
  String get dateOfExpiry {
    return Intl.message(
      'Date of Expiry',
      name: 'dateOfExpiry',
      desc: '',
      args: [],
    );
  }

  /// `Issuing Authority`
  String get issuingAuthority {
    return Intl.message(
      'Issuing Authority',
      name: 'issuingAuthority',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get cardNumber {
    return Intl.message(
      'Card Number',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Passport`
  String get passport {
    return Intl.message(
      'Passport',
      name: 'passport',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name here exactly as it appears on your Passport.`
  String get enterYourNameHereExactlyAsItAppearsOnYourPassport {
    return Intl.message(
      'Enter your name here exactly as it appears on your Passport.',
      name: 'enterYourNameHereExactlyAsItAppearsOnYourPassport',
      desc: '',
      args: [],
    );
  }

  /// `Please use Upper case/ Lower case characters exactly as they appear on your passport.`
  String
      get pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourPassport {
    return Intl.message(
      'Please use Upper case/ Lower case characters exactly as they appear on your passport.',
      name:
          'pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourPassport',
      desc: '',
      args: [],
    );
  }

  /// `Passport Number`
  String get passportNumber {
    return Intl.message(
      'Passport Number',
      name: 'passportNumber',
      desc: '',
      args: [],
    );
  }

  /// `Given Name`
  String get givenName {
    return Intl.message(
      'Given Name',
      name: 'givenName',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `As on passport`
  String get asOnPassport {
    return Intl.message(
      'As on passport',
      name: 'asOnPassport',
      desc: '',
      args: [],
    );
  }

  /// `As on Medicare Card`
  String get asOnMedicare {
    return Intl.message(
      'As on Medicare Card',
      name: 'asOnMedicare',
      desc: '',
      args: [],
    );
  }

  /// `Passport Number should contain 7 to 9 characters`
  String get passportNumberCanContain {
    return Intl.message(
      'Passport Number should contain 7 to 9 characters',
      name: 'passportNumberCanContain',
      desc: '',
      args: [],
    );
  }

  /// `Name on your medicare card and it should not contain more than 27 characters`
  String get nameOnYourMedicareCardAndItShouldNotContainMoreThan27characters {
    return Intl.message(
      'Name on your medicare card and it should not contain more than 27 characters',
      name: 'nameOnYourMedicareCardAndItShouldNotContainMoreThan27characters',
      desc: '',
      args: [],
    );
  }

  /// `Medicare card number must contain a minimum of 10 numeric characters`
  String get medicareCardNumberMustContainMinimumOf10NumericCharacters {
    return Intl.message(
      'Medicare card number must contain a minimum of 10 numeric characters',
      name: 'medicareCardNumberMustContainMinimumOf10NumericCharacters',
      desc: '',
      args: [],
    );
  }

  /// `The number to the left of your name on the medicare card`
  String get theNumberToTheLeftOfYourNameOnTheMedicareCard {
    return Intl.message(
      'The number to the left of your name on the medicare card',
      name: 'theNumberToTheLeftOfYourNameOnTheMedicareCard',
      desc: '',
      args: [],
    );
  }

  /// `Medicare Number`
  String get medicareNumber {
    return Intl.message(
      'Medicare Number',
      name: 'medicareNumber',
      desc: '',
      args: [],
    );
  }

  /// `Individual Reference Number`
  String get individualReferenceNumber {
    return Intl.message(
      'Individual Reference Number',
      name: 'individualReferenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Medicare card (this can only be provided as a secondary ID)`
  String get medicareCardThisCanOnlyBeProvidedAsASecondaryID {
    return Intl.message(
      'Medicare card (this can only be provided as a secondary ID)',
      name: 'medicareCardThisCanOnlyBeProvidedAsASecondaryID',
      desc: '',
      args: [],
    );
  }

  /// `Note: If your Medicare card is green, and has only expiry month & year, please enter the date as yyyy-mm-01.`
  String get noteIfYourMedicareCardIsGreen {
    return Intl.message(
      'Note: If your Medicare card is green, and has only expiry month & year, please enter the date as yyyy-mm-01.',
      name: 'noteIfYourMedicareCardIsGreen',
      desc: '',
      args: [],
    );
  }

  /// `Please use Upper case/ Lower case characters exactly as they appear on your medicare.`
  String
      get pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourMedicare {
    return Intl.message(
      'Please use Upper case/ Lower case characters exactly as they appear on your medicare.',
      name:
          'pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourMedicare',
      desc: '',
      args: [],
    );
  }

  /// `Documents Needed`
  String get documentsNeeded {
    return Intl.message(
      'Documents Needed',
      name: 'documentsNeeded',
      desc: '',
      args: [],
    );
  }

  /// `NOT VERIFIED`
  String get notVerified {
    return Intl.message(
      'NOT VERIFIED',
      name: 'notVerified',
      desc: '',
      args: [],
    );
  }

  /// `Looks like your Driver's License and Passport couldn't be validated. Please check the details you have entered, particularly for spelling errors or upper case/ lower case characters, and try again. In addition, please also enter the details of one of the other documents.`
  String get looksLikeYourDriverLicenseAndPassportCouldNotBeValidated {
    return Intl.message(
      'Looks like your Driver\'s License and Passport couldn\'t be validated. Please check the details you have entered, particularly for spelling errors or upper case/ lower case characters, and try again. In addition, please also enter the details of one of the other documents.',
      name: 'looksLikeYourDriverLicenseAndPassportCouldNotBeValidated',
      desc: '',
      args: [],
    );
  }

  /// `Complete this Application in less than 5 minutes and use your account instantly!`
  String
      get completeThisApplicationInLessThan5MinutesAndUseYourAccountInstantly {
    return Intl.message(
      'Complete this Application in less than 5 minutes and use your account instantly!',
      name:
          'completeThisApplicationInLessThan5MinutesAndUseYourAccountInstantly',
      desc: '',
      args: [],
    );
  }

  /// `No files uploaded. Please upload one valid document.`
  String get noFilesUploadedPleaseUploadAtLeastOneValidDocument {
    return Intl.message(
      'No files uploaded. Please upload one valid document.',
      name: 'noFilesUploadedPleaseUploadAtLeastOneValidDocument',
      desc: '',
      args: [],
    );
  }

  /// `Card Color`
  String get cardColor {
    return Intl.message(
      'Card Color',
      name: 'cardColor',
      desc: '',
      args: [],
    );
  }

  /// `Please provide details of one or more of these documents for e-verification. For instant approval, please provide more than one document`
  String get pleaseProvideDetailsOfOneOrMore {
    return Intl.message(
      'Please provide details of one or more of these documents for e-verification. For instant approval, please provide more than one document',
      name: 'pleaseProvideDetailsOfOneOrMore',
      desc: '',
      args: [],
    );
  }

  /// `Select Date of Birth`
  String get selectDateOfBirth {
    return Intl.message(
      'Select Date of Birth',
      name: 'selectDateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Documents uploaded`
  String get documentsUploaded {
    return Intl.message(
      'Documents uploaded',
      name: 'documentsUploaded',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `View profile`
  String get viewProfile {
    return Intl.message(
      'View profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Note: For faster onboarding, please ensure that all the information entered above is accurate & current.`
  String
      get noteForFasterOnBoardingPleaseEnsureThatAllTheInformationEnteredAboveIsAccurateCurrent {
    return Intl.message(
      'Note: For faster onboarding, please ensure that all the information entered above is accurate & current.',
      name:
          'noteForFasterOnBoardingPleaseEnsureThatAllTheInformationEnteredAboveIsAccurateCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Name of village/town/district`
  String get nameOfVillageTown {
    return Intl.message(
      'Name of village/town/district',
      name: 'nameOfVillageTown',
      desc: '',
      args: [],
    );
  }

  /// `Enter NA for Building name, if not applicable`
  String get enterNAForBuildingName {
    return Intl.message(
      'Enter NA for Building name, if not applicable',
      name: 'enterNAForBuildingName',
      desc: '',
      args: [],
    );
  }

  /// `Building number`
  String get buildingNumber {
    return Intl.message(
      'Building number',
      name: 'buildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Flat and Floor Number`
  String get flatAndFloorNumber {
    return Intl.message(
      'Flat and Floor Number',
      name: 'flatAndFloorNumber',
      desc: '',
      args: [],
    );
  }

  /// `Education Qualification`
  String get educationQualification {
    return Intl.message(
      'Education Qualification',
      name: 'educationQualification',
      desc: '',
      args: [],
    );
  }

  /// `Graduation year (Format: YYYY)`
  String get graduationYear {
    return Intl.message(
      'Graduation year (Format: YYYY)',
      name: 'graduationYear',
      desc: '',
      args: [],
    );
  }

  /// `Graduation year (eg:1985)`
  String get graduationYearEg {
    return Intl.message(
      'Graduation year (eg:1985)',
      name: 'graduationYearEg',
      desc: '',
      args: [],
    );
  }

  /// `Enter HKID Number:`
  String get enterHKIDNumber {
    return Intl.message(
      'Enter HKID Number:',
      name: 'enterHKIDNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter HKID Issue Date:`
  String get enterHKIDIssueDate {
    return Intl.message(
      'Enter HKID Issue Date:',
      name: 'enterHKIDIssueDate',
      desc: '',
      args: [],
    );
  }

  /// `Upload Front of HKID`
  String get uploadFrontOfHKID {
    return Intl.message(
      'Upload Front of HKID',
      name: 'uploadFrontOfHKID',
      desc: '',
      args: [],
    );
  }

  /// `Employer`
  String get employer {
    return Intl.message(
      'Employer',
      name: 'employer',
      desc: '',
      args: [],
    );
  }

  /// `Residence country`
  String get residenceCountry {
    return Intl.message(
      'Residence country',
      name: 'residenceCountry',
      desc: '',
      args: [],
    );
  }

  /// `User profile`
  String get userProfile {
    return Intl.message(
      'User profile',
      name: 'userProfile',
      desc: '',
      args: [],
    );
  }

  /// `Invoices are only available for completed transactions`
  String get invoicesAreOnlyAvailableForCompletedTransactions {
    return Intl.message(
      'Invoices are only available for completed transactions',
      name: 'invoicesAreOnlyAvailableForCompletedTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount Payable`
  String get totalAmountPayableWeb {
    return Intl.message(
      'Total Amount Payable',
      name: 'totalAmountPayableWeb',
      desc: '',
      args: [],
    );
  }

  /// `Joint account holder name`
  String get jointAccountHolderName {
    return Intl.message(
      'Joint account holder name',
      name: 'jointAccountHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Please select the verification option`
  String get pleaseSelectTheVerificationOption {
    return Intl.message(
      'Please select the verification option',
      name: 'pleaseSelectTheVerificationOption',
      desc: '',
      args: [],
    );
  }

  /// `By Ref., Sender, or Beneficiary`
  String get searchByRef {
    return Intl.message(
      'By Ref., Sender, or Beneficiary',
      name: 'searchByRef',
      desc: '',
      args: [],
    );
  }

  /// `RTGS Transfers`
  String get rtgsTransfer {
    return Intl.message(
      'RTGS Transfers',
      name: 'rtgsTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Review Bill Details`
  String get reviewBillDetails {
    return Intl.message(
      'Review Bill Details',
      name: 'reviewBillDetails',
      desc: '',
      args: [],
    );
  }

  /// `Amount Due:`
  String get amountDue {
    return Intl.message(
      'Amount Due:',
      name: 'amountDue',
      desc: '',
      args: [],
    );
  }

  /// `Amount Payable:`
  String get amountPayable {
    return Intl.message(
      'Amount Payable:',
      name: 'amountPayable',
      desc: '',
      args: [],
    );
  }

  /// `Access Denied`
  String get accessDenied {
    return Intl.message(
      'Access Denied',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `You are unauthorized to access this sight!. please login again.`
  String get unauthorizedLoginText {
    return Intl.message(
      'You are unauthorized to access this sight!. please login again.',
      name: 'unauthorizedLoginText',
      desc: '',
      args: [],
    );
  }

  /// `Network not available`
  String get networkNotAvailable {
    return Intl.message(
      'Network not available',
      name: 'networkNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection.`
  String get checkYourInternetConnection {
    return Intl.message(
      'Check your internet connection.',
      name: 'checkYourInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `No Data Found`
  String get noDataFound {
    return Intl.message(
      'No Data Found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Old password and new password are same`
  String get oldPasswordAndNewPasswordAreSame {
    return Intl.message(
      'Old password and new password are same',
      name: 'oldPasswordAndNewPasswordAreSame',
      desc: '',
      args: [],
    );
  }

  /// `Recover Your Password`
  String get recoverYourPassword {
    return Intl.message(
      'Recover Your Password',
      name: 'recoverYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Me Email`
  String get sendMeEmail {
    return Intl.message(
      'Send Me Email',
      name: 'sendMeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid account details`
  String get invalidAccountDetails {
    return Intl.message(
      'Invalid account details',
      name: 'invalidAccountDetails',
      desc: '',
      args: [],
    );
  }

  /// `Please retry after few minutes`
  String get pleaseRetryAfterFewMinutes {
    return Intl.message(
      'Please retry after few minutes',
      name: 'pleaseRetryAfterFewMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset Successful`
  String get passwordResetSuccessful {
    return Intl.message(
      'Password Reset Successful',
      name: 'passwordResetSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Your request for password reset is successful. Please check your email to enter a new password`
  String get requestForPasswordResetSuccessfulPleaseCheckEmail {
    return Intl.message(
      'Your request for password reset is successful. Please check your email to enter a new password',
      name: 'requestForPasswordResetSuccessfulPleaseCheckEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new password`
  String get pleaseEnterNewPassword {
    return Intl.message(
      'Please enter new password',
      name: 'pleaseEnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password must contain at least 8 characters with at least one number, one lowercase letter and one uppercase letter.`
  String get passwordValidation {
    return Intl.message(
      'Your password must contain at least 8 characters with at least one number, one lowercase letter and one uppercase letter.',
      name: 'passwordValidation',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient balance, `
  String get insufficientBalance {
    return Intl.message(
      'Insufficient balance, ',
      name: 'insufficientBalance',
      desc: '',
      args: [],
    );
  }

  /// `Please enter promo code`
  String get pleaseEnterPromoCode {
    return Intl.message(
      'Please enter promo code',
      name: 'pleaseEnterPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Choose your payment method`
  String get chooseYourPaymentMethod {
    return Intl.message(
      'Choose your payment method',
      name: 'chooseYourPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Click to Copy`
  String get clickToCopy {
    return Intl.message(
      'Click to Copy',
      name: 'clickToCopy',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copiedText {
    return Intl.message(
      'Copied',
      name: 'copiedText',
      desc: '',
      args: [],
    );
  }

  /// `Please wait until the document is uploaded`
  String get pleaseWaitUntilTheDocumentIsUploaded {
    return Intl.message(
      'Please wait until the document is uploaded',
      name: 'pleaseWaitUntilTheDocumentIsUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Please click on the checkbox above to confirm you have read our Authorization, Terms of Use and Privacy Policy.`
  String get pleaseClickOnTheCheckboxAboveToConfirm {
    return Intl.message(
      'Please click on the checkbox above to confirm you have read our Authorization, Terms of Use and Privacy Policy.',
      name: 'pleaseClickOnTheCheckboxAboveToConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a Password`
  String get pleaseEnterAPassword {
    return Intl.message(
      'Please enter a Password',
      name: 'pleaseEnterAPassword',
      desc: '',
      args: [],
    );
  }

  /// `Branch Code`
  String get branchCode {
    return Intl.message(
      'Branch Code',
      name: 'branchCode',
      desc: '',
      args: [],
    );
  }

  /// `Bank Code`
  String get bankCode {
    return Intl.message(
      'Bank Code',
      name: 'bankCode',
      desc: '',
      args: [],
    );
  }

  /// `PayNow - QR Code`
  String get PayNowQRCodeWithDash {
    return Intl.message(
      'PayNow - QR Code',
      name: 'PayNowQRCodeWithDash',
      desc: '',
      args: [],
    );
  }

  /// `PayNow - UEN`
  String get PayNowUEN {
    return Intl.message(
      'PayNow - UEN',
      name: 'PayNowUEN',
      desc: '',
      args: [],
    );
  }

  /// `Comments for receiver`
  String get commentsForReceiver {
    return Intl.message(
      'Comments for receiver',
      name: 'commentsForReceiver',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ta'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
