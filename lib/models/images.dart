class Images {
  final String url;

  Images({
    required this.url,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        url: json['url'],
      );
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
