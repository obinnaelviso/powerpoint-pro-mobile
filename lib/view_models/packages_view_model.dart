import 'dart:collection';

import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/package.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class PackagesViewModel extends BaseViewModel {
  List<Category> _packages = [];
  UnmodifiableListView get packages => UnmodifiableListView(_packages);

  Category? _package;
  Category? get package => _package;

  Future<void> getAll() async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.get("/packages");
    if (response is Success) {
      if (response.data == null) {
        setPackages([]);
      } else {
        setPackages(response.data as List<Map<String, dynamic>>);
      }
    }

    if (response is Failure) {
      setErrors(response.data);
    }

    setMessage(response.message ?? "");
    setLoading(false);
  }

  Future<void> searchPackage(
      {required int duration, required int slides}) async {
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

  void setPackages(List<Map<String, dynamic>> packagesJson) {
    _packages =
        packagesJson.map((package) => Category.fromMap(package)).toList();
    notifyListeners();
  }

  void setPackage(Map<String, dynamic> packageJson) {
    _package = Category.fromMap(packageJson);
    notifyListeners();
  }
}
