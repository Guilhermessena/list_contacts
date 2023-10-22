import 'package:list_contacts/model/contact.dart';
import 'package:list_contacts/repository/back4app/custom_dio.dart';

class ContactRepository {
  final _customDio = CustomDio();

  ContactRepository();

  Future<Contacts> consultarContacts() async {
    var url = "/Contacts";

    var result = await _customDio.dio.get(url);
    return Contacts.fromJson(result.data);
  }

  Future<void> salvarContact(Contact contact) async {
    try {
      await _customDio.dio.post("/Contacts", data: contact.toCreateJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> atualizarContact(Contact contact) async {
    try {
      await _customDio.dio
          .put("/Contacts/${contact.objectId}", data: contact.toCreateJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> removerContact(String objectId) async {
    try {
      await _customDio.dio.delete("/Contacts/$objectId");
    } catch (e) {
      throw e;
    }
  }
}
