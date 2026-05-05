class DoctorEntity {
  final String id;
  final String dcomId;
  final String? description;
  final String name;
  final String? image;
  final String? bio;
  final String? phone;
  final String? scheId;
  final String? specId;
  final String? title;

  DoctorEntity({
    required this.id,
    this.description,
    required this.name,
    this.image,
    this.bio,
    required this.dcomId,
    this.phone,
    this.scheId,
    this.specId,
    this.title,
  });
}
