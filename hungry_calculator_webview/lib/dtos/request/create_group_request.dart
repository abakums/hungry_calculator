import 'create_group_request_group_creator.dart';
import 'create_group_request_group_participant.dart';

class CreateGroupRequest {
  String title;
  GroupCreatorDto creator;
  String requisites;
  List<CreateGroupRequestGroupParticipant> participants;

  CreateGroupRequest({
    required this.title,
    required this.creator,
    required this.requisites,
    required this.participants,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'creator': creator.toJson(),
        'requisites': requisites,
        'participants':
            participants.map((participant) => participant.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGroupRequest &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          creator == other.creator &&
          requisites == other.requisites &&
          participants == other.participants;

  @override
  int get hashCode =>
      title.hashCode ^
      creator.hashCode ^
      requisites.hashCode ^
      participants.hashCode;
}
