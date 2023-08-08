import 'dart:collection';

import 'package:project_ppt_pro/helpers/api_status.dart';
import 'package:project_ppt_pro/models/package.dart';
import 'package:project_ppt_pro/view_models/base_view_model.dart';

class PackagesViewModel extends BaseViewModel {
  List<Package> _packages = [];
  UnmodifiableListView get packages => UnmodifiableListView(_packages);

  Package? _package;
  Package? get package => _package;

  Future<void> getAll() async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.get("/packages");
    if (response is Success) {
      if (response.data == null) {
        setPackages([]);
      } else {
        setPackages(response.data as List<dynamic>);
      }
    }

    if (response is Failure) {
      setErrors(response.data);
    }

    setMessage(response.message ?? "");
    setLoading(false);
  }

  Future<void> searchPackage(
      {required String duration, required String slides}) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    print("getting package");
    var response =
        await api.get("/packages/search?duration=$duration&slides=$slides");
    if (response is Success) {
      setPackage(response.data as Map<String, dynamic>);
    }

    if (response is Failure) {
      setErrors(response.data);
      print(response.data);
    }
    setMessage(response.message ?? "");
    setLoading(false);
  }

  Future<void> update(int packageId, Map<String, String> form) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/packages/$packageId", form);

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

  void setPackages(List<dynamic> packagesJson) {
    _packages =
        packagesJson.map((package) => Package.fromMap(package)).toList();
    notifyListeners();
  }

  void setPackage(Map<String, dynamic> packageJson) {
    _package = Package.fromMap(packageJson);
    notifyListeners();
  }
}
