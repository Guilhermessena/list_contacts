import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_contacts/model/contact.dart';
import 'package:list_contacts/repository/contacts_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nomeController = TextEditingController();
  var telefoneController = TextEditingController();
  var emailController = TextEditingController();
  XFile? photo;
  var contactRepository = ContactRepository();
  var contact = Contact();
  final _formKey = GlobalKey<FormState>();

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      contact.pathImage = croppedFile.path;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: SizedBox(
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 16,
                        ),
                        child: Text(
                          'Contato',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(65),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Wrap(
                                      children: [
                                        ListTile(
                                          leading: const FaIcon(
                                              FontAwesomeIcons.camera),
                                          title: const Text('Camera'),
                                          onTap: () async {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            photo = await picker.pickImage(
                                                source: ImageSource.camera);
                                            if (photo != null) {
                                              var directory = await path_provider
                                                  .getApplicationDocumentsDirectory();
                                              var path = directory.path;
                                              var name = basename(photo!.path);
                                              await photo!
                                                  .saveTo("$path/$name");

                                              await GallerySaver.saveImage(
                                                  photo!.path);
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              cropImage(photo!);
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const FaIcon(
                                              FontAwesomeIcons.images),
                                          title: const Text('Galeria'),
                                          onTap: () async {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            photo = await picker.pickImage(
                                                source: ImageSource.gallery);
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                            cropImage(photo!);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: photo != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(photo!.path),
                                        fit: BoxFit.contain,
                                        height: 100,
                                        width: 100,
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 65,
                                      child: FaIcon(FontAwesomeIcons.camera),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      textFormPadrao(
                        Icons.person_2_outlined,
                        'Nome',
                        nomeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        textoValidacoes: [
                          'Insira um nome',
                        ],
                      ),
                      textFormPadrao(
                        Icons.phone_outlined,
                        'Telefone',
                        telefoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        textoValidacoes: [
                          'Insira um número de telefone',
                          'Insira todos os números'
                        ],
                      ),
                      textFormPadrao(
                        Icons.email_outlined,
                        'E-mail',
                        emailController,
                      ),
                      Expanded(child: Container()),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  )),
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    contact.nome = nomeController.text;
                                    contact.telefone = telefoneController.text;
                                    contact.email = emailController.text;
                                    await contactRepository
                                        .salvarContact(contact);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Salvo'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Widget textFormPadrao(
  IconData icone,
  String nomeHint,
  TextEditingController controller, {
  List<TextInputFormatter>? inputFormatters,
  List<String>? textoValidacoes,
  String? validatorString,
}) {
  bool validatorValue(String? value) {
    if (value != null && value.isEmpty && value == '') {
      return true;
    }
    return false;
  }

  bool validatorNumber(String? value) {
    if (textoValidacoes?[0] == 'Insira um número de telefone') {
      value = value!.replaceAll(RegExp(r'[^0-9]'), '');
      if (int.parse(value) < 11) {
        return true;
      }
    }
    return false;
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 7),
    child: TextFormField(
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          prefixIcon: Icon(
            icone,
            size: 23,
          ),
          hintText: nomeHint,
          hintStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        inputFormatters: inputFormatters,
        validator: (value) {
          if (validatorValue(value)) {
            return textoValidacoes?[0];
          }

          if (validatorNumber(value)) {
            return textoValidacoes?[1];
          }
          return null;
        },
        controller: controller),
  );
}
