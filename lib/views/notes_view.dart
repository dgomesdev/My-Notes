import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My notes'),
        actions: [
          PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      await FirebaseAuth
                          .instance
                          .signOut()
                          .then(
                            (value) => Navigator
                              .of(context)
                              .pushNamedAndRemoveUntil(
                                loginRoute,
                                (route) => false
                              )
                          );
                    }
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem<MenuAction>(
                        value: MenuAction.logout, child: Text('Logout'))
                  ])
        ],
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                await FirebaseAuth
                    .instance
                    .signOut()
                    .then(
                        (value) => Navigator
                        .of(context)
                        .pushNamedAndRemoveUntil(
                        loginRoute,
                            (route) => false
                    )
                );
              }
            },
            child: const Text('Logout')),
      ),
    );
  }
}

enum MenuAction { logout }

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Logout confirmation'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Log out'))
            ],
          )).then((value) => value ?? false);
}
