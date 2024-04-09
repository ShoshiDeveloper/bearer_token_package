
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

class BearerToken {
  static String _ecnrypt(String data, String secretKey) {
    final key = Key.fromUtf8(secretKey);

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final encrypted = encrypter.encrypt(data);
    return encrypted.base64;
  }
  static String _decrypt(String data, String secretKey) {
    final key = Key.fromUtf8(secretKey);
    
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final encrypted = Encrypted.from64(data);
    final decrypted = encrypter.decrypt(encrypted);
    return decrypted;
  }

  static String getToken(String data, DateTime live, String secretKey) {
    String header = _ecnrypt(jsonEncode({
      "alg":"HS256","typ":"JWT"
    }), secretKey);

    String payload = _ecnrypt(jsonEncode({
      "data": data,
      "live": live.toIso8601String()
    }), secretKey);

    String signature = _ecnrypt(base64Url.encode(Hmac(sha256, utf8.encode(secretKey)).convert("$header.$payload".codeUnits).bytes), secretKey);

    return "$header.$payload.$signature";
  }

  static String? getData(String token, String secretKey) {
    List<String> segments = token.split('.');
    Map<String, dynamic> payload = jsonDecode(_decrypt(segments[1], secretKey));
    DateTime live = DateTime.parse(payload["live"]);
    if (live.compareTo(DateTime.now()) == -1) {
      return null;
    }

    return payload["data"];
  }

}
