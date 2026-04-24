import '../../domain/entities/content_dashboard_entity.dart';

class ContentDashboardModel extends ContentDashboardEntity {
  ContentDashboardModel({
    required super.id,
    required super.title,
    required super.image,
    required super.link,
  });

  factory ContentDashboardModel.fromJson(Map<String, dynamic> json) {
    return ContentDashboardModel(
      id: json['id'],
      title: json['sub_title'],
      image: json['image'],
      link: json['link'],
    );
  }
}
