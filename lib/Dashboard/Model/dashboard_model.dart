class DashboardModel {
  final String title;
  final String description;
  final String imageUrl;

  DashboardModel({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}