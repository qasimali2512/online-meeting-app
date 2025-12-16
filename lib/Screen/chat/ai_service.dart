import 'package:google_generative_ai/google_generative_ai.dart';
class AiService {
   static const String _apiKey = "AIzaSyD2Po1eK1bPMa3ZK96EhpDkE9_wE-YOx-w";

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
  );


  Future<String> getAiResponse(String prompt) async {
    if (_apiKey.isEmpty) {
      return "ERROR: Gemini API Key is missing.";
    }


    final String contextPrompt =
        "You are an AI assistant in a meeting application. Please provide a brief and helpful response to the user's query: '$prompt'";

    try {
      final content = [Content.text(contextPrompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "Could not generate a response.";
    } catch (e) {
      print("AI API Error: $e");

      return "Sorry, I am facing a connection issue right now. Please check your API key validity. ($e)";
    }
  }
}