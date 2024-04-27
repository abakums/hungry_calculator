import 'dart:convert';

import 'package:hungry_calculator/dtos/dtos.dart';
import 'package:hungry_calculator/hungry_calculator_api/response_decoder.dart';

import '../models/hungry_calculator/models.dart';
import 'network.dart';

class BillHttp {
  final String path = 'bill_positions';

  Future<Group> save(Group groupWithBill) async {
    final response =
        await Network(path: '$path/create/').post(jsonEncode(CreateBillRequest(
      groupId: groupWithBill.id!,
      positions: groupWithBill.bill!
          .map((position) => CreateBillRequestPosition(
                title: position.title,
                price: position.price,
                parts: position.parts,
                payers: position.personalParts.entries
                    .map((payerToPriceAndParts) =>
                        CreateBillRequestPositionPayer(
                          id: payerToPriceAndParts.key.id!,
                          personalPrice: payerToPriceAndParts.value.item1,
                          personalParts: payerToPriceAndParts.value.item2,
                        ))
                    .toList(),
              ))
          .toList(),
    ).toJson()));
    final decodedResponse =
        CreateBillResponse.fromJson(decodeResponse(response));

    final responsePositions = decodedResponse.positions.toSet();
    for (var position in groupWithBill.bill!) {
      final positionInResponse =
          responsePositions.firstWhere((p) => p.title == position.title);
      responsePositions.remove(positionInResponse);

      position.id = positionInResponse.id;
    }

    return groupWithBill;
  }
}
