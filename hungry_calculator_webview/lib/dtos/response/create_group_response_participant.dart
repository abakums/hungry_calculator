class CreateGroupResponseParticipant {
  int id;
  String name;

  CreateGroupResponseParticipant({
    required this.id,
    required this.name,
  });

  factory CreateGroupResponseParticipant.fromJson(Map<String, dynamic> json) =>
      CreateGroupResponseParticipant(
        id: json['id'],
        name: json['name'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGroupResponseParticipant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
