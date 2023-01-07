import 'dart:convert';

import 'package:ambientestereo/core/models/page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/feature_post_controller.dart';
import '../../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../../core/controllers/posts/recent_posts_controller.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/responsive.dart';

class PageTabSection3 extends ConsumerWidget {

  const PageTabSection3({
    Key? key,
    required this.featuredPosts,
  }) : super(key: key);

  final List<ArticleModel> featuredPosts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).cardColor,
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(featurePostController.future);
          await ref.refresh(popularPostsController.future);
          await ref.read(recentPostController.notifier).onRefresh();
          Fluttertoast.showToast(msg: 'refreshed'.tr() );
        },
        child: CustomScrollView(
          slivers: [
            /* <---- Featured News -----> */
            /*
            SliverPadding(
              padding: const EdgeInsets.only(top: AppDefaults.padding),
              sliver: SliverToBoxAdapter(

                child: Responsive(
                  mobile: PostSlider(articles: featuredPosts),
                  tablet: PostSliderTablet(articles: featuredPosts),
                ),
   
              ),
            ),
            */

             /* <---- popular_posts1 -----> */

            const SliverToBoxAdapter(child: Divider()),
            /* <---- popular_posts2 -----> */
            //fetchPagewp(),

            SliverPadding(
              padding: const EdgeInsets.only(top: AppDefaults.padding),
              sliver: SliverToBoxAdapter(
                child: 
                  Center(

                    child:FutureBuilder<PageWp>(
                      future: fetchPagewp(),
                      builder: (context, snapshot2) {
                        
                        if (snapshot2.hasData) {
                          
                          if ( snapshot2.data!.id >= 1 ){

                            return Html(
                              data: snapshot2.data!.content
                            );
                          }        
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  
                  ),
              ),
            ),

            const SliverToBoxAdapter(child: Divider()),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: Html(
                            data: getCurrentDate(),
                            style: {
                              'body': Style(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                fontSize: _articleTileFont(context),
                                lineHeight: const LineHeight(1.4),
                                fontWeight: FontWeight.bold,
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              'figure': Style(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero),
                            },
                          ),
              )
            ),

            const SliverToBoxAdapter(child: Divider(
              height: 130.0,
            )),

          ],
        ),
      ),
    );
  }
}

String getCurrentDate() {
       return '© Todos los derechos reservados Ambiente Stereo 88.4FM ${DateFormat('yyyy').format(DateTime.now()).toString()}';
}

  FontSize _articleTileFont(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const FontSize(15);
    } else if (Responsive.isTabletPortrait(context)) {
      return const FontSize(16);
    } else if (Responsive.isTablet(context)) {
      return const FontSize(17);
    } else {
      return const FontSize(15);
    }
  }

 String _url = 'https://ambientestereo.fm/sitio';
  String _apiKey = '/wp-json/wp/v2/pages/';



  Future<PageWp> fetchPagewp() async {
    final response =
    // ignore: prefer_interpolation_to_compose_strings
    await http.get(Uri.parse(_url+_apiKey+'26197'));

    if (response.statusCode == 200) {
      return PageWp.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Usuario');
    }
  }