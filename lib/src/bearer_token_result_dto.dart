import 'package:bearer_token_package/src/bearer_token_status.dart';

class BearerTokenResultDTO {
  const BearerTokenResultDTO({this.result, required this.status});
  final BearerTokenStatus status;
  final String? result;
}