import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_integration/colors.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget{
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>{

  SpeechToText  speechToText = SpeechToText();

  var text = "Please Hold the Button and Start Speaking.";
  bool isListening = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton:  AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: Duration(milliseconds: 1500),
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        glowColor: Colors.black38,
        child:  GestureDetector(
          onTapDown: (details) {
            setState(() {
              isListening = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
          }, 
          child: CircleAvatar(backgroundColor: Colors.black, radius: 35,
          child: Icon(Icons.mic, color:Colors.white ,),),
        ),
      ),
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "ChatGPT Voice Assistant", style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black
          ),
        ),

      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.only(bottom: 150),
        child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),),

      ),
    );
   }
}