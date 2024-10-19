// import 'package:dart_openai/dart_openai.dart';

// class ChatBotController {
//   ChatBotController() {
//     OpenAI.apiKey =
//         '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'; // Replace with your OpenAI key
//   }

//   Future<String> sendMessage(String message) async {
//     try {
//       final response = await OpenAI.instance.completion.create(
//         model: "text-davinci-003", // GPT-3 model
//         prompt: message,
//         maxTokens: 100,
//         temperature: 0.7,
//       );

//       return response.choices.first.text.trim();
//     } catch (e) {
//       return 'Error: Unable to process your request right now. Details: $e';
//     }
//   }
// }