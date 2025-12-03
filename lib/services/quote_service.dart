import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _apiUrl = 'https://zenquotes.io/api/random';

  Future<Quote> fetchRandomQuote() async {
    print('🔍 [QuoteService] Fetching quote from: $_apiUrl');

    try {
      final response = await http
          .get(
            Uri.parse(_apiUrl),
            headers: {
              'User-Agent': 'FlutterApp/1.0',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('📡 [QuoteService] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('📄 [QuoteService] Response body: $responseBody');

        if (responseBody.isEmpty) {
          throw Exception('Empty response from server');
        }

        final List<dynamic> data = json.decode(responseBody);
        print('📊 [QuoteService] Parsed data length: ${data.length}');

        if (data.isNotEmpty) {
          final quote = Quote.fromJson(data[0]);
          print('✅ [QuoteService] Quote fetched: ${quote.text}');
          return quote;
        } else {
          throw Exception('No quotes in response array');
        }
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on http.ClientException catch (e) {
      print('❌ [QuoteService] Network error: $e');
      throw Exception('Network error: Check your internet connection');
    } on FormatException catch (e) {
      print('❌ [QuoteService] JSON parsing error: $e');
      throw Exception('Invalid response format from server');
    } catch (e) {
      print('❌ [QuoteService] Unexpected error: $e');
      throw Exception('Failed to fetch quote: $e');
    }
  }
}

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q']?.toString() ?? 'No quote text available',
      author: json['a']?.toString() ?? 'Unknown',
    );
  }
}
