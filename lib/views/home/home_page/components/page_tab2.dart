
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/feature_post_controller.dart';
import '../../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../../core/controllers/posts/recent_posts_controller.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/responsive.dart';

class PageTabSection2 extends ConsumerWidget {

  const PageTabSection2({
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

            const SliverToBoxAdapter(child: Divider(
              height: 80.0,
            )),
            /* <---- popular_posts2 -----> */
            //fetchPagewp(),

            SliverPadding(
              padding: const EdgeInsets.only(top: AppDefaults.padding),
              sliver: SliverToBoxAdapter(
                child: 
                  linkIglesia(context)
              ),
            ),

            const SliverToBoxAdapter(child: Divider(
              height: 170.0,
            )),

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


  linkIglesia(context){
    return
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),                    
                      child: Html(
                        data: 'Ir al sitio web',
                        style:{
                          'body': Style(
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            fontSize: _articleTileFont(context),
                            lineHeight: const LineHeight(1.4),                            
                          )
                          
                        }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: 
                        Material(
                              color: Colors.transparent,
                              child: Ink(
                                  decoration: const ShapeDecoration(
                                    //color: Colors.green,
                                    shape: CircleBorder(),
                                  ),
                                  child: 
                                    IconButton(
                                      onPressed: () async {
                                        final url = Uri.parse(
                                          'https://www.iglesiacristianapai.org/',
                                        );
                                        if (await canLaunchUrl(url)) {
                                          launchUrl(url);
                                        } else {
                                          // ignore: avoid_print
                                          print("Can't launch $url");
                                        }
                                      },
                                      iconSize: 200,
                                      icon: Image.asset(
                                        'assets/others/pai.png',
                                        width: 200                                  
                                        ),
                                      ),
                                      ),
                                ),
                                ),
                  ]
                )
              );
  }

