import 'package:flutter/material.dart';
import 'package:list_contacts/pages/list_contact_page.dart';
import 'package:list_contacts/pages/sign_up_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('List Contacts'),
          ),
          body: const ListContactPage(),
          floatingActionButton: SizedBox(
            width: 90,
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.blue.shade300),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text('Adiconar'),
            ),
          )),
    );
  }
}
