import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'article_html_converter.dart';
import 'view_on_webiste_button.dart';

import '../../../../config/wp_config.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/article.dart';
import 'post_categories_name.dart';
import 'post_meta_data.dart';
import 'post_report_button.dart';
import 'post_tags.dart';

class PostPageBody extends StatelessWidget {
  const PostPageBody({Key? key, required this.article}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!article.tags.contains(WPConfig.videoTagID)) AppSizedBox.h16,

        /// Post Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder: (child) => SlideAnimation(
                  duration: AppDefaults.duration,
                  verticalOffset: 50.0,
                  horizontalOffset: 0,
                  child: child,
                ),
                children: [
                  FittedBox(
                    child: Html(
                      data: article.title,
                      style: {
                        'body': Style(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          fontSize: const FontSize(25.0),
                          lineHeight: const LineHeight(1.4),
                          fontWeight: FontWeight.bold,
                        ),
                        'figure': Style(
                            margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                      },
                    ),
                  ),
                  AppSizedBox.h10,
                  PostMetaData(article: article),
                  PostCategoriesName(article: article),
                  ArticleHtmlConverter(article: article),
                  ArticleTags(article: article),
                  AppSizedBox.h15,
                  Wrap(
                    children: [
                      ViewOnWebsite(article: article),
                      const SizedBox(width: AppDefaults.padding),
                      PostReportButton(article: article),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

        AppSizedBox.h10,
        const Divider(height: 0),
      ],
    );
  }
}
