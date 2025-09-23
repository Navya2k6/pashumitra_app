// FILE: lib/ai_chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import 'api_keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user_app'); // Your user
  final _chatbot = const types.User(id: 'chatbot_ai', firstName: "Pashumitra AI"); // The AI bot

  late final GenerativeModel _model;
  
  @override
  void initState() {
    super.initState();
    // Initialize the Gemini Model
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: ApiKeys.googleAI, // Using the key from your api_keys.dart file
      systemInstruction: Content.system('You are a helpful AI assistant for Indian farmers, specializing in cattle and livestock. Your name is Pashumitra. Keep your answers concise and helpful.'),
    );

    _addInitialMessage();
  }
  
  void _addInitialMessage() {
     _addMessage(types.TextMessage(
      author: _chatbot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: "Hello! I am Pashumitra, your AI assistant. How can I help you with your livestock today?",
    ));
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(userMessage);

    // Show a typing indicator while waiting for the response
    final typingMessage = types.TextMessage(
      author: _chatbot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: "...",
      status: types.Status.sending,
    );
    _addMessage(typingMessage);

    try {
      // Send the user's message to the Gemini API
      final response = await _model.generateContent([
        Content.text(message.text)
      ]);

      // Create a new message with the AI's response
      final botMessage = types.TextMessage(
        author: _chatbot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: response.text ?? "Sorry, I couldn't process that.",
      );

      // Remove the typing indicator and add the real response
      setState(() {
        _messages.removeAt(0); // Remove "..."
        _messages.insert(0, botMessage);
      });

    } catch (e) {
      // Handle errors
      final errorMessage = types.TextMessage(
        author: _chatbot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: "Sorry, an error occurred. Please try again.",
      );
      setState(() {
         _messages.removeAt(0); // Remove "..."
        _messages.insert(0, errorMessage);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/imgbg.jpg'), // Your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
         backgroundColor: Colors.transparent,
      body: Chat(
        
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user, // This is the correct parameter for this version
        theme: DefaultChatTheme(
          backgroundColor: Colors.transparent,
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.surface,
          inputBackgroundColor: Theme.of(context).cardColor,
           inputTextColor: Colors.black,       // Text color while typing
          inputTextStyle: const TextStyle(fontSize: 16), // Optional: font size
          inputBorderRadius: BorderRadius.circular(16),
          sendButtonIcon: Icon(
          Icons.send,
          color: Theme.of(context).colorScheme.primary, // Make send button visible
        ),
      ),
    ),
    )
    );
  }
}