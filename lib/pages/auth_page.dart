import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(215, 117, 255, 0.5),
              Color.fromRGBO(215, 188, 117, 0.9),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                          transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2)
                            )
                          ]),
                      child: Text(
                        'Minha Loja',
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Anton',
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    AuthForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
