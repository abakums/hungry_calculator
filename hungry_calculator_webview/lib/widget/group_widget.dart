import 'package:flutter/material.dart';

class GroupWidget extends StatefulWidget {
  List<String> groups;

  GroupWidget({required this.groups});

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          field(),
          table(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGuest,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(46, 46, 229, 100),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget field() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: 'Имя гостя',
        ),
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18.0,
        ),
        onEditingComplete: _addGuest,
      ),
    );
  }

  void _addGuest() {
    final name = textController.text.trim();
    if (name.length > 1) {
      setState(() {
        widget.groups.add(textController.text.trim());
        textController.clear();
        textController.text = '';
      });
    }
  }

  Widget table() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.groups.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0)),
            child: ListTile(
              tileColor: const Color.fromRGBO(46, 46, 229, 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              title: Center(
                child: Text(
                  widget.groups[index],
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
