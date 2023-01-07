import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../views/saved/components/saved_article_tile.dart';
import '../../models/article.dart';
import '../../repositories/posts/post_local_repository.dart';
import '../../repositories/posts/post_repository.dart';
import '../analytics/analytics_controller.dart';
import 'saved_post_pagination.dart';

/// Provides The Saved Posts
final savedPostController =
    StateNotifierProvider<SavedPostNotifier, SavedPostPagination>(
  (ref) => SavedPostNotifier(ref.read(postRepoProvider)),
);

class SavedPostNotifier extends StateNotifier<SavedPostPagination> {
  SavedPostNotifier(this._repo) : super(SavedPostPagination.initial()) {
    {
      getAllSavedPost();
    }
  }
  final PostRepository _repo;
  final _localRepo = PostLocalRepository();

  Future<List<ArticleModel>> getAllSavedPost() async {
    state = state.copyWith(isPaginationLoading: true);
    final allPosts = await _repo.getsavedPosts();

    // Fix for hero animations
    final newList =
        allPosts.map((e) => e.copyWith(heroTag: '${e.link}saved')).toList();
    state = state.copyWith(
      posts: newList,
      isPaginationLoading: false,
      initialLoaded: true,
    );

    return allPosts;
  }

  removePostFromSavedAnimated({
    required int id,
    required int index,
    required ArticleModel tile,
  }) async {
    state.copyWith(isSavingPost: true);
    final newList = state.posts.where((element) => element.id != id).toList();
    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SavedArticleTile(
        article: tile,
        animation: animation,
        index: index,
      ),
    );
    state = state.copyWith(posts: newList);
    await _localRepo.deletePostID(id);
    state.copyWith(isSavingPost: false);
    AnalyticsController.logUserFavouriteRemoved(tile);
  }

  removePostFromSaved(int id) async {
    state.copyWith(isSavingPost: true);
    final newList = state.posts.where((element) => element.id != id).toList();
    state = state.copyWith(posts: newList);
    await _localRepo.deletePostID(id);
    state.copyWith(isSavingPost: false);
  }

  addPostToSaved(ArticleModel article) async {
    state = state.copyWith(isSavingPost: true);
    final currentList = state.posts;

    final thePost = article.copyWith(heroTag: '${article.link}saved');
    state = state.copyWith(posts: [...currentList, thePost]);
    animatedListKey.currentState?.insertItem(0);
    try {
      await _localRepo.savePostID(article.id);
      AnalyticsController.logUserFavourite(article);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    state = state.copyWith(isSavingPost: false);
  }

  /// Used for animation when deleting or inserting Article
  final animatedListKey = GlobalKey<AnimatedListState>();

  /// on Refresh
  Future<void> onRefresh() async {
    state = SavedPostPagination.initial();
    await getAllSavedPost();
  }
}
