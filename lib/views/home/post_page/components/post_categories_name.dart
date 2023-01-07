import 'package:ambientestereo/views/home/post_page/components/save_post_button_alt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../config/wp_config.dart';
import '../../../../core/controllers/category/categories_provider.dart';
import '../../../../core/models/category.dart';

import '../../../../core/components/app_shimmer.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/category/categories_controller.dart';
import '../../../../core/models/article.dart';

class PostCategoriesName extends ConsumerWidget {
  const PostCategoriesName({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategories = ref.watch(categoriesProvider(article.categories));
    return allCategories.map(
      data: (v) {
        final theCategories = allCategories.value ?? [];
        return _CategoryRow(
          allCategories: theCategories,
          article: article,
        );
      },
      error: (v) => const Text('Error occured'),
      loading: (v) => const _LoadingCategories(),
    );
  }
}

class _LoadingCategories extends StatelessWidget {
  const _LoadingCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  const _CategoryRow({
    Key? key,
    required this.allCategories,
    required this.article,
  }) : super(key: key);

  final List<CategoryModel> allCategories;
  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8.0,
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder: (child) => SlideAnimation(
                horizontalOffset: 0,
                verticalOffset: 50,
                child: child,
              ),
              children: List.generate(
                allCategories.length,
                (index) => InkWell(
                  onTap: () {
                    final categories = ref.read(categoriesController.notifier);
                    categories.goToCategoriesPage(
                        context, allCategories[index].id);
                  },
                  child: Chip(
                    padding: const EdgeInsets.all(4.0),
                    labelStyle: Theme.of(context).textTheme.caption,
                    backgroundColor: Theme.of(context).cardColor,
                    label: Html(
                      data: allCategories[index].name,
                      shrinkWrap: true,
                      style: {
                        'body': Style(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          fontSize: const FontSize(12.0),
                          lineHeight: const LineHeight(1.4),
                        ),
                        'figure': Style(
                            margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (article.tags.contains(WPConfig.videoTagID))
          SavePostButtonAlternative(article: article),
      ],
    );
  }
}
