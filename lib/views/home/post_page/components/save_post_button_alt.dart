import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/saved_post_controller.dart';
import '../../../../core/models/article.dart';

class SavePostButtonAlternative extends ConsumerWidget {
  const SavePostButtonAlternative({
    Key? key,
    required this.article,
    this.iconSize = 18,
  }) : super(key: key);

  final ArticleModel article;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedPostController);
    bool isSaved = saved.posts.contains(article);
    bool isSaving = ref.watch(savedPostController).isSavingPost;

    return OutlinedButton(
      onPressed: () async {
        if (isSaved) {
          await ref
              .read(savedPostController.notifier)
              .removePostFromSaved(article.id);
          Fluttertoast.showToast(msg: 'article_removed_message'.tr());
        } else {
          await ref.read(savedPostController.notifier).addPostToSaved(article);
          Fluttertoast.showToast(msg: 'article_saved_message'.tr());
        }
      },
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        foregroundColor: isSaved ? Colors.red : AppColors.placeholder,
        side: BorderSide(color: isSaved ? Colors.red : AppColors.placeholder),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 0,
      ),
      child: AnimatedSize(
        duration: AppDefaults.duration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSaved ? IconlyBold.heart : IconlyLight.heart,
              color: isSaved ? Colors.red : AppColors.placeholder,
              size: iconSize,
            ),
            AppSizedBox.w5,
            Text(
              isSaving
                  ? 'Loading...'
                  : isSaved
                      ? 'saved'.tr()
                      : 'Add To Favourite',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}
