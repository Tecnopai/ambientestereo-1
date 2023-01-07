// To parse this JSON data, do
//
//     final pageWp = pageWpFromJson(jsonString);


class PageWp {

    int id;
    String title;
    String content;

    PageWp({
        required this.id,
        required this.title,
        required this.content,

    });


    PageWp copyWith({
    int? id,
    String? title,
    String? content,

    }){
    return PageWp(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content
    );
    }

  factory PageWp.fromJson(Map<String, dynamic> json) {
    return PageWp(
      id: json['id']?.toInt() ?? 0,
      title: json['title']['rendered'],
      content: json['content']['rendered'] ?? '',
    );
  }


}
