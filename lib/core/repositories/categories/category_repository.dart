import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/category.dart';

final categoriesRepoProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepository();
});

abstract class CategoriesRepoAbstract {
  /// Gets all the category from the website
  Future<List<CategoryModel>> getAllCategory();

  /// Get Single Category
  Future<CategoryModel?> getCategory(int id);

  /// Get These Categories
  Future<List<CategoryModel>> getTheseCategories(List<int> ids);

  /// Get All Parent Categories
  Future<List<CategoryModel>> getAllParentCategories(int page);

  /// Get All Sub Categories
  Future<List<CategoryModel>> getAllSubcategories(
      {required int page, required int parentId});
}

class CategoriesRepository extends CategoriesRepoAbstract {
  @override
  Future<List<CategoryModel>> getAllCategory() async {
    final client = http.Client();
    String url = 'https://${WPConfig.url}/wp-json/wp/v2/categories/';
    List<CategoryModel> allCategories = [];
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {}
      final allData = jsonDecode(response.body) as List;
      allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
      allCategories = _removeBlockedCategories(allCategories);
      // debugPrint(allCategories.toString());
      return allCategories;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      client.close();
    }
  }

  @override
  Future<CategoryModel?> getCategory(int id) async {
    final client = http.Client();
    String url = 'https://${WPConfig.url}/wp-json/wp/v2/categories/$id';
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    } finally {
      client.close();
    }
  }

  /// Removes Blocked Categories defined in [WPConfig]
  List<CategoryModel> _removeBlockedCategories(List<CategoryModel> data) {
    final blockedData = WPConfig.blockedCategoriesIds;
    for (var blockedID in blockedData) {
      data.removeWhere((element) => element.id == blockedID);
    }
    return data;
  }

  @override
  Future<List<CategoryModel>> getTheseCategories(List<int> ids) async {
    List<CategoryModel> allCategories = [];
    if (ids.isEmpty) {
      return allCategories;
    } else if (ids.length <= 10) {
      final categories = ids.join(',');
      final url =
          'https://${WPConfig.url}/wp-json/wp/v2/categories?include=$categories';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final allData = jsonDecode(response.body) as List;
          allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
          allCategories = _removeBlockedCategories(allCategories);
          return allCategories;
        } else {
          debugPrint(response.body);
          return allCategories;
        }
      } catch (e) {
        debugPrint(e.toString());
        return allCategories;
      }
    } else {
      for (var i = 0; i < ids.length; i++) {
        final url =
            'https://${WPConfig.url}/wp-json/wp/v2/categories/${ids[i]}';
        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            allCategories.add(CategoryModel.fromJson(response.body));
          } else {}
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      return allCategories;
    }
  }

  @override
  Future<List<CategoryModel>> getAllParentCategories(int page) async {
    final client = http.Client();
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/categories/?parent=0&page=$page';
    List<CategoryModel> allCategories = [];
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {}
      final allData = jsonDecode(response.body) as List;
      allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
      allCategories = _removeBlockedCategories(allCategories);
      // debugPrint(allCategories.toString());
      return allCategories;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      client.close();
    }
  }

  @override
  Future<List<CategoryModel>> getAllSubcategories({
    required int page,
    required int parentId,
  }) async {
    final client = http.Client();
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/categories/?parent=$parentId&page=$page';
    List<CategoryModel> allCategories = [];
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {}
      final allData = jsonDecode(response.body) as List;
      allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
      allCategories = _removeBlockedCategories(allCategories);
      // debugPrint(allCategories.toString());
      return allCategories;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      client.close();
    }
  }
}
