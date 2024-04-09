import '../lib/jwt_token.dart';

void main() {
  // var awesome = Awesome();
  String token = BearerToken.getToken('something text', DateTime(2025), 'my 32 length key................');
  print('token: $token');
  print('inner: ${BearerToken.getData(token, 'my 32 length key................')}');

  
  String tokenuSER = BearerToken.getToken('fa3fa-fafa2fahg3w4h-egvar3av5wt- 3qr3qr', DateTime(2025), 'my 32 length key................');
  print('token: $tokenuSER');
  print('inner: ${BearerToken.getData(tokenuSER, 'my 32 length key................')}');
}
