import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options/firebase_options.dart';

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
        title: const Text('Register'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
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
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: email,
                              password: password
                          );
                          print(userCredential);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                );
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}