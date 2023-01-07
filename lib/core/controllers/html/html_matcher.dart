import 'package:flutter_html/custom_render.dart';

class HtmlMatcher {
  static CustomRenderMatcher videoMatcher() =>
      (context) => context.tree.element?.localName == 'video';
  static CustomRenderMatcher iframeMatcher() =>
      (context) => context.tree.element?.localName == 'iframe';
  static CustomRenderMatcher imageMatcher() =>
      (context) => context.tree.element?.localName == 'img';
}
