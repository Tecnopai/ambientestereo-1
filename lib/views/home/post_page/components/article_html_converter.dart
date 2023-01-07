import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/controllers/html/html_matcher.dart';
import '../../../../core/controllers/html/html_renderer.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/app_utils.dart';
import 'view_image_full_screen.dart';

class ArticleHtmlConverter extends StatelessWidget {
  const ArticleHtmlConverter({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: article.content,
      shrinkWrap: false,
      style: {
        'body': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          fontSize: const FontSize(16.0),
          lineHeight: const LineHeight(1.4),
        ),
        'figure': Style(margin: EdgeInsets.zero, padding: EdgeInsets.zero),
        'table': Style(
          backgroundColor: Theme.of(context).cardColor,
        ),
        'tr': Style(
          border: const Border(bottom: BorderSide(color: Colors.grey)),
        ),
        'th': Style(
          padding: const EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        'td': Style(
          padding: const EdgeInsets.all(6),
          alignment: Alignment.topLeft,
        ),
      },
      onImageTap: (String? url, RenderContext context1,
          Map<String, String> attributes, _) {
        if (url != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewImageFullScreen(url: url),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'Can\'t find image link');
        }
      },
      customRenders: {
        tableMatcher(): tableRender(),
        svgTagMatcher(): svgTagRender(),
        svgDataUriMatcher(): svgDataImageRender(),
        svgAssetUriMatcher(): svgAssetImageRender(),
        svgNetworkSourceMatcher(): svgNetworkImageRender(),
        audioMatcher(): audioRender(),
        HtmlMatcher.videoMatcher(): HtmlRenderer.videoRenderer(
          isFullScreenAvailable: false,
        ),
        HtmlMatcher.iframeMatcher(): HtmlRenderer.iframeRenderer(),
        HtmlMatcher.imageMatcher(): HtmlRenderer.imageRenderer(),
      },
      onLinkTap: (url, renderCtx, _, __) {
        if (url == null) {
          Fluttertoast.showToast(msg: 'Error parsing url');
        } else {
          AppUtil.openLink(url);
        }
      },
    );
  }
}
