import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
        title: const Text('Register'),
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
                      .createUserWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'weak-password':
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Weak password')
                          )
                      );
                      break;
                    case 'email-already-in-use':
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Email already in use')
                          )
                      );
                      break;
                    case 'invalid-email':
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid email')
                          )
                      );
                      break;
                    default:
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error')
                          )
                      );
                  }
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                          (route) => false
                  );
                },
                child: const Text('Already registered? Login here!')
            )
          ],
        ),
      ),
    );
  }
}