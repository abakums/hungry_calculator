import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry_calculator/common.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../hungry_calculator_api/bill_http.dart';
import '../hungry_calculator_api/group_http.dart';
import '../hungry_calculator_api/group_participant_http.dart';
import '../models/hungry_calculator/models.dart';

class PhoneWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Map<String, List<Map<String, dynamic>>> receipts;
  final String event;

  const PhoneWidget(
      {super.key,
      required this.receipts,
      required this.items,
      required this.event});

  @override
  State<StatefulWidget> createState() => _PhoneWidget();
}

class _PhoneWidget extends State<PhoneWidget> {
  String phone = '';
  bool enabled = false;
  String code = '';
  String event = 'Тестовый';

  @override
  void initState() {
    event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          phoneField(),
          const SizedBox(height: 30),
          button(),
          const SizedBox(height: 30),
          group(),
        ],
      ),
      floatingActionButton:
        code.isEmpty
            ? null : FloatingActionButton(
            onPressed: () async {
              String textToShare =
              '''
Я за тебя оплатил и в благородство играть не буду! Ты заплатишь!

Вот ссылочка: https://share-bill.vercel.app/$code

Если что код: $code

Найдёшь себя и давай уже деньги''';
              await Share.share(textToShare);
              },
            backgroundColor: colorBased,
            child: const Icon(Icons.share, color: Colors.white,)),
    );
  }

  Widget phoneField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: IntlPhoneField(
        decoration: const InputDecoration(
          labelText: 'Номер телефона',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        initialCountryCode: 'RU',
        style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18),
        onChanged: (phone) {
          setState(() {
            this.phone = '8${phone.number}';
            if (this.phone.length > 9) {
              enabled = true;
            } else {
              enabled = false;
            }
          });
        },
        onSaved: (phone) {
          setState(() {
            this.phone = phone!.number;
            enabled = true;
          });
        },
      ),
    );
  }

  Widget button() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color.fromRGBO(46, 46, 229, 100),
      ),
      child: InkWell(
        onTap: enabled ? () => sendToAPI() : null,
        child: const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            'Создать группу',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22),
          ),
        ),
      ),
    );
  }

  void sendToAPI() async {
    List<GroupParticipant> participants =
        widget.receipts.keys.map((e) => GroupParticipant(name: e)).toList();

    final groupCreator = participants.first;

    Group group = Group(
      title: event,
      creator: groupCreator,
      requisites: phone,
      participants: participants,
    );

    await GroupParticipantHttp().save(groupCreator);
    await GroupHttp().save(group);

    group.bill = widget.items
        .map(
          (item) => BillPosition(
            title: item['name'],
            price: calculateTotalCost(item),
            parts: item['quantity'],
            personalParts: Map.fromEntries(
              widget.receipts.entries
                  .where((entry) => entry.value
                      .any((pos) => compareMapsWithoutQTY(pos, item)))
                  .map(
                (entry) {
                  final allByOnePos = entry.value
                      .where((itemG) => compareMapsWithoutQTY(itemG, item))
                      .toList();
                  final quantity = allByOnePos.length;
                  final posG = allByOnePos.first;
                  return MapEntry(
                    participants.firstWhere(
                        (participant) => participant.name == entry.key),
                    Tuple2(
                      makeInteger(quantity * posG['price']),
                      quantity,
                    ),
                  );
                },
              ),
            ),
          ),
        )
        .toList();

    await BillHttp().save(group);

    setState(() {
      code = "${group.id}";
    });
  }

  Widget group() {
    return code.isEmpty
        ? Container()
        : Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white),
            ),
            child: ListTile(
              tileColor: const Color.fromRGBO(46, 46, 229, 100),
              contentPadding: const EdgeInsets.all(8.0),
              leading: const Text(
                'Код: ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              enabled: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    code,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => copyToClipboard(),
                    icon: const Icon(
                      Icons.content_copy,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Код скопирован в буфер обмена'),
      ),
    );
  }
}

int calculateTotalCost(Map<String, dynamic> item) {
  return makeInteger(item['quantity'] * item['price']);
}

int makeInteger(num number) {
  while (number % 1 != 0) {
    number *= 10;
  }
  return int.tryParse(number.toString()) ?? 0;
}

bool compareMapsWithoutQTY(
    Map<String, dynamic> map1, Map<String, dynamic> map2) {
  return map1['name'] == map2['name'] && map1['price'] == map2['price'];
}
