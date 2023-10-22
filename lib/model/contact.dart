class Contacts {
  List<Contact>? _contacts;

  Contacts({List<Contact>? contacts}) {
    if (contacts != null) {
      _contacts = contacts;
    }
  }

  List<Contact>? get contacts => _contacts;
  set contacts(List<Contact>? contacts) => _contacts = contacts;

  Contacts.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      _contacts = <Contact>[];
      json['results'].forEach((v) {
        _contacts!.add(Contact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_contacts != null) {
      data['results'] = _contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contact {
  String? _objectId;
  String? _nome;
  String? _email;
  String? _pathImage;
  String? _telefone;
  String? _createdAt;
  String? _updatedAt;

  Contact(
      {String? objectId,
      String? nome,
      String? email,
      String? pathImage,
      String? telefone,
      String? createdAt,
      String? updatedAt}) {
    if (objectId != null) {
      _objectId = objectId;
    }
    if (nome != null) {
      _nome = nome;
    }
    if (email != null) {
      _email = email;
    }
    if (pathImage != null) {
      _pathImage = pathImage;
    }
    if (telefone != null) {
      _telefone = telefone;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  String? get objectId => _objectId;
  set objectId(String? objectId) => _objectId = objectId;
  String? get nome => _nome;
  set nome(String? nome) => _nome = nome;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get pathImage => _pathImage;
  set pathImage(String? pathImage) => _pathImage = pathImage;
  String? get telefone => _telefone;
  set telefone(String? telefone) => _telefone = telefone;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Contact.fromJson(Map<String, dynamic> json) {
    _objectId = json['objectId'];
    _nome = json['nome'];
    _email = json['email'];
    _pathImage = json['pathImage'];
    _telefone = json['telefone'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = _objectId;
    data['nome'] = _nome;
    data['email'] = _email;
    data['pathImage'] = _pathImage;
    data['telefone'] = _telefone;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = _nome;
    data['email'] = _email;
    data['pathImage'] = _pathImage;
    data['telefone'] = _telefone;
    return data;
  }
}
