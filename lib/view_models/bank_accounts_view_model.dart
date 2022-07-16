import 'dart:collection';

import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/bank_account.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class BankAccountsViewModel extends BaseViewModel {
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

  Future<void> delete(int bankAccountId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.delete("/bank-accounts/$bankAccountId");

    if (response is Success) {
      await getAll();
      setSuccess(true);
      setFailure(false);
    }

    if (response is Failure) {
      setErrors(response.data);
      setSuccess(false);
      setFailure(true);
    }

    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> create(Map<String, String> form) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.post("/bank-accounts", form);

    if (response is Success) {
      getAll();
      setSuccess(true);
      setFailure(false);
    }

    if (response is Failure) {
      setErrors(response.data);
      setSuccess(false);
      setFailure(true);
    }

    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> update(int bankAccountId, Map<String, String> form) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/bank-accounts/$bankAccountId", form);

    if (response is Success) {
      getAll();
      setSuccess(true);
      setFailure(false);
    }

    if (response is Failure) {
      setErrors(response.data);
      setSuccess(false);
      setFailure(true);
    }

    setLoading(false);
    setMessage(response.message ?? "");
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
