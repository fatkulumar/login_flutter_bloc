class DataModel<T> {
  final int currentPage;
  final List<T> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Links> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  DataModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory DataModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return DataModel<T>(
      currentPage: json['current_page'],
      data:
          (json['data'] as List<dynamic>)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links:
          (json['links'] as List<dynamic>)
              .map((link) => Links.fromJson(link as Map<String, dynamic>))
              .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Links {
  final String? url;
  final String label;
  final bool active;

  Links({this.url, required this.label, required this.active});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      url: json['url'] as String?,
      label: json['label'],
      active: json['active'],
    );
  }
}