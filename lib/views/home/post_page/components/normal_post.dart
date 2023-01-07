import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/controllers/html/html_matcher.dart';
import '../../../../core/controllers/html/html_renderer.dart';
import 'package:share_plus/share_plus.dart';


import '../../../../config/wp_config.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/analytics/analytics_controller.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/app_utils.dart';
import '../components/more_related_post.dart';
import '../components/post_image_renderer.dart';
import '../components/post_page_body.dart';
import 'save_post_button.dart';

class NormalPost extends StatelessWidget {
  const NormalPost({
    Key? key,
    required this.article,
  }) : super(key: key);
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  article.tags.contains(WPConfig.videoTagID)
                      ? CustomVideoRenderer(article: article)
                      : PostImageRenderer(article: article),
                  AppSizedBox.h10,
                  PostPageBody(article: article),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: MoreRelatedPost(
                      categoryID: article.categories.isNotEmpty
                          ? article.categories.first
                          : 0,
                      currentArticleID: article.id,
                      isSliver: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDefaults.padding),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('go_back'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _NormalPostAppBar(article: article),
        ],
      ),
    );
  }
}

class _NormalPostAppBar extends StatelessWidget {
  const _NormalPostAppBar({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: AppBar(
        backgroundColor: Colors.transparent,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: AppColors.cardColorDark.withOpacity(0.3),
            elevation: 0,
          ),
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.adaptive.arrow_back_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await Share.share(article.link);
              AnalyticsController.logUserContentShare(article);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: AppColors.cardColorDark.withOpacity(0.3),
              elevation: 0,
            ),
            child: const Icon(
              IconlyLight.send,
              color: Colors.white,
              size: 18,
            ),
          ),
          SavePostButton(article: article),
        ],
      ),
    );
  }
}

/// Used for rendering vidoe on top
class CustomVideoRenderer extends StatelessWidget {
  const CustomVideoRenderer({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: article.content,
      tagsList: const ['html', 'body', 'figure', 'video'],
      shrinkWrap: false,
      style: {
        'body': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
        ),
        'figure': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
        ),
      },
      onLinkTap: (String? url, RenderContext renderCtx,
          Map<String, String> attributes, _) {
        if (url != null) {
          AppUtil.openLink(url);
        } else {
          Fluttertoast.showToast(msg: 'Cannot launch this url');
        }
      },
      customRenders: {
        HtmlMatcher.videoMatcher(): HtmlRenderer.videoRenderer(),
        HtmlMatcher.iframeMatcher(): HtmlRenderer.iframeRenderer(),
      },
    );
  }
}
