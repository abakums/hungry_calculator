class CreateGroupParticipantRequest {
  String name;

  CreateGroupParticipantRequest({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGroupParticipantRequest &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
