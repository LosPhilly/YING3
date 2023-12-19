// The completions endpoint
import 'package:ying_3_3/core/utils/openai/api_key.dart';

final Uri completionsEndpoint =
    Uri.parse('https://api.openai.com/v1/completions');

// The headers for the completions endpoint, which are the same for all requests
final Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $openAIApiKey',
};
