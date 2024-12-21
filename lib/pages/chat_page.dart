import 'package:chat/components/chat_bubble.dart';
import 'package:chat/components/my_textfield.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat and auth sercics
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listener to foucs node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

  //wait a bit for listview to build then scroll bottom
Future.delayed(
  const Duration(milliseconds: 500),
  () => scrollDown(),
  );
  }



  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendMessage() async {
    //if there is sth inside textfield
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      //clear text controller after sent
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.receiverEmail,
          style: TextStyle(color: theme.secondary),
        )),
        backgroundColor: theme.primary,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.call, color: theme.onPrimary), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.video_chat_sharp, color: theme.onPrimary),
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.menu, color: theme.onPrimary), onPressed: () {}),
        ],
      ),
      body: Column(children: [
        //display all the messages
        Expanded(
          child: _buildMessageList(),
        ),

        //user input
        _buildUserInput(),
        const SizedBox(
          height: 12,
        ),
      ]),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        //return Listview
        return ListView(
          controller: _scrollController,

          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

//build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align message to right if sender is current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(data['message']),
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
        ],
      ),
    );

    // return Text(data["message"]);
  }

//build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ), // BoxDecoration
            margin: const EdgeInsets.all(6),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.add_box)),
          ), // Conta
          // IconButton(onPressed: () {}, icon: Icon(Icons.add_box)),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ), // BoxDecoration
            // margin: const EdgeInsets.all(6),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.image)),
          ), //
          Expanded(
              child: MyTextField(
            controller: _messageController,
            focusNode: myFocusNode,
            hintText: "Type a message",
            obscureText: false,
          )),
          // send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ), // BoxDecoration
            margin: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ), // Icon
            ), // IconButton
          ), // Container
        ],
      ),
    );
  }
}
