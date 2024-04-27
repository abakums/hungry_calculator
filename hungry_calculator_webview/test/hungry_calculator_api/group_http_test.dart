import 'package:flutter_test/flutter_test.dart';
import 'package:hungry_calculator/hungry_calculator_api/http_helper.dart';
import 'package:hungry_calculator/models/hungry_calculator/models.dart';

void main() {
  GroupParticipant john = GroupParticipant(name: 'John');
  List<GroupParticipant> participants = List.of({
    GroupParticipant(name: 'Anna'),
    GroupParticipant(name: 'Jack'),
    GroupParticipant(name: 'Vasya'),
  });
  Group group1 = Group(
    title: 'Pizza Day',
    creator: john,
    requisites: '5394 3283 9252 3824',
    participants: participants,
  );

  test('Save group', () async {
    await GroupParticipantHttp().save(john);
    await GroupHttp().save(group1);
    expect(group1.id, isNotNull);
    expect(group1.id!.length, greaterThan(0));
    expect(
        group1.participants!.map((p) => p.id).toSet().length, greaterThan(0));
  });

  Group group2 = Group(
    title: 'Second Pizza Day',
    creator: john,
    requisites: '5394 3283 9252 3824',
    participants: participants,
  );

  test('Save 2nd group', () async {
    await GroupHttp().save(group2);
    expect(group2.id, isNotNull);
    expect(group2.id!.length, greaterThan(0));
    expect(group2.id, isNot(equals(group1.id)));
  });
}
