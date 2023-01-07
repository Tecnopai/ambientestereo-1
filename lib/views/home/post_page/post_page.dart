import 'package:flutter/material.dart';
import 'components/normal_post.dart';

import '../../../config/wp_config.dart';
import '../../../core/models/article.dart';
import 'components/video_post.dart';

class PostPage extends StatelessWidget {
  const PostPage({
    Key? key,
    required this.article,
  }) : super(key: key);
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final isVideoPost = article.tags.contains(WPConfig.videoTagID);
    if (isVideoPost) {
      return VideoPost(article: article);
    } else {
      return NormalPost(article: article);
    }
  }
}
