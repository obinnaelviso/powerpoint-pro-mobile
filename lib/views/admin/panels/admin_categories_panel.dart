import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/category.dart';
import 'package:powerpoint_pro/view_models/categories_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/bottom_form_modal.dart';
import 'package:powerpoint_pro/views/components/confirm_box.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:powerpoint_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

import '../../components/error_text.dart';

class AdminCategoriesPanel extends StatefulWidget {
  const AdminCategoriesPanel({Key? key}) : super(key: key);
  static const String title = "Categories";

  @override
  State<AdminCategoriesPanel> createState() => _AdminCategoriesPanelState();
}

class _AdminCategoriesPanelState extends State<AdminCategoriesPanel> {
  dynamic categories = [];

  List<PopupMenuEntry<FormOptions>> getMenuItems(BuildContext context) {
    List<PopupMenuEntry<FormOptions>> menuItems = [];
    menuItems.addAll([
      const PopupMenuItem<FormOptions>(
        value: FormOptions.edit,
        child: Text("Edit"),
      ),
      const PopupMenuItem<FormOptions>(
        value: FormOptions.delete,
        child: Text("Delete"),
      ),
    ]);
    return menuItems;
  }

  void setCategories() async {
    await context.read<CategoriesViewModel>().getAll();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    categories = Provider.of<CategoriesViewModel>(context).categories;

    if (categories.isEmpty) {
      return ModalProgressHUD(
          inAsyncCall: Provider.of<CategoriesViewModel>(context).loading,
          child: const EmptyScreen("There are no categories"));
    } else {
      return ModalProgressHUD(
        inAsyncCall: Provider.of<CategoriesViewModel>(context).loading,
        child: RefreshIndicator(
          onRefresh: () => context.read<CategoriesViewModel>().getAll(),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (lvContext, index) {
              final Category category = categories[index];
              final String title = category.title;
              final String? description = category.description;
              final categoryTitleController = TextEditingController();
              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description ?? ""),
                  trailing: PopupMenuButton<FormOptions>(
                    onSelected: (FormOptions item) async {
                      final categoriesVm = context.read<CategoriesViewModel>();
                      if (item == FormOptions.edit) {
                        categoryTitleController.text = category.title;
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(
                            child: BottomFormModal(
                              loading: Provider.of<CategoriesViewModel>(context)
                                  .loading,
                              action: () async {
                                await categoriesVm.update(category.id,
                                    {"title": categoryTitleController.text});
                                AlertSnack.showAlert(context,
                                    text: categoriesVm.message!,
                                    type: categoriesVm.success
                                        ? AlertSnackTypes.success
                                        : AlertSnackTypes.error);
                                Navigator.pop(context);
                              },
                              actionText: "Update",
                              children: [
                                FormInput(
                                  label: "Category Title",
                                  autofocus: true,
                                  required: true,
                                  controller: categoryTitleController,
                                ),
                                ErrorText(
                                  error:
                                      Provider.of<CategoriesViewModel>(context)
                                          .errors["title"],
                                ),
                              ],
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      } else if (item == FormOptions.delete) {
                        await ConfirmBox.displayDialog(
                          context,
                          title: "Confirm Delete",
                          message: "Are you sure you want to delete this form?",
                          confirmAction: () async {
                            context
                                .read<CategoriesViewModel>()
                                .delete(category.id)
                                .then((value) => AlertSnack.showAlert(context,
                                    text: categoriesVm.message!,
                                    type: categoriesVm.success
                                        ? AlertSnackTypes.success
                                        : AlertSnackTypes.error));
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => getMenuItems(context),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
