import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:astarte/utils/auth_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _isHidden = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  String _userEmail = '';

  void _handleTap() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      Validator.validateEmail(email: value ?? ''),
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: CustomColors.astarteRed,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    labelText: 'Email',
                    hintText: 'example@email.com',
                  ),
                )),
            SizedBox(
              width: 300,
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      Validator.validatePassword(password: value ?? ''),
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelStyle: const TextStyle(
                        color: CustomColors.astarteRed,
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
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _signInWithEmailAndPassword();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = (await auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email!;
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    } else {
      setState(() {
        _success = false;
      });
    }
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
                  child: const Text(
                    'ASTARTE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.astarteRed,
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
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign_up');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: CustomColors.astarteRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );

    return Scaffold(
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
    );
  }
}
