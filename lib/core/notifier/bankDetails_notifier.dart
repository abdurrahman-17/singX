import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/transaction_repository.dart';
import 'package:singx/core/models/request_response/bank_details/bank_details.dart';
import 'package:singx/core/models/request_response/bank_details/bank_details_hk_response.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class BankDetailsNotifier extends BaseChangeNotifier {

  //To Load Initial Data From API and Local Storage
  BankDetailsNotifier() {
    ApiData();
  }

  // String Values
  String _countryData = '';
  String _acNumber = '';
  String _acName = '';
  String _bankName = '';
  String _bankCode = '';
  String _branchCode = '';
  String _acNumberWallet = '';
  String _acNameWallet = '';
  String _bankNameWallet = '';
  String _bankCodeWallet = '';
  String _uenNumberWallet = '';

  // Boolean Values
  bool _copiedWallet = false;
  bool _copiedRemittance = false;

 // Getter and Setter
  String get countryData => _countryData;

  set countryData(String value) {
    if (value == _countryData) return;
    _countryData = value;
    notifyListeners();
  }
  String get branchCode => _branchCode;

  set branchCode(String value) {
    if(value == _branchCode)return;
    _branchCode = value;
    notifyListeners();
  }

  String get uenNumberWallet => _uenNumberWallet;

  set uenNumberWallet(String value) {
    if (value == _uenNumberWallet) return;
    _uenNumberWallet = value;
    notifyListeners();
  }

  String get bankCode => _bankCode;

  String get acNumberWallet => _acNumberWallet;

  set acNumberWallet(String value) {
    if (value == _acNumberWallet) return;
    _acNumberWallet = value;
    notifyListeners();
  }

  set bankCode(String value) {
    if (value == _bankCode) return;
    _bankCode = value;
    notifyListeners();
  }

  bool get copiedWallet => _copiedWallet;

  set copiedWallet(bool value) {
    if (value == _copiedWallet) return;
    _copiedWallet = value;
    notifyListeners();
  }

  bool get copiedRemittance => _copiedRemittance;

  set copiedRemittance(bool value) {
    if (value == _copiedRemittance) return;
    _copiedRemittance = value;
    notifyListeners();
  }

  String get acNumber => _acNumber;

  set acNumber(String value) {
    if (value == _acNumber) return;
    _acNumber = value;
    notifyListeners();
  }

  String get acName => _acName;

  set acName(String value) {
    if (value == _acName) return;
    _acName = value;
    notifyListeners();
  }

  String get bankName => _bankName;

  set bankName(String value) {
    if (value == _bankName) return;
    _bankName = value;
    notifyListeners();
  }

  String get acNameWallet => _acNameWallet;

  set acNameWallet(String value) {
    if(value==_acNameWallet)return;
    _acNameWallet = value;
    notifyListeners();
  }

  String get bankNameWallet => _bankNameWallet;

  set bankNameWallet(String value) {
    if(value==_bankNameWallet)return;
    _bankNameWallet = value;
    notifyListeners();
  }

  String get bankCodeWallet => _bankCodeWallet;

  set bankCodeWallet(String value) {
    if(value==_bankCodeWallet)return;
    _bankCodeWallet = value;
    notifyListeners();
  }

  // Initial Data Load
  ApiData() async {
    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      countryData = value;
      if (value == AppConstants.singapore || value == AppConstants.hongKong) {
        await TransactionRepository().apiSGBankDetails().then((value) {
          if(countryData == AppConstants.singapore) {
            BankDetails bankDetails = BankDetails.fromJson(value);
            acNumber =
            bankDetails.response!.remittanceAccount![0].accountNumber!;
            acName = bankDetails.response!.remittanceAccount![0].accountName!;
            bankName = bankDetails.response!.remittanceAccount![0].bankName!;
            bankCode = bankDetails.response!.remittanceAccount![0].bankCode!;
            acNumberWallet =
            bankDetails.response!.walletAccount!.accountNumber!;
            acNameWallet = bankDetails.response!.walletAccount!.accountName!;
            bankNameWallet = bankDetails.response!.walletAccount!.bankName!;
            bankCodeWallet = bankDetails.response!.walletAccount!.bankCode!;
            uenNumberWallet = bankDetails.response!.walletAccount!.uenNumber!;
          }else if(countryData == AppConstants.hongKong){
            BankDetailsHkResponse bankDetailsHkResponse = BankDetailsHkResponse.fromJson(value);
            acNumber =
            bankDetailsHkResponse.response!.data![0].accountNumber!;
            acName = bankDetailsHkResponse.response!.data![0].accountName!;
            bankName = bankDetailsHkResponse.response!.data![0].bankName!;
            bankCode = bankDetailsHkResponse.response!.data![0].bankCode!;
            branchCode = bankDetailsHkResponse.response!.data![0].branchCode!;
          }
        });
      }
    });
  }
}
