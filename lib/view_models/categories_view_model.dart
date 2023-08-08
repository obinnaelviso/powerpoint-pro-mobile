import 'dart:collection';

import 'package:project_ppt_pro/helpers/api_status.dart';
import 'package:project_ppt_pro/models/category.dart';
import 'package:project_ppt_pro/view_models/base_view_model.dart';

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

  Future<void> delete(int categoryId) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.delete("/categories/$categoryId");

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

    var response = await api.post("/categories", form);

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

  Future<void> update(int categoryId, Map<String, String> form) async {
    setLoading(true);
    setMessage("");
    setErrors({});

    var response = await api.put("/categories/$categoryId", form);

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

  void setCategories(List<dynamic> categoriesJson) {
    _categories =
        categoriesJson.map((category) => Category.fromMap(category)).toList();
    notifyListeners();
  }
}
