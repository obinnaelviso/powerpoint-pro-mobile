import 'dart:collection';

import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/package.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class CategoriesViewModel extends BaseViewModel {
  List<Category> _categories = [];
  UnmodifiableListView get categories => UnmodifiableListView(_categories);

  Category? _category;
  Category? get category => _category;

  Future<void> getAll() async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.get("/categories");
    if (response is Success) {
      if (response.data == null) {
        setCategories([]);
      } else {
        setCategories(response.data as List<dynamic>);
      }
    }

    if (response is Failure) {
      setErrors(response.data);
    }

    setMessage(response.message ?? "");
    setLoading(false);
  }

  void setCategories(List<dynamic> categoriesJson) {
    _categories =
        categoriesJson.map((category) => Category.fromMap(category)).toList();
    notifyListeners();
  }
}
