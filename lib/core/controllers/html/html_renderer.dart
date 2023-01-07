import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../components/network_image.dart';

import '../../../config/app_images_config.dart';
import '../../components/app_video.dart';
import '../../components/skeleton.dart';

class HtmlRenderer {
  /// Video Renderer
  static CustomRender videoRenderer({bool isFullScreenAvailable = true}) {
    return CustomRender.widget(
      widget: (RenderContext renderContext, data) {
        try {
          final src = renderContext.tree.element!.attributes['src'].toString();

          if (src.contains('youtube')) {
            return AppVideo(url: src, type: 'youtube');
          } else if (src.contains('vimeo')) {
            return AppVideo(url: src, type: 'vimeo');
          } else {
            return AppVideo(
              url: renderContext.tree.element!.attributes['src'].toString(),
              type: 'network',
            );
          }
        } on Exception {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: NetworkImageWithLoader(AppImagesConfig.noImageUrl),
          );
        }
      },
    );
  }

  /// Iframe Renderer
  static CustomRender iframeRenderer() {
    return CustomRender.widget(widget: (context1, children) {
      final String videoSource =
          context1.tree.element!.attributes['src'].toString();
      if (videoSource.contains('youtube')) {
        return AppVideo(url: videoSource, type: 'youtube');
      } else if (videoSource.contains('vimeo')) {
        return AppVideo(url: videoSource, type: 'vimeo');
      } else {
        return const AspectRatio(
          aspectRatio: 16 / 9,
          child: NetworkImageWithLoader(AppImagesConfig.noImageUrl),
        );
      }
    });
  }

  static CustomRender imageRenderer() {
    return CustomRender.widget(
      widget: (RenderContext renderContext, data) {
        final src = renderContext.tree.element?.attributes['src'].toString();
        return CachedNetworkImage(
          imageUrl: src ?? AppImagesConfig.noImageUrl,
          placeholder: (context, url) => const AspectRatio(
            aspectRatio: 16 / 9,
            child: Skeleton(),
          ),
        );
      },
    );
  }
}
