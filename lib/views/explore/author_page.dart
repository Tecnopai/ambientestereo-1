import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/components/list_view_responsive.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/author_post_controllers.dart';
import '../../core/controllers/users/user_data_controller.dart';
import '../../core/models/author.dart';
import '../home/home_page/components/loading_posts_responsive.dart';

class AuthorPostPage extends ConsumerWidget {
  const AuthorPostPage({
    Key? key,
    required this.authorID,
  }) : super(key: key);

  final int authorID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorData = ref.watch(userDataProvider(authorID));

    return authorData.map(
        data: (data) {
          if (data.value != null) {
            return _AuthorDataSection(
              authorData: data.value!,
              auhtorID: authorID,
            );
          } else {
            return const _ErrorMessage();
          }
        },
        error: (t) => const _ErrorMessage(),
        loading: (c) => const LoadingAuthorData());
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Something Error Happened'),
          ),
          AppSizedBox.h16,
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(IconlyLight.arrowRight),
            label: Text('go_back'.tr()),
          )
        ],
      ),
    );
  }
}

class _AuthorDataSection extends ConsumerWidget {
  const _AuthorDataSection({
    required this.authorData,
    required this.auhtorID,
    Key? key,
  }) : super(key: key);

  final AuthorData authorData;
  final int auhtorID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorPost = ref.watch(authorPostController(auhtorID));
    final controller = ref.watch(authorPostController(auhtorID).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(authorData.name),
        actions: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(authorData.avatarUrl),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          authorPost.initialLoaded
              ? ResponsiveListView(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  data: authorPost.posts,
                  handleScrollWithIndex: controller.handleScrollWithIndex,
                )
              : const LoadingPostsResponsive(),
          if (authorPost.isPaginationLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: AppColors.primary, size: 36),
              ),
            ),
        ],
      ),
    );
  }
}

class LoadingAuthorData extends StatelessWidget {
  const LoadingAuthorData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading...'),
      ),
      body: const LoadingPostsResponsive(isInSliver: false),
    );
  }
}
