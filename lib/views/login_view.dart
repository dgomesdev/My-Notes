import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    hintText: 'Enter your email'
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false
            ),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    hintText: 'Enter your password'
                ),
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false
            ),
            TextButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: email,
                      password: password
                  ).then(
                      (value) => Navigator
                        .of(context)
                        .pushNamedAndRemoveUntil(
                          notesRoute,
                          (route) => false
                        )
                  );
                } on FirebaseAuthException catch (e) {
                  String errorMessage;
                  switch (e.code) {
                    case 'user-not-found':
                      errorMessage = 'User not found';
                      break;
                    case 'wrong-password':
                      errorMessage = 'Wrong password';
                      break;
                    default:
                      errorMessage = 'Login error';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(errorMessage)
                      )
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/register',
                      (route) => false
                  );
                },
                child: const Text('Not registered yet? Register here!')
            )
          ],
        ),
      ),
    );
  }
}