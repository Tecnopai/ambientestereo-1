import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_images_config.dart';
import '../../../config/wp_config.dart';
import '../../../views/explore/category_page.dart';
import '../../models/category.dart';
import '../../repositories/categories/category_repository.dart';
import '../../routes/app_routes.dart';
import '../analytics/analytics_controller.dart';

final categoriesController =
    StateNotifierProvider<CategoriesNotifier, List<CategoryModel>>((ref) {
  return CategoriesNotifier();
});

class CategoriesNotifier extends StateNotifier<List<CategoryModel>> {
  CategoriesNotifier() : super([]) {
    {
      getAllCategories();
    }
  }

  final _repo = CategoriesRepository();

  final CategoryModel _featureCategory = CategoryModel(
    id: 0, // ignored
    name: WPConfig.featureCategoryName,
    slug: '', // ignored
    link: '', // ignored
    parent: 0, // ignored,
    thumbnail: AppImagesConfig.defaultCategoryImage,
  );

  final CategoryModel _featureCategory4 = CategoryModel(
    id: 0, // ignored
    name: WPConfig.featureCategoryName4,
    slug: '', // ignored
    link: '', // ignored
    parent: 0, // ignored,
    thumbnail: AppImagesConfig.defaultCategoryImage,
  );

  final CategoryModel _featureCategory5 = CategoryModel(
    id: 0, // ignored
    name: WPConfig.featureCategoryName5,
    slug: '', // ignored
    link: '', // ignored
    parent: 0, // ignored,
    thumbnail: AppImagesConfig.defaultCategoryImage,
  );

  final CategoryModel _featureCategory6 = CategoryModel(
    id: 0, // ignored
    name: WPConfig.featureCategoryName6,
    slug: '', // ignored
    link: '', // ignored
    parent: 0, // ignored,
    thumbnail: AppImagesConfig.defaultCategoryImage,
  );


  Future<List<CategoryModel>> getAllCategories() async {
    final data = await _repo.getAllCategory();
    data.insert(0, _featureCategory);
    //data.insert(4, _featureCategory4);
    //data.insert(5, _featureCategory5);
    //data.insert(6, _featureCategory6);
    state = data;
    return state;
  }

  List<CategoryModel> getAllParentCategories() {
    List<CategoryModel> allParentCategories = [];

    final categories = state;
    categories.removeWhere((element) => element == _featureCategory);
    categories.removeWhere((element) => element == _featureCategory4);
    categories.removeWhere((element) => element == _featureCategory5);
    categories.removeWhere((element) => element == _featureCategory6);

    allParentCategories =
        categories.where((element) => element.parent == 0).toList();

    return allParentCategories;
  }







  List<CategoryModel> getAllSubCategories(int parentCategory) {
    List<CategoryModel> allSubCategories = [];

    allSubCategories =
        state.where((element) => element.parent == parentCategory).toList();

    debugPrint(allSubCategories.toString());

    return allSubCategories;
  }

  Future<List<CategoryModel>> getAllFeatureCategories() async {
    List<CategoryModel> categories = [];

    if (WPConfig.homeCategories.isNotEmpty) {
      WPConfig.homeCategories.forEach((id, name) {
        categories.add(
          CategoryModel(
            id: id,
            name: name,
            slug: '',
            link: '',
            parent: 0,
            thumbnail: AppImagesConfig.defaultCategoryImage,
          ),
        );
      });
    } else {
      categories = await _repo.getAllCategory();
    }

    categories.insert(0, _featureCategory);

    categories.insert(4, _featureCategory4);

    categories.insert(5, _featureCategory5);

    categories.insert(5, _featureCategory6);

    return categories;
  }

  addCategories(List<CategoryModel> data) {
    for (var element in data) {
      if (state.contains(element)) {
      } else {
        state = [...state, element];
      }
    }
  }

  Future<List<CategoryModel>> getTheseCategories(List<int> ids) async {
    List<CategoryModel> foundCategories = [];
    List<CategoryModel> notFoundCategories = [];
    List<CategoryModel> allCategories = [];
    List<int> notFoundIds = [];

    for (var id in ids) {
      final index = state.indexWhere((element) => element.id == id);
      if (index == -1) {
        notFoundIds.add(id);
      } else {
        final localCategories = state;
        final singleName =
            localCategories.singleWhere((element) => element.id == id);
        foundCategories.add(singleName);
      }
    }

    notFoundCategories = await _repo.getTheseCategories(notFoundIds);

    allCategories = [...foundCategories, ...notFoundCategories];

    addCategories(notFoundCategories);

    return allCategories;
  }

  /// Go to categories Page
  void goToCategoriesPage(BuildContext context, int id) {
    final data = state.where((element) => element.id == id);

    if (data.isNotEmpty) {
      final arguments = CategoryPageArguments(
        category: data.first,
        backgroundImage: data.first.thumbnail,
      );
      Navigator.pushNamed(
        context,
        AppRoutes.category,
        arguments: arguments,
      );
      AnalyticsController.logCategoryView(arguments.category);
    }
  }
}
