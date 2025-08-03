import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdministradorController {
  // Criar empresa (sem alteração)
  createEnterprise({
    String? name,
    email,
    password,
    cpf,
    seguimento,
    telefone,
    celular,
    endereco,
    numero,
    bairro,
    cidade,
    estado,
    Uint8List? bytes,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    if (kDebugMode) {
      print('TOKEN $token');
    }
    String image = base64.encode(bytes!);
    var url = Uri.parse("https://apicasadecor.com/api/cadastro-empresa/");
    Map<String, String> headers = {
      'Authorization': "Token $token",
    };

    Map<String, dynamic> body = {
      "foto": image,
      "nome": name,
      "email": email,
      "password": password,
      "cpf": cpf,
      "tipo": "EMPRESA",
      "seguimento": seguimento,
      "telefone": telefone,
      "celular": celular,
      "endereco": endereco,
      "numero": numero,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado
    };

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 201) {
        if (kDebugMode) {
          print(response.body);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Criar prêmio (sem alteração)
  Future createRearward({
    String? points,
    String? title,
    String? description,
    Uint8List? bytes,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token')!;
    String image = base64.encode(bytes!);
    var url = Uri.parse("https://apicasadecor.com/api/premio/");
    Map<String, String> headers = {
      'Authorization': "Token $token",
    };

    Map<String, dynamic> body = {
      "imagem_1": image,
      "pontos": points,
      "titulo": title,
      "descricao": description
    };

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        if (kDebugMode) {
          print(response.body);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Criar especificador (sem alteração)
  Future createSpecified({
    String? name,
    String? email,
    String? password,
    String? cpf,
    Uint8List? bytes,
  }) async {
    var url = Uri.parse("https://apicasadecor.com/api/cadastro-especificador/");

    Map<String, dynamic> body = {
      "nome": name,
      "email": email,
      "password": password,
      "cpf": cpf,
    };

    // Se quiser testar envio da foto mesmo sendo readOnly:
    if (bytes != null && bytes.isNotEmpty) {
      String image = base64.encode(bytes);
      body["foto"] = image;
    }

    try {
      var response = await http.post(url, body: body);
      if (response.statusCode == 201) {
        if (kDebugMode) print(response.body);
        return true;
      } else {
        if (kDebugMode) print('Erro ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // NOVO: Buscar especificador por ID
  Future<Map<String, dynamic>?> getEspecificador() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token == null) {
      if (kDebugMode) print('Token não encontrado');
      return null;
    }

    // Corrigir a URL como feito em getGetUser
    var url = Uri.https("apicasadecor.com", "/api/especificador/$token");

    // Corrigir headers (sem o "Token ")
    Map<String, String> headers = {
      'Authorization': token,
      'content-type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: headers);

      if (kDebugMode) {
        print('getEspecificador response status: ${response.statusCode}');
        print('getEspecificador response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        if (kDebugMode) {
          print('Erro ao obter especificador: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exceção em getEspecificador: $e');
      }
      return null;
    }
  }

  // Atualizar especificador (com suporte à imagem)
  Future<bool> updateEspecificador({
    int? id,
    seguimento,
    telefone,
    celular,
    endereco,
    numero,
    bairro,
    cidade,
    estado,
    Uint8List? bytes,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    if (kDebugMode) {
      print('TOKEN $token');
    }

    var url = Uri.parse("https://apicasadecor.com/api/especificador/editar/$id/");
    Map<String, String> headers = {
      'Authorization': "Token $token",
    };

    Map<String, dynamic> body = {
      "seguimento": seguimento,
      "telefone": telefone,
      "celular": celular,
      "endereco": endereco,
      "numero": numero,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
    };

    if (bytes != null) {
      body["foto"] = base64.encode(bytes);
    }

    body.removeWhere((key, value) => value == null);

    try {
      var response = await http.patch(url, headers: headers, body: body);
      if (kDebugMode) {
        print('updateEspecificador response status: ${response.statusCode}');
        print('updateEspecificador response body: ${response.body}');
      }
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  // Verificar se CPF/CNPJ existe (sem alteração)
  Future<bool> checkIfCpfCnpjExists(String cpfCnpj) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    if (kDebugMode) {
      print('TOKEN $token');
    }

    var url = Uri.parse("https://apicasadecor.com/api/especificador/");
    Map<String, String> headers = {
      'Authorization': "Token $token",
    };

    url = url.replace(queryParameters: {'cpf': cpfCnpj});

    try {
      var response = await http.get(url, headers: headers);
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> deleteUsuario(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (kDebugMode) {
      print('TOKEN ARMAZENADO: $token');
    }

    var url = Uri.parse("https://apicasadecor.com/api/usuario/$id/");
    Map<String, String> headers = {
      'Authorization': token?.trim() ?? '',
    };

    try {
      var response = await http.delete(url, headers: headers);
      if (kDebugMode) {
        print('STATUS: ${response.statusCode}');
        print('BODY: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (kDebugMode) {
          print("Usuário excluído com sucesso");
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}
