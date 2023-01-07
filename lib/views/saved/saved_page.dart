import 'package:ambientestereo/views/saved/components/empty_saved_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/components/internet_wrapper.dart';

import '../../core/components/headline_with_row.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/saved_post_controller.dart';
import '../home/home_page/components/loading_posts_responsive.dart';
import 'components/save_list_view.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return InternetWrapper(
      child: Container(
        color: Theme.of(context).cardColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppSizedBox.h10,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: HeadlineRow(headline: 'saved'),
              ),
              Expanded(child: SavedArtcileList())
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SavedArtcileList extends ConsumerWidget {
  const SavedArtcileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPosts = ref.watch(savedPostController);
    final controller = ref.read(savedPostController.notifier);
    if (savedPosts.refershError) {
      return Center(
        child: Text(savedPosts.errorMessage),
      );
    } else if (savedPosts.initialLoaded == false) {
      return const LoadingPostsResponsive(isInSliver: false);
    } else if (savedPosts.posts.isEmpty) {
      return const EmptySavedList();
    } else {
      return SavedListViewBuilder(
        data: savedPosts.posts,
        listKey: controller.animatedListKey,
        onRefresh: controller.onRefresh,
      );
    }
  }
}
