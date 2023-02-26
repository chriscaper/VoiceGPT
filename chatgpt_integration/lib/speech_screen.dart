import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_integration/chat.dart';
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
          onTapDown: (details) async{
            if(!isListening){
              var available = await speechToText.initialize();
              if(available){
                setState(() {
                  isListening = true;
                  speechToText.listen(
                    onResult: (result){
                      setState(() {
                        text = result.recognizedWords;
                      });
                    }
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
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
      body:  Container(
          
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          
          child: Column(
            children: [
              Text(text, style:  TextStyle(fontSize: 18, color: isListening ? Colors.black87 : Colors.black54, fontWeight: FontWeight.w600),),
              Expanded(
                
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index){
                return chat(
                  chattext: "Hey, How are you doinhg?",
                  type: ChatMessageType.user
                );
              }),
              
              )
            ],
          ),
      
        ),
    );
   }

   Widget chat({required chattext, required ChatMessageType type} ){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(Icons.person, color: Colors.black,),
        ),
        const SizedBox(width: 12,),
        Expanded
        (
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
              
        
            ),
            child: Text(
              "$chattext", 
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
   }
}