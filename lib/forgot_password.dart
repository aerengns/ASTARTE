import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/auth_validator.dart';
import 'package:astarte/utils/firebase_exceptions.dart';
import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  bool _isHidden = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _success = false;
  String _userEmail = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<parameters.CurrentUser>(context);
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
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                      final status = await _handlePasswordSubmit(_emailController.text.trim());
                      if (status == AuthStatus.successful) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email has been sent. Please look in your mail box.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AuthExceptionHandler.generateErrorMessage(status)),
                          ),
                        );
                      }
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 300,
                  decoration: const BoxDecoration(
                    color: CustomColors.astarteRed,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(CustomColors.astarteWhite),
                  ) // Display the loading animation
                      : const Text(
                    'Submit',
                    style: TextStyle(color: CustomColors.astarteWhite, fontSize: 25),
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
    super.dispose();
  }

  Future<AuthStatus> _handlePasswordSubmit(String email) async {
    late AuthStatus status;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => status = AuthStatus.successful)
        .catchError(
            (e) => status = AuthExceptionHandler.handleAuthException(e));

    return status;
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Please enter your email address so we can send you an email to reset your password.',
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
            const ForgotPasswordForm(),
            Container(
              padding: const EdgeInsets.only(top: 35),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign_in');
                    },
                    child: const Text(
                      'Return back to sign in',
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
        body: Container(
          color: const Color.fromRGBO(237, 230, 231, 1),
          child: ListView(
            children: [
              Image.asset(
                'assets/icons/launcher_icon.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              titleSection,
              credentialsSection,
            ],
          ),
        ));
  }
}
