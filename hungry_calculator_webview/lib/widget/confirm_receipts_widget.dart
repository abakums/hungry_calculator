import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';

class GuestSummaryWidget extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> receipts;

  GuestSummaryWidget({required this.receipts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: receipts.length,
        itemBuilder: (context, index) {
          final guestName = receipts.keys.elementAt(index);
          final guestItems = combineItems(receipts[guestName]!);
          final totalCost = calculateTotalCost(guestItems);

          return Card(
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: RoundedExpansionTile(
              tileColor: const Color.fromRGBO(46, 46, 229, 100),
              hoverColor: const Color.fromRGBO(46, 46, 229, 70),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              title: Center(
                  child: Text(
                '${guestName[0].toUpperCase()}${guestName.substring(1,guestName.length)}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              )),
              trailing: const Icon(Icons.receipt_long, size: 30,color: Colors.white,),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in guestItems)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${item['quantity']}x${item['price']}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Итого: $totalCost Р',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  num calculateTotalCost(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) => sum + item['quantity'] * item['price']);
  }

  List<Map<String, dynamic>> combineItems(List<Map<String, dynamic>> items) {
    Map<String, List<Map<String, dynamic>>> groupedItems =
    groupBy(items, (item) => item['name']);

    List<Map<String, dynamic>> combinedItems = [];

    groupedItems.forEach((name, itemList) {
      var totalQuantity = 0;

      itemList.forEach((item) {
        totalQuantity++;
      });

      var combinedItem = {
        'name': name,
        'quantity': totalQuantity,
        'price': itemList.first['price'],
      };

      combinedItems.add(combinedItem);
    });

    return combinedItems;
  }
}
