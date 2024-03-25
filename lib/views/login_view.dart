import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                  print(userCredential);
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'user-not-found':
                      print('User not found');
                      break;
                    case 'wrong-password':
                      print('Wrong password');
                      break;
                    default:
                      print(e.code);
                  }
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