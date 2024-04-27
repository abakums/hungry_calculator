class CreateGroupParticipantResponse {
  int id;

  CreateGroupParticipantResponse({required this.id});

  factory CreateGroupParticipantResponse.fromJson(Map<String, dynamic> json) =>
      CreateGroupParticipantResponse(id: json['id']);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGroupParticipantResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
