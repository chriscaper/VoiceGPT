import 'dart:convert';
import 'package:chatgpt_integration/secretkey.dart';
import 'package:http/http.dart' as http;

String apiKey = secretApiKey;

class ApiServices{
    static String baseUrl = "https://api.openai.com/v1/completions";

  static  Map<String, String> header = {
    'Content-Type' : 'application/json',
    'Authorization' : 'Bearer $apiKey'
};

  static sendMessage(String? message) async {

    var res = await http.post(Uri.parse(baseUrl),
    headers: header,
    body: jsonEncode({
      "model" : "text-curie-001",
      "prompt" : '$message',
      "temperature" : 0.6,
      "max_tokens" : 100,
      "top_p" : 1,
      "n" : 2,
      "frequency_penalty" : 0.0,
      "presence_penalty" : 0.0,
      "stop" : [" Human:", " AI:"],

    }));

    if(res.statusCode == 200){
      var data = jsonDecode(res.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    }else{
      print("Failed Request");
    }
  }

}