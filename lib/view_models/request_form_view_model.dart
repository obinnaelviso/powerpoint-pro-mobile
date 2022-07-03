import 'dart:collection';

import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/request_form.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class RequestFormViewModel extends BaseViewModel {
  List<RequestForm> _requestForms = [];
  UnmodifiableListView get requestForms => UnmodifiableListView(_requestForms);

  RequestForm? _requestForm;
  RequestForm? get requestForm => _requestForm;

  Future<void> getAll({bool isUser = true}) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    String url = "";
    if (isUser) {
      url = "/request-forms";
    } else {
      url = "/request-forms/all";
    }
    var response = await api.get(url);
    if (response is Success) {
      setRequestForms(response.data as List<Map<String, dynamic>>);
    }

    if (response is Failure) {
      setErrors(response.data);
    }
  }

  Future<void> getSingle(int id) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    String url = "";
    var response = await api.get(url);
    if (response is Success) {
      setRequestForms(response.data as List<Map<String, dynamic>>);
    }

    if (response is Failure) {
      setErrors(response.data);
    }
  }

  void setRequestForms(List<Map<String, dynamic>> requestFormsJson) {
    _requestForms = requestForms
        .map((requestForm) => RequestForm.fromMap(requestForm))
        .toList();
    notifyListeners();
  }
}
