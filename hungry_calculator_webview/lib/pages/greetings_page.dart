import 'package:flutter/material.dart';
import 'package:hungry_calculator/common.dart';
import 'package:hungry_calculator/pages/stepper_page.dart';

class GreetingsPage extends StatefulWidget {
  const GreetingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _GreetingsPage();
}

class _GreetingsPage extends State<GreetingsPage> {
  String event = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: onTap,
          child: logoButton(),
        ),
      ),
    );
  }

  Widget logoButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 200,
          width: 200,
          child: Image(
            image: AssetImage('assets/images/logo.png'),
           ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: colorBased,
              fontStyle: FontStyle.italic,
              fontSize: 20
            ),
            decoration: InputDecoration(
              labelText: 'За что платим?',
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                color: colorBased,
                fontSize: 20,
                fontStyle: FontStyle.italic
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(46, 46, 229, 100)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(46, 46, 229, 100)),
              ),
            ),
            onChanged: (text) => setState(() {
              event = text;
            }),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorBased,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'НАЧНЕМ',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }

  void onTap() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return StepperPage(event: event.trim().toLowerCase());
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}

