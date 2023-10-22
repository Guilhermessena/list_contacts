import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_contacts/model/contact.dart';
import 'package:list_contacts/repository/contacts_repository.dart';

class ListContactPage extends StatefulWidget {
  const ListContactPage({super.key});

  @override
  State<ListContactPage> createState() => _ListContactPageState();
}

class _ListContactPageState extends State<ListContactPage> {
  var contactsRepository = ContactRepository();
  var _contacts = Contacts();
  var carregando = false;

  @override
  void initState() {
    carregarDados();
    super.initState();
  }

  void carregarDados() async {
    setState(() {
      carregando = true;
    });
    _contacts = await contactsRepository.consultarContacts();
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return carregando
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _contacts.contacts!.length,
            itemBuilder: (context, index) {
              var contact = _contacts.contacts![index];
              return Dismissible(
                key: Key(contact.objectId ?? ''),
                      onDismissed: (direction) async {
                        await contactsRepository.removerContact(contact.objectId!);
                        carregarDados();
                      },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        contact.pathImage != null
                            ? SizedBox(
                                width: 55,
                                child: ClipOval(
                                  child: Image.file(
                                    File(contact.pathImage!),
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 55,
                                child: CircleAvatar(
                                  radius: 65,
                                  child: FaIcon(FontAwesomeIcons.camera),
                                ),
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.nome!,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              contact.telefone!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
