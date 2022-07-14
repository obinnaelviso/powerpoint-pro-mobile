import 'dart:collection';

import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/bank_account.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class BankAccountViewModel extends BaseViewModel {
  List<BankAccount> _bankAccounts = [];
  UnmodifiableListView get bankAccounts => UnmodifiableListView(_bankAccounts);

  BankAccount? _bankAccount;
  BankAccount? get bankAccount => _bankAccount;

  Future<void> getAll() async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.get("/bank-accounts");
    if (response is Success) {
      print("bank account response: ${response.data}");
      if (response.data == null) {
        setBankAccounts([]);
      } else {
        setBankAccounts(response.data as List<dynamic>);
      }
      setSuccess(true);
      setFailure(false);
    }

    if (response is Failure) {
      setErrors(response.data);
      setFailure(true);
      setSuccess(false);
    }

    setMessage(response.message ?? "");
    setLoading(false);
  }

  void setBankAccounts(List<dynamic> bankAccountsJson) {
    _bankAccounts = bankAccountsJson
        .map((bankAccount) => BankAccount.fromMap(bankAccount))
        .toList();
    notifyListeners();
  }

  void setBankAccount(Map<String, dynamic> bankAccountJson) {
    _bankAccount = BankAccount.fromMap(bankAccountJson);
    notifyListeners();
  }
}
