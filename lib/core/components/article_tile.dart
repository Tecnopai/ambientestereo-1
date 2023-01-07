import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../repositories/posts/post_repository.dart';

import '../../../../core/constants/constants.dart';
import '../../config/wp_config.dart';
import '../controllers/analytics/analytics_controller.dart';
import '../models/article.dart';
import '../routes/app_routes.dart';
import '../utils/responsive.dart';
import 'network_image.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    Key? key,
    required this.article,
    this.isMainPage = false,
  }) : super(key: key);

  final ArticleModel article;
  final bool isMainPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDefaults.margin / 2),
      child: Material(
        color: isMainPage
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).canvasColor,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.post,
              arguments: article,
            );

            /// Logging
            AnalyticsController.logPostView(article);
            PostRepository.addViewsToPost(postID: article.id);
          },
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: AppDefaults.boxShadow,
            ),
            child: Row(
              children: [
                // thumbnail
                Expanded(
                  flex: 3,
                  child: VideoArticleWrapper(
                    isVideoArticle: article.tags.contains(WPConfig.videoTagID),
                    child: Hero(
                      tag: article.heroTag,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppDefaults.radius),
                          bottomLeft: Radius.circular(AppDefaults.radius),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: NetworkImageWithLoader(article.thumbnail),
                        ),
                      ),
                    ),
                  ),
                ),
                // Description
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Html(
                            data: article.title,
                            style: {
                              'body': Style(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                fontSize: _articleTileFont(context),
                                lineHeight: const LineHeight(1.4),
                                fontWeight: FontWeight.bold,
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                              'figure': Style(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero),
                            },
                          ),
                        ),

                        /* <---- Category List -----> */
                        /*
                        ArticleCategoryRow(article: article),
                        Row(
                          children: [
                            const Icon(
                              IconlyLight.timeCircle,
                              color: AppColors.placeholder,
                              size: 18,
                            ),
                            AppSizedBox.w5,
                            Text(
                              '${AppUtil.totalMinute(article.content, context)} ${'minute_read'.tr()}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        */
                        AppSizedBox.h5,
                        Row(
                          children: [
                            const Icon(
                              IconlyLight.calendar,
                              color: AppColors.placeholder,
                              size: 18,
                            ),
                            AppSizedBox.w5,
                            
                            Text(
                              DateFormat.yMMMMd(context.locale.toLanguageTag())
                                  .format(article.date),
                              style: Theme.of(context).textTheme.caption,
                            ),
    
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FontSize _articleTileFont(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const FontSize(30);
    } else if (Responsive.isTabletPortrait(context)) {
      return const FontSize(48);
    } else if (Responsive.isTablet(context)) {
      return const FontSize(65);
    } else {
      return const FontSize(25);
    }
  }
}

class VideoArticleWrapper extends StatelessWidget {
  const VideoArticleWrapper({
    Key? key,
    required this.isVideoArticle,
    required this.child,
  }) : super(key: key);

  final bool isVideoArticle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVideoArticle)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
