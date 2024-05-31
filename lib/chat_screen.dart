import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haj_omrah/pretty_button.dart';
import 'constants.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cronet_http/cronet_http.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Message {
  final String text;
  Message(this.text);
}

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final StreamController<List<Message>> _messageStreamController =
      StreamController<List<Message>>.broadcast();

  List<Message> _latestMessages = [];

  bool myMessage(int index) {
    if (index % 2 == 0)
      return true;
    else
      return false;
  }

  final textMessageController = TextEditingController();
  String _answer = '';
  bool spinner = false;

  void updateSpinner() async {
    setState(() {
      spinner = !spinner;
    });
  }

  void askQuestion(String question) async {
    updateSpinner();
    final client = HttpClient();
    final uri = Uri.http('44.223.69.250', '/answer');
    try {
      final requestBody = json.encode({
        'question': question,
      });

      // Send a POST request
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(requestBody);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        print('Response data: $responseBody');
        // Set the answer to the received response
        setState(() {
          _answer = json.decode(responseBody)['output_text'];

          // Add the AI response as a new message
          _addMessage(_answer);
          updateSpinner();
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: 50,
            width: 100,
          ),
          Text("المساعد الذكي"),
        ],
      )),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageStreamController.stream,
              initialData: [],
              builder: (context, snapshot) {
                List<Message> messages = snapshot.data ?? _latestMessages;
                _latestMessages = messages;
                print(messages);
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(messages[index], myMessage(index));
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    controller: textMessageController,
                    decoration: kMessageTextFieldDecoration,
                    onSubmitted: (value) {
                      _addMessage(value);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  // spinner
                  //     ? CircularProgressIndicator()
                  // :
                  child: spinner
                      ? SpinKitDoubleBounce(
                          color: kGreenColor,
                          size: 50.0,
                        )
                      : SizedBox(
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(100)),
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: 3, vertical: 0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_upward,
                                color: kWhiteColor,
                                size: 20,
                              ),
                              onPressed: () {
                                var msg = textMessageController.text.trim();
                                final snackBar = SnackBar(
                                  content: Text(" الحقل فارغة"),
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                );
                                if (msg.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  _addMessage(textMessageController.text);
                                  print("MSG >>> $msg");
                                  textMessageController.clear();
                                  askQuestion(msg);
                                }
                              },
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addMessage(String text) {
    Message newMessage = Message(text);
    _latestMessages.add(newMessage);
    _messageStreamController.add(_latestMessages);
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  MessageBubble(this.message, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          isMe
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                  child: Text(
                    'انا',
                    style: TextStyle(fontSize: 13),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                  child: Text(
                    'المساعد الذكي',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
          Material(
            borderRadius: BorderRadius.only(
              topRight: isMe ? Radius.circular(0) : Radius.circular(30.0),
              topLeft: isMe ? Radius.circular(30.0) : Radius.circular(0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? kBlueColor : kGreenColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Text(
                message.text,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
