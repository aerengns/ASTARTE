// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _isHidden = true;

  void _handleTap() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 300,
          child: TextField(
            obscureText: false,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelStyle: TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
              labelText: 'Email',
              hintText: 'example@email.com',
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: SizedBox(
            width: 300,
            child: TextField(
              obscureText: _isHidden,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                labelText: 'Password',
                suffix: IconButton(
                  onPressed: _handleTap,
                  icon: const Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TextButton(
            onPressed: () {},
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Column(children: [
      Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 30),
                  child: Text(
                    'ASTARTE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                        fontSize: 35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 25),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Hi there! Nice to see you again.',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 15),
                        ),
                      )
                    ],
                  )))
        ],
      )
    ]);

    Widget credentialsSection = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SignInForm(),

            Container(
              alignment: Alignment.center,
              width: 300,
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'or use one of your social profiles',
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 50,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                          ),
                          Text(
                            'Twitter',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Colors.white,
                          ),
                          Text(
                            'Facebook',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 60),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );

    return MaterialApp(
      title: 'Flutter Layout Demo',
      home: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              'assets/images/astarte.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            titleSection,
            credentialsSection,
          ],
        ),
      ),
    );
  }
}
