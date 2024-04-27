import 'dart:convert';

import 'package:hungry_calculator/dtos/dtos.dart';
import 'package:hungry_calculator/hungry_calculator_api/response_decoder.dart';
import 'package:hungry_calculator/models/hungry_calculator/group_participant.dart';

import 'network.dart';

class GroupParticipantHttp {
  final String path = 'participants';

  Future<GroupParticipant> save(GroupParticipant participant) async {
    final response = await Network(path: '$path/create/').post(
        jsonEncode(CreateGroupParticipantRequest(name: participant.name)));
    final decodedResponse =
        CreateGroupParticipantResponse.fromJson(decodeResponse(response));

    participant.id = decodedResponse.id;

    return participant;
  }
}
