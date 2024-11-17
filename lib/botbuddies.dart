import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model.dart';

class BotBuddies extends StatefulWidget {
  const BotBuddies({super.key});

  @override
  State<BotBuddies> createState() => _BotBuddiesState();
}

class _BotBuddiesState extends State<BotBuddies> {
  TextEditingController promprController = TextEditingController();
  static const apikey = "AIzaSyAA5CI_D6Lscu8h4QBNWqka2zAbjW4_cqo";
  final model = GenerativeModel(model: "geminipro", apiKey: apikey);
  final List<ModelMessage> prompt = [];

  Future<void> sendMessage() async {
    final message = promprController.text;
    setState(() {
      promprController.clear();
      prompt.add(ModelMessage(
        isPrompt: true,
        message: message,
        time: DateTime.now(),
      ));
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(ModelMessage(
        isPrompt: false,
        message: response.text ?? "",
        time: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 3,
        title: Center(
            child: Text(
          "Bot Buddie",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return UserPrompt(
                        isPrompt: message.isPrompt,
                        message: message.message,
                        date: DateFormat("hh:mm:a").format(
                          message.time,
                        ));
                  })),
          Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: TextField(
                    controller: promprController,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Enter a prompt here"),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.send, color: Colors.white, size: 32),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container UserPrompt(
      {required final bool isPrompt,
      required String message,
      required String date}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 15 : 80),
      decoration: BoxDecoration(
        color: isPrompt ? Colors.blueAccent : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isPrompt ? Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
                fontSize: 18,
                color: isPrompt ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(
                fontSize: 14, color: isPrompt ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
