import 'package:http/http.dart' as http;
import 'dart:convert';

class ConvertRepo {
  static final ConvertRepo _convertRepo = ConvertRepo._internal();

  factory ConvertRepo() {
    return _convertRepo;
  }

  ConvertRepo._internal();

  Future<double> convert(
      {String? fromCurr, String? toCurr, double? value}) async {
    const apiKey = '0d2f3a3863379704ca02c5b5';
    final uri = Uri.parse(
        'https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCurr');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      final rate = jsonResponse['conversion_rates'][toCurr].toDouble();

      return rate * value!;
    } else {
      throw Exception('Failed to load result');
    }
  }
}
