import 'package:flutter/material.dart';

class AIAssistant extends StatefulWidget {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          "AI Assistant",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
