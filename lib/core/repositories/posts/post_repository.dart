import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/article.dart';
import '../../utils/app_utils.dart';
import 'post_local_repository.dart';

final postRepoProvider = Provider<PostRepository>((ref) {
  final localRepo = ref.read(postLocalRepoProvider);
  final client = http.Client();
  final repo = PostRepository(localRepo, client);
  ref.onDispose(() {
    client.close();
  });
  return repo;
});

abstract class PostRepoAbstract {
  /// Get All Posts [Paginated]
  Future<List<ArticleModel>> getAllPost({required int pageNumber});

  /// Get Post By Category
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
  });


  Future<List<ArticleModel>> getPostByTag({
    required int pageNumber,
    required int tagID,
  });

  /// Get Post By Category Qty
  Future<List<ArticleModel>> getPostByCategoryQty({
    required int pageNumber,
    required int categoryID,
    required int perPage,
  });

  /// Get Pages

  Future<List<ArticleModel>> getPostByAuthor({
    required int pageNumber,
    required int authorID,
  });

  /// Get Post
  Future<ArticleModel?> getPost({required int postID});

  /// Get Popular Posts
  ///
  /// [isPlugin] This is because sometimes the popular post plugin returns an empty
  /// array or you wanna just add a feature post by yourself, which
  /// in this case this is required
  Future<List<ArticleModel>> getPopularPosts({bool isPlugin = true});

  /// Search Posts
  Future<List<ArticleModel>> searchPost({required String keyword});

  /// Retrieve all saved posts
  Future<List<ArticleModel>> getsavedPosts();

  /// Get Post From Slug
  Future<ArticleModel?> getPostFromUrl({required String requestedURL});

  /// Report a post
  Future<bool> reportPost({
    required int postID,
    required String postTitle,
    required String userEmail,
    required String userName,
  });
}

/// [PostRepository] that is responsible for posts getting
/// It is an implementation from the above abstract class
class PostRepository extends PostRepoAbstract {
  PostRepository(
    this._postLocalRepo,
    this.client,
  );
  final PostLocalRepository _postLocalRepo;

  final http.Client client;

  /* <---- Get All Posts -----> */
  @override
  Future<List<ArticleModel>> getAllPost({
    required int pageNumber,
  }) async {
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?page=$pageNumber';
    List<ArticleModel> articles = [];
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final posts = jsonDecode(response.body) as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
      }
      return articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  /* <---- Get Post By Category -----> */
  @override
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
  }) async {
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?categories=$categoryID&page=$pageNumber';
    List<ArticleModel> articles = [];
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final posts = jsonDecode(response.body) as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
      }
      return articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getPostByTag({
    required int pageNumber,
    required int tagID,
  }) async {
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?tags=$tagID&page=$pageNumber';
    List<ArticleModel> articles = [];
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final posts = jsonDecode(response.body) as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
      }
      return articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  /* <---- Get Post By Category and Qty -----> */
  @override
  Future<List<ArticleModel>> getPostByCategoryQty({
    required int pageNumber,
    required int categoryID,
    required int perPage,
  }) async {
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?categories=$categoryID&page=$pageNumber&per_page=$perPage';
    List<ArticleModel> articles = [];
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final posts = jsonDecode(response.body) as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
      }
      return articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }


  /* <---- Get a Page -----> */



  /// Get post by Author
  @override
  Future<List<ArticleModel>> getPostByAuthor({
    required int pageNumber,
    required int authorID,
  }) async {
    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/posts/?page=$pageNumber&author=$authorID&status=publish';
    debugPrint('Url: $url');
    List<ArticleModel> articles = [];
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final posts = jsonDecode(response.body) as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
        return articles;
      } else {
        debugPrint('Response code is ${response.statusCode}');
      }
      return articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return articles;
    }
  }

  /* <---- Get Popular Posts -----> */
  @override
  Future<List<ArticleModel>> getPopularPosts({
    bool isPlugin = true,
    int featureCategory = 1,
  }) async {
    List<ArticleModel> articles = [];

    /// Fetching from Plugin
    if (isPlugin) {
      String url =
          'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts/';
      try {
        final response = await client.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final posts = jsonDecode(response.body) as List;
          articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        }
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
      return articles;
    }

    /// If not plugin then we are going to fetch feature category
    else {
      String url =
          'https://${WPConfig.url}/wp-json/wp/v2/posts/?categories=$featureCategory';
      try {
        final response = await client.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final posts = jsonDecode(response.body) as List;
          articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        }
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
      return articles;
    }
  }

  static Future<bool> addViewsToPost({required int postID}) async {
    final url =
        'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts?wpp_id=$postID';

    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 201) {
        // debugPrint('Post Views has been added $postID');
        return true;
      } else {
        debugPrint(response.body);
        return false;
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  /* <---- Get a Post -----> */
  @override
  Future<ArticleModel?> getPost({required int postID}) async {
    String url = 'https://${WPConfig.url}/wp-json/wp/v2/posts/$postID';

    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return ArticleModel.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  /* <---- Search a post -----> */
  @override
  Future<List<ArticleModel>> searchPost({required String keyword}) async {
    String url = 'https://${WPConfig.url}/wp-json/wp/v2/posts/?search=$keyword';
    List<ArticleModel> articles = [];

    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final posts = jsonDecode(response.body) as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
      }

      return articles;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  @override
  Future<ArticleModel?> getPostFromUrl({required String requestedURL}) async {
    final theUrl = Uri.parse(requestedURL);
    final host = theUrl.host;
    String stripVersion = theUrl.path.replaceAll(RegExp(r'[^\w\s]+'), ' ');
    debugPrint('Stripped Version: $stripVersion');
    String postParameter = stripVersion;

    if (host == WPConfig.url) {
      final articles = await searchPost(keyword: postParameter);
      final article = articles.isNotEmpty ? articles.first : null;
      debugPrint(article.toString());
      return article;
    } else {
      debugPrint('This is not our app content');
    }
    return null;
  }

  @override
  Future<List<ArticleModel>> getsavedPosts() async {
    final ids = await _postLocalRepo.getSavedPostsID();
    List<ArticleModel> allPosts = [];
    for (var id in ids) {
      final post = await getPost(postID: id);
      if (post != null) allPosts.add(post);
    }
    return allPosts;
  }

  @override
  Future<bool> reportPost({
    required int postID,
    required String postTitle,
    required String userEmail,
    required String userName,
  }) async {
    final mail = '''Hello Admin, Hoping you are having a wonderful day.

I noticed that this post contains some inappropriate content that goes against certain policy of this app, please review this as soon as possible.

Post title: "$postTitle",
Post id: $postID,

Thanks & Regards.
$userName,
From: $userEmail''';

    try {
      await AppUtil.sendEmail(
        email: WPConfig.supportEmail,
        content: mail,
        subject: 'Reporting Post $postID',
      );
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  
}
