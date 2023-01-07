import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/components/app_shimmer.dart';
import '../../core/controllers/category/sub_categories_.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../core/components/list_view_responsive.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/category/categories_controller.dart';
import '../../core/controllers/posts/categories_post_controller.dart';
import '../../core/controllers/posts/post_pagination_class.dart';
import '../../core/models/category.dart';
import '../home/home_page/components/loading_posts_responsive.dart';
import 'components/empty_categories.dart';

class CategoryPageArguments {
  final CategoryModel category;
  final String backgroundImage;
  CategoryPageArguments({
    required this.category,
    required this.backgroundImage,
  });
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final CategoryPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leadingWidth: MediaQuery.of(context).size.width * 0.2,
              expandedHeight: MediaQuery.of(context).size.height * 0.20,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Html(
                  data: arguments.category.name,
                  style: {
                    'body': Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      fontSize: const FontSize(16.0),
                      lineHeight: const LineHeight(1.4),
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                    ),
                    'figure': Style(
                        margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                  },
                ),
                expandedTitleScale: 2,
                centerTitle: true,
                background: AspectRatio(
                  aspectRatio: AppDefaults.aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          arguments.backgroundImage,
                        ),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SubCategories(categoryId: arguments.category.id),
            CategoriesArticles(
              arguments: CategoryPostsArguments(
                categoryId: arguments.category.id,
                isHome: false,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(color: Theme.of(context).cardColor),
            )
          ],
        ),
      ),
    );
  }
}

class SubCategories extends ConsumerWidget {
  const SubCategories({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  final int categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subCategories = ref.watch(subCategoriesController(categoryId));
    final controller = ref.watch(subCategoriesController(categoryId).notifier);

    if (!subCategories.initialLoaded) {
      return const _LoadingSubCategories();
    } else if (subCategories.refershError) {
      return SliverToBoxAdapter(child: Text(subCategories.errorMessage));
    } else if (subCategories.items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    } else {
      return _AllSubCategories(
        subcategories: subCategories.items,
        handleScrollWithIndex: controller.handleScrollWithIndex,
      );
    }
  }
}

class _AllSubCategories extends ConsumerWidget {
  const _AllSubCategories({
    Key? key,
    required this.subcategories,
    required this.handleScrollWithIndex,
  }) : super(key: key);

  final List<CategoryModel> subcategories;
  final void Function(int index) handleScrollWithIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 0,
              children: List.generate(
                subcategories.length,
                (index) {
                  return InkWell(
                    onTap: () {
                      ref
                          .read(categoriesController.notifier)
                          .goToCategoriesPage(context, subcategories[index].id);
                    },
                    child: Chip(
                      label: Text(
                        '# ${subcategories[index].name}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 5,
          ),
        ],
      ),
    );
  }
}

class _LoadingSubCategories extends StatelessWidget {
  const _LoadingSubCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 0,
              children: List.generate(
                3,
                (index) => AppShimmer(
                  child: Chip(
                    label: Text(
                      '# A Name',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 5,
          ),
        ],
      ),
    );
  }
}

class CategoriesArticles extends ConsumerWidget {
  const CategoriesArticles({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final CategoryPostsArguments arguments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginationController = ref.watch(categoryPostController(arguments));
    final controller = ref.watch(categoryPostController(arguments).notifier);

    if (paginationController.refershError) {
      return SliverToBoxAdapter(
        child: Center(child: Text(paginationController.errorMessage)),
      );

      /// on Initial State it will be empty
    } else if (paginationController.initialLoaded == false) {
      return const LoadingPostsResponsive();
    } else if (paginationController.posts.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyCategoriesList());
    } else {
      return MultiSliver(
        children: [
          CategoriesArticlesList(
            controller: controller,
            paginationController: paginationController,
          ),
          if (paginationController.isPaginationLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.primary, size: 36),
              ),
            ),
        ],
      );
    }
  }
}

class CategoriesArticlesList extends StatelessWidget {
  const CategoriesArticlesList({
    Key? key,
    required CategoryPostsController controller,
    required PostPagination paginationController,
  })  : _controller = controller,
        _paginationController = paginationController,
        super(key: key);

  final CategoryPostsController _controller;
  final PostPagination _paginationController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      sliver: ResponsiveListView(
        data: _paginationController.posts,
        handleScrollWithIndex: _controller.handleScrollWithIndex,
      ),
    );
  }
}
