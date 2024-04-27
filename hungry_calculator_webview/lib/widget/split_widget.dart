import 'package:flutter/material.dart';
import 'package:hungry_calculator/common.dart';

class GuestSelectionWidget extends StatefulWidget {
  Map<String, List<Map<String, dynamic>>> receipts = {};
  final List<Map<String, dynamic>> items;
  final List<String> groups;

  GuestSelectionWidget(
      {required this.items, required this.groups, required this.receipts});

  @override
  _GuestSelectionWidgetState createState() => _GuestSelectionWidgetState();
}

class _GuestSelectionWidgetState extends State<GuestSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGuestList(),
    );
  }

  Widget _buildGuestList() {
    return ListView.builder(
      itemCount: widget.groups.length,
      itemBuilder: (context, index) {
        final guest = widget.groups[index];
        return Card(
          elevation: 5.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: ListTile(
            tileColor: const Color.fromRGBO(46, 46, 229, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            title: Center(
              child: Text(
                guest,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            onTap: () {
              _navigateToItemSelection(guest);
            },
          ),
        );
      },
    );
  }

  void _navigateToItemSelection(String groupName) async {
    final selectedItemsForGroup = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ItemSelectionScreen(
              groupName: groupName,
              items: widget.items,
              selectedItems: widget.receipts);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    if (selectedItemsForGroup != null) {
      setState(() {
        widget.receipts[groupName.toLowerCase()] = selectedItemsForGroup;
      });
    }
  }
}

class ItemSelectionScreen extends StatefulWidget {
  final String groupName;
  final List<Map<String, dynamic>> items;
  final Map<String, List<Map<String, dynamic>>> selectedItems;

  ItemSelectionScreen(
      {required this.groupName,
      required this.items,
      required this.selectedItems});

  @override
  _ItemSelectionScreenState createState() => _ItemSelectionScreenState();
}

class _ItemSelectionScreenState extends State<ItemSelectionScreen> {
  late List<Map<String, dynamic>> selectedItems;

  @override
  void initState() {
    selectedItems = widget.selectedItems[widget.groupName] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Выбор позиций для ${widget.groupName}',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: colorBased,
              fontStyle: FontStyle.italic,
              fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: leave,
        ),
      ),
      body: _buildItemsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: leave,
        backgroundColor: colorBased,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  void leave() {
    Navigator.pop(context, selectedItems);
  }

  Widget _buildItemsList() {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final itemName = item['name'];
        final availableQuantity = item['quantity'];

        return Card(
          color: colorBased,
          elevation: 5,
          child: ListTile(
            title: Text(
              '$itemName - $availableQuantity ${availableQuantity % 1 == 0 ? 'шт' : 'кг/л'}',
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addItemForGuest(item, availableQuantity),
              color: Colors.white,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              onPressed: () => _restoreItemFromGuest(item, availableQuantity),
              color: Colors.white
            ),
            onTap: () => _addItemForGuest(item, availableQuantity),
          ),
        );
      },
    );
  }

  void _addItemForGuest(Map<String, dynamic> item, num availableQuantity) {
    if (availableQuantity > 0) {
      setState(() {
        selectedItems.add(item);
        item['quantity']--;
      });
    }
  }

  void _restoreItemFromGuest(Map<String, dynamic> item, num availableQuantity) {
    final existItem = selectedItems.any((e) => e['name'] == item['name']);
    if (existItem) {
      setState(() {
        selectedItems.remove(item);
        item['quantity']++;
      });
    }
  }
}
