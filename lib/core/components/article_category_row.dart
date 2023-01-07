import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';

import '../constants/constants.dart';
import '../controllers/category/categories_provider.dart';
import 'app_shimmer.dart';

class ArticleCategoryRow extends ConsumerWidget {
  const ArticleCategoryRow({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategories = ref.watch(categoriesProvider(article.categories));

    return allCategories.map(
        data: (data) {
          final theCategories = allCategories.value ?? [];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                theCategories.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: Chip(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    label: AutoSizeText(
                      theCategories[index].name,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    side: const BorderSide(
                      width: 0.2,
                      color: AppColors.cardColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        loading: (loading) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: AppShimmer(
                      child: Chip(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        label: Text(
                          'Test category',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        side: const BorderSide(
                          width: 0.2,
                          color: AppColors.cardColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        error: (v) => const Text('Test'));
  }
}
