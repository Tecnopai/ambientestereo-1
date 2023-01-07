import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/components/app_shimmer.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/users/user_data_controller.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_utils.dart';

class PostMetaData extends StatelessWidget {
  const PostMetaData({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                IconlyBold.timeCircle,
                color: Colors.grey,
              ),
              AppSizedBox.w5,
              Text(
                '${AppUtil.totalMinute(article.content, context)} ${'minute_read'.tr()} | ${DateFormat.yMMMMd(context.locale.toLanguageTag()).format(article.date)}',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          AppSizedBox.h5,
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: AuthorData(articleModel: article),
              ),
              const Spacer(),
              CommentCounter(data: article),
            ],
          )
        ],
      ),
    );
  }
}

class PostViewCounter extends StatelessWidget {
  const PostViewCounter({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ArticleModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.visibility_rounded,
          size: 16,
          color: Colors.grey,
        ),
        AppSizedBox.w5,
        Text(
          '172 Views',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class CommentCounter extends StatelessWidget {
  const CommentCounter({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ArticleModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSizedBox.w5,
        Text(
          '',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class AuthorData extends ConsumerWidget {
  const AuthorData({
    Key? key,
    required this.articleModel,
  }) : super(key: key);

  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider(articleModel.authorID)).map(
          data: (data) => InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.authorPage,
                arguments: data.value?.userID,
              );
            },
            child: Row(
              children: [
                data.value?.avatarUrl == null
                    ? const Icon(
                        IconlyBold.profile,
                        color: Colors.grey,
                        size: 18,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(data.value!.avatarUrl),
                        radius: 9.5,
                      ),
                AppSizedBox.w5,
                Text(
                  data.value?.name ?? 'Author',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          loading: (d) => const LoadingAuthorData(),
          error: (e) => const Text('Error'),
        );
  }
}

class LoadingAuthorData extends StatelessWidget {
  const LoadingAuthorData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Row(
        children: [
          const Icon(
            IconlyBold.profile,
            color: Colors.grey,
            size: 18,
          ),
          AppSizedBox.w5,
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: AppDefaults.borderRadius),
            child: Text(
              'Author',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }
}
