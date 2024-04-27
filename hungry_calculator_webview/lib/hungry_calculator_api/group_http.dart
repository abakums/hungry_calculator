import 'dart:convert';

import 'package:hungry_calculator/hungry_calculator_api/response_decoder.dart';

import '../dtos/dtos.dart';
import '../models/hungry_calculator/models.dart';
import 'network.dart';

class GroupHttp {
  final String path = 'groups';

  Future<Group> save(Group group) async {
    final response =
        await Network(path: '$path/create/').post(jsonEncode(CreateGroupRequest(
      title: group.title,
      creator: GroupCreatorDto(id: group.creator.id!),
      requisites: group.requisites,
      participants: group.participants!
          .map((participant) =>
              CreateGroupRequestGroupParticipant(name: participant.name))
          .toList(),
    )));
    final decodedResponse =
        CreateGroupResponse.fromJson(decodeResponse(response));

    group.id = decodedResponse.id;

    final responseParticipants = decodedResponse.participants.toSet();
    for (var participant in group.participants!) {
      final participantInResponse =
          responseParticipants.firstWhere((p) => p.name == participant.name);
      responseParticipants.remove(participantInResponse);

      participant.id = participantInResponse.id;
    }

    return group;
  }
}
