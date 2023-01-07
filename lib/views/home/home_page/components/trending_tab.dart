import 'package:ambientestereo/views/home/home_page/components/popular2_posts_list.dart';
import 'package:ambientestereo/views/home/home_page/components/popular3_posts_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/components/headline_with_row.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/feature_post_controller.dart';
import '../../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../../core/controllers/posts/recent_posts_controller.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/responsive.dart';
import 'popular_posts_list.dart';
import 'post_slider.dart';
import 'post_slider_tablet.dart';
import 'recent_post_list.dart';

class TrendingTabSection extends ConsumerWidget {

  const TrendingTabSection({
    Key? key,
    required this.featuredPosts,
  }) : super(key: key);

  final List<ArticleModel> featuredPosts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).cardColor,
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(featurePostController.future);
          await ref.refresh(popularPostsController.future);
          await ref.read(recentPostController.notifier).onRefresh();
          Fluttertoast.showToast(msg: 'refreshed'.tr() );
        },
        child: CustomScrollView(
          slivers: [
            /* <---- Featured News -----> */

            SliverPadding(
              padding: const EdgeInsets.only(top: AppDefaults.padding),
              sliver: SliverToBoxAdapter(

                child: Responsive(
                  mobile: PostSlider(articles: featuredPosts),
                  tablet: PostSliderTablet(articles: featuredPosts),
                ),
   
              ),
            ),

             /* <---- popular_posts1 -----> */
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: HeadlineRow(
                  headline: 'Últimas noticias',
                  isHeader: false,
                ),
              ),
            ),
            const RecentPostFetcherSection(),

            const SliverToBoxAdapter(child: Divider()),
            /* <---- popular_posts2 -----> */
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: HeadlineRow(
                  headline: 'Lo más leído',
                  isHeader: false,
                ),
              ),
            ),

            const PopularPostFetcherSection(),

            const SliverToBoxAdapter(child: Divider()),
            /* <---- popular_posts3 -----> */
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: HeadlineRow(
                  headline: 'Lo más oído',
                  isHeader: false,
                ),
              ),
            ),

            const Popular2PostFetcherSection(),

            const SliverToBoxAdapter(child: Divider()),
            /* <---- popular_posts4 -----> */
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: HeadlineRow(
                  headline: 'Verde tierra',
                  isHeader: false,
                ),
              ),
            ),

            const Popular3PostFetcherSection(),            
            
            const SliverToBoxAdapter(child: Divider()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: Html(
                            data: getCurrentDate(),
                            style: {
                              'body': Style(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                fontSize: _articleTileFont(context),
                                lineHeight: const LineHeight(1.4),
                                fontWeight: FontWeight.bold,
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              'figure': Style(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero),
                            },
                          ),
              )
            ),

            const SliverToBoxAdapter(child: Divider(
              height: 130.0,
            )),

          ],
        ),
      ),
    );
  }
}

String getCurrentDate() {
       return '© Todos los derechos reservados Ambiente Stereo 88.4FM ${DateFormat('yyyy').format(DateTime.now()).toString()}';
}

  FontSize _articleTileFont(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const FontSize(15);
    } else if (Responsive.isTabletPortrait(context)) {
      return const FontSize(16);
    } else if (Responsive.isTablet(context)) {
      return const FontSize(17);
    } else {
      return const FontSize(15);
    }
  }