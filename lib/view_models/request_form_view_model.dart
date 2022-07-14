import 'dart:collection';
import 'dart:io';

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
      if (response.data == null) {
        setRequestForms([]);
      } else {
        setRequestForms(response.data as List<dynamic>);
      }
      setSuccess(true);
      setFailure(false);
    }

    if (response is Failure) {
      setErrors(response.data);
      setFailure(true);
      setSuccess(false);
    }
    setLoading(false);
  }

  Future<void> getSingle(int id) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.get("/request-forms/$id");
    if (response is Success) {
      setRequestForm(response.data as Map<String, dynamic>);
    }

    if (response is Failure) {
      setErrors(response.data);
    }
    setMessage(response.message ?? "");
    setLoading(false);
  }

  Future<void> create(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.post("/request-forms", credentials);

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

  Future<void> uploadReceipt(int requestFormId, File file) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.multipart(
        "/request-forms/$requestFormId/upload-receipt", file);

    if (response is Success) {
      getAll();
      setMessage("Payment receipt uploaded successfully. Awaiting approval!");
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

  Future<void> approve(int requestFormId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/request-forms/$requestFormId/approve", {});

    if (response is Success) {
      await getAll(isUser: false);
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

  Future<void> cancel(int requestFormId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/request-forms/$requestFormId/cancel", {});

    if (response is Success) {
      await getAll(isUser: false);
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

  Future<void> complete(int requestFormId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/request-forms/$requestFormId/complete", {});

    if (response is Success) {
      await getAll(isUser: false);
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

  Future<void> pending(int requestFormId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/request-forms/$requestFormId/pending", {});

    if (response is Success) {
      await getAll(isUser: false);
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

  Future<void> download(String downloadUrl) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.get(
      downloadUrl,
      rawUrl: true,
    );

    if (response is Success) {
      await getAll(isUser: false);
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

  Future<void> delete(int requestFormId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.delete("/request-forms/$requestFormId");

    if (response is Success) {
      await getAll(isUser: false);
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

  void setRequestForms(List<dynamic> requestFormsJson) {
    _requestForms = requestFormsJson
        .map((requestForm) => RequestForm.fromMap(requestForm))
        .toList();
    notifyListeners();
  }

  void setRequestForm(Map<String, dynamic> requestFormJson) {
    _requestForm = RequestForm.fromMap(requestFormJson);
    notifyListeners();
  }
}
