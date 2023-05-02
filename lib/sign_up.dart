import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:astarte/utils/auth_validator.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
                    _register();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextButton(onPressed: (){
                Navigator.pushNamed(context, '/sign_in');
              },
                child: const Text("Already have an account?"),
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = (await auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email!;

      });
      Navigator.popUntil(context, ModalRoute.withName('/'));

    } else {
      setState(() {
        _success = false;
      });
    }
  }
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 25),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Welcome to Astarte, please sign up to continue.',
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
      child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SignUpForm(),
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
