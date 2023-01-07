import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/components/list_view_responsive.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/popular2_posts_controller.dart';
import '../../../../core/models/article.dart';
import 'loading_posts_responsive.dart';

class Popular2PostFetcherSection extends ConsumerWidget {
  const Popular2PostFetcherSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularPosts = ref.watch(popular2PostsController);
    return popularPosts.map(
      data: (data) {
        return PopularPostsList(articles: data.value);
      },
      error: (t) => Center(
        child: Text(t.toString()),
      ),
      loading: (t) => const LoadingPostsResponsive(),
    );
  }
}

class PopularPostsList extends StatelessWidget {
  const PopularPostsList({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding / 2,
      ),
      sliver: ResponsiveListView(
        data: articles,
        handleScrollWithIndex: (v) {},
        isMainPage: true,
      ),
    );
  }
}
