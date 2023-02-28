import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_integration/apiservices.dart';
import 'package:chatgpt_integration/chat.dart';
import 'package:chatgpt_integration/colors.dart';
import 'package:chatgpt_integration/texttospeech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget{
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>{

  SpeechToText  speechToText = SpeechToText();

  final List<ChatM> messages = [];
  var scrollController = ScrollController();

  scrollMethod(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, 
    duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  var text = "";
  bool isListening = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
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
          onTapUp: (details) async{
            setState(() {
              isListening = false;
            });
            await speechToText.stop();
            if(text.isNotEmpty && text != "Hold the button and Start Speaking"){
              messages.add(ChatM(text: text, typea: ChatMessageType.user));
              var msg = await ApiServices.sendMessage(text);
              msg = msg.trim();

              setState(() {
                messages.add(ChatM(text: msg, typea: ChatMessageType.bot));
              });

              Future.delayed(Duration(milliseconds: 500), (){
                TextToSpeech.speak(msg);
              });
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to Process. Try Again!")));
            }
            
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
              Text("Please Hold the Mic Button and Start Speaking", style:  TextStyle(fontSize: 18, color: isListening ? Colors.black87 : Colors.black54, fontWeight: FontWeight.w600),),
              const SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("Recognized Texts: ", style:  TextStyle(fontSize: 13, color:  Colors.black, fontWeight: FontWeight.w800),),
                Text(text, style:  TextStyle(fontSize: 13, color:  Colors.black, fontWeight: FontWeight.w800),),
              
              ],),
              const SizedBox(height: 50,),
              Expanded(
                
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index){
                  var ch = messages[index];
                  return chat(chattext: ch.text, type: ch.typea);
              }),
              
              )
            ],
          ),
      
        ),
    );
   }

   Widget chat({required chattext, required ChatMessageType? type} ){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatMessageType.bot? Image.asset('assets/chatgpt.png') : Icon(Icons.person, color: Colors.black,),
        ),
        const SizedBox(width: 12,),
        Expanded
        (
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: type == ChatMessageType.bot? Colors.black12: Colors.grey,
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