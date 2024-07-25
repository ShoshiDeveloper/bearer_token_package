
import 'dart:convert';

import 'package:bearer_token_package/src/bearer_token_status.dart';
import 'package:bearer_token_package/src/bearer_token_result_dto.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
// Key length not 128/192/256 bits

/*
  16 - 128 = 4
  32 - 196 = 4
  64 - 256 = 4

  256 / 4 = 64

  256 / 64 = 4
*/

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

  ///Ключ должен быть длиной:
  ///16 symbols/bytes - 128 bits
  ///24 symbols/bytes - 192 bits
  ///32 symbols/bytes - 256 bits
  static BearerTokenResultDTO getToken(String data, DateTime live, String secretKey) {
    if(!(secretKey.length == 16 || secretKey.length == 24 || secretKey.length == 32)) return const BearerTokenResultDTO(status: BearerTokenStatus.brokenSecretKey);

    final String header = _ecnrypt(jsonEncode({
      "alg":"HS256","type":"JWT"
    }), secretKey);

    final String payload = _ecnrypt(jsonEncode({
      "data": data,
      "live": live.toIso8601String()
    }), secretKey);

    final String signature = _ecnrypt(base64Url.encode(Hmac(sha256, utf8.encode(secretKey)).convert("$header.$payload".codeUnits).bytes), secretKey);

    return BearerTokenResultDTO(result: "$header.$payload.$signature", status: BearerTokenStatus.done);
  }

  static BearerTokenResultDTO getData(String token, String secretKey) {
    final List<String> segments = token.split('.');
    if(!(secretKey.length == 16 || secretKey.length == 24 || secretKey.length == 32)) return const BearerTokenResultDTO(status: BearerTokenStatus.brokenSecretKey);
    if(segments.length != 3) return const BearerTokenResultDTO(status: BearerTokenStatus.brokenToken);
    
    try {
      final Map<String, dynamic> payload = jsonDecode(_decrypt(segments[1], secretKey));

      final DateTime live = DateTime.parse(payload["live"]);
      if (live.compareTo(DateTime.now()) == -1) {
        return const BearerTokenResultDTO(status: BearerTokenStatus.liveIsOver);
      }

      return BearerTokenResultDTO(result: payload["data"], status: BearerTokenStatus.done);
    } catch (e) {
      return const BearerTokenResultDTO(status: BearerTokenStatus.brokenToken);
    }
  }

}
