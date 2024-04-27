import 'create_group_response_participant.dart';

class CreateGroupResponse {
  String? id;
  List<CreateGroupResponseParticipant> participants;

  CreateGroupResponse({
    required this.id,
    required this.participants,
  });

  factory CreateGroupResponse.fromJson(Map<String, dynamic> json) =>
      CreateGroupResponse(
        id: json['groupId'],
        participants: List<CreateGroupResponseParticipant>.from(
            json['participants']?.map((participantJson) =>
                CreateGroupResponseParticipant.fromJson(participantJson))),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGroupResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
