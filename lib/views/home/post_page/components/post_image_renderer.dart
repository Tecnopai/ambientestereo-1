import 'package:flutter/material.dart';

import '../../../../core/components/network_image.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/article.dart';

class PostImageRenderer extends StatelessWidget {
  const PostImageRenderer({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppDefaults.aspectRatio,
      child: Hero(
        tag: article.heroTag,
        child: NetworkImageWithLoader(
          article.featuredImage,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.zero,
          placeHolder: _PlaceHolderArticleImage(article: article),
        ),
      ),
    );
  }
}

class _PlaceHolderArticleImage extends StatelessWidget {
  const _PlaceHolderArticleImage({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NetworkImageWithLoader(
          article.thumbnail,
          borderRadius: BorderRadius.zero,
        ),
        const Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
