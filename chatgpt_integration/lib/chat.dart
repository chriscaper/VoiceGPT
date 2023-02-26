enum ChatMessageType{user, bot}

class ChatM{

  ChatM({required this.text, required this.type});
  String? text;
  ChatMessageType? type;
}