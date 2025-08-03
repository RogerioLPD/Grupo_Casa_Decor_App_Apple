import 'dart:convert';
import 'dart:developer';
import 'package:grupo_casadecor/mobile/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReleasesController {
  // Envia uma nova compra
  Future<bool> doRelease({
    required dynamic valor,
    required dynamic doc,
    required dynamic empresa,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token não encontrado.');
    }

    var url = Uri.parse("https://apicasadecor.com/api/nova-compra/");

    Map<String, String> headers = {
      'Authorization': token, // ✅ já está com "Token ..." embutido
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      "valor": valor,
      "doc": doc,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        return true;
      } else {
        log('Erro ao enviar release: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      log("Erro ao fazer release: $e");
      return false;
    }
  }

  // Busca as transações de pontos
  Future<List<PointTransaction>> fetchTransactions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token não encontrado.');
    }

    var url = Uri.https("apicasadecor.com", "/api/compras-especificador/");

    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        // Imprime a resposta para você ver o que a API retornou
        print('Resposta da API (raw): $responseData');

        return responseData.map((json) => PointTransaction.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar dados: $e');
    }
  }
}
