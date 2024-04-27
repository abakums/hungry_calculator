import 'package:flutter_test/flutter_test.dart';
import 'package:hungry_calculator/hungry_calculator_api/group_participant_http.dart';
import 'package:hungry_calculator/models/hungry_calculator/group_participant.dart';

void main() {
  GroupParticipant billie = GroupParticipant(name: 'Billie');
  GroupParticipant ann = GroupParticipant(name: 'Ann');

  test('Save participant', () async {
    await GroupParticipantHttp().save(billie);
    expect(billie.id, isNotNull);
  });

  test('Save 2nd participant', () async {
    await GroupParticipantHttp().save(ann);
    expect(ann.id, isNotNull);
    expect(ann.id, isNot(equals(billie.id)));
  });
}
