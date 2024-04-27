import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScannerWidget extends StatefulWidget {
  List<Map<String, dynamic>> items;
  List<Map<String, dynamic>> cop;

  ReceiptScannerWidget({super.key, required this.items, required this.cop});

  @override
  _ReceiptScannerWidgetState createState() => _ReceiptScannerWidgetState();
}

class _ReceiptScannerWidgetState extends State<ReceiptScannerWidget> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController quantityEditingController = TextEditingController();

  Map<String, dynamic>? editingItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTextField(nameEditingController, 'Название товара'),
          Row(
            children: [
              Expanded(
                child: _buildNumericTextField(
                  priceEditingController,
                  'Цена',
                  const TextInputType.numberWithOptions(decimal: true),
                  [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                  ],
                  (value) {
                    if (value.isNotEmpty) {
                      double price = double.tryParse(value) ?? 0.0;
                      return price >= 0;
                    }
                    return true;
                  },
                ),
              ),
              Expanded(
                child: _buildNumericTextField(
                  quantityEditingController,
                  'Количество',
                  const TextInputType.numberWithOptions(decimal: true),
                  [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                  ],
                  (value) {
                    if (value.isNotEmpty) {
                      double quantity = double.tryParse(value) ?? 0.0;
                      return quantity > 0 && quantity <= 32000;
                    }
                    return true;
                  },
                  onEditingComplete: () {
                    if (editingItem != null) {
                      editItem();
                    } else {
                      addItem();
                    }
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return _buildCard(widget.items[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildFloatingActionButton(onPressed: addItem, icon: Icons.add),
          const SizedBox(height: 16.0),
          _buildFloatingActionButton(onPressed: camera, icon: Icons.camera_alt),
          const SizedBox(height: 16.0),
          _buildFloatingActionButton(
              onPressed: scanning, icon: Icons.document_scanner),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Montserrat',
        ),
        onEditingComplete: () {
          if (editingItem != null) {
            editItem();
          } else {
            addItem();
          }
        },
      ),
    );
  }

  Widget _buildNumericTextField(
    TextEditingController controller,
    String hintText,
    TextInputType keyboardType,
    List<TextInputFormatter> inputFormatters,
    bool Function(String) validator, {
    VoidCallback? onEditingComplete,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Montserrat',
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: (value) {
          if (validator(value!)) {
            return null;
          } else {
            return 'Неверное значение';
          }
        },
        onEditingComplete: onEditingComplete,
      ),
    );
  }

  Widget _buildFloatingActionButton(
      {required VoidCallback onPressed, required IconData icon}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color.fromRGBO(46, 46, 229, 100),
      foregroundColor: Colors.white,
      child: Icon(icon),
    );
  }

  void addItem() {
    String name = nameEditingController.text;
    String price = priceEditingController.text;
    String quantity = quantityEditingController.text;

    if (name.isNotEmpty && price.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        widget.items.add({
          'name': name,
          'price': num.parse(price),
          'quantity': num.parse(quantity),
        });
        widget.cop.add({
          'name': name,
          'price': num.parse(price),
          'quantity': num.parse(quantity),
        });
        nameEditingController.clear();
        priceEditingController.clear();
        quantityEditingController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все поля'),
        ),
      );
    }
  }

  Widget _buildCard(Map<String, dynamic> item, int index) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: ListTile(
        tileColor: const Color.fromRGBO(46, 46, 229, 100),
        title: Text(
          'Название: ${item['name']}',
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        subtitle: Text(
          'Количество: ${item['quantity']}\nЦена: ${item['price']}',
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 15),
        ),
        onLongPress: () {
          startEditing(item);
        },
      ),
    );
  }

  void startEditing(Map<String, dynamic> item) {
    setState(() {
      editingItem = item;
      nameEditingController.text = item['name'];
      priceEditingController.text = item['price'].toString();
      quantityEditingController.text = item['quantity'].toString();
    });
  }

  void editItem() {
    String name = nameEditingController.text;
    String price = priceEditingController.text;
    String quantity = quantityEditingController.text;

    if (name.isNotEmpty && price.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        editingItem!['name'] = name;
        editingItem!['price'] = num.parse(price);
        editingItem!['quantity'] = num.parse(quantity);

        // Очистка полей и сброс редактируемого элемента
        nameEditingController.clear();
        priceEditingController.clear();
        quantityEditingController.clear();
        editingItem = null;
      });
    } else {
      // Вывести предупреждение, если не все поля заполнены
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все поля'),
        ),
      );
    }
  }

  void scanning() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      _sendImageToApi(image.path);
    }
  }

  void camera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      _sendImageToApi(image.path);
    }
  }

  void _sendImageToApi(String imagePath) async {
    var url = Uri.parse("https://ocr.asprise.com/api/v1/receipt");

    var request = http.MultipartRequest("POST", url)
      ..fields['api_key'] = 'TEST'
      ..fields['recognizer'] = 'auto'
      ..fields['ref_no'] = 'oct_dart'
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      var decodedResponse = json.decode(jsonResponse);
      var items = decodedResponse['receipts'][0]['items'];

      items.take(2).forEach((item) => setState(() {
            widget.items.add({
              'name': item['description'],
              'price': item['amount'],
              'quantity': item['qty'],
            });
          }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка отправки чека'),
        ),
      );
      print('error connection');
    }
  }
}
