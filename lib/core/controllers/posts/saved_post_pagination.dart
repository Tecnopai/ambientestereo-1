import 'package:flutter/foundation.dart';

import '../../models/article.dart';

class SavedPostPagination {
  List<ArticleModel> posts;
  int page;
  String errorMessage;
  bool initialLoaded;
  bool isPaginationLoading;
  bool isSavingPost;
  SavedPostPagination({
    required this.posts,
    required this.page,
    required this.errorMessage,
    required this.initialLoaded,
    required this.isPaginationLoading,
    required this.isSavingPost,
  });

  SavedPostPagination.initial()
      : posts = [],
        page = 1,
        errorMessage = '',
        initialLoaded = false,
        isPaginationLoading = false,
        isSavingPost = false;

  bool get refershError => errorMessage != '' && posts.length <= 10;

  SavedPostPagination copyWith({
    List<ArticleModel>? posts,
    int? page,
    String? errorMessage,
    bool? initialLoaded,
    bool? isPaginationLoading,
    bool? isSavingPost,
  }) {
    return SavedPostPagination(
      posts: posts ?? this.posts,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      initialLoaded: initialLoaded ?? this.initialLoaded,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      isSavingPost: isSavingPost ?? this.isSavingPost,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SavedPostPagination &&
        listEquals(other.posts, posts) &&
        other.page == page &&
        other.errorMessage == errorMessage &&
        other.initialLoaded == initialLoaded &&
        other.isPaginationLoading == isPaginationLoading &&
        other.isSavingPost == isSavingPost;
  }

  @override
  int get hashCode =>
      posts.hashCode ^
      page.hashCode ^
      errorMessage.hashCode ^
      isPaginationLoading.hashCode ^
      initialLoaded.hashCode ^
      isSavingPost.hashCode;
}
