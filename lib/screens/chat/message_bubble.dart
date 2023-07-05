import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      this.message, this.isMe, this.userName, this.topic, this.sentAt);

  final message;
  final String userName;
  final isMe;
  final topic;
  final sentAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 5.0,
                    maxWidth: 300.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.red[400]
                          : const Color.fromARGB(255, 128, 72, 72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    margin: const EdgeInsets.only(
                      top: 16,
                      right: 8,
                      left: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        (message.runtimeType == File)
                            ? Image.file(message)
                            : Text(
                                message.runtimeType == String
                                    ? message
                                    : message.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            DateFormat.jm().format(sentAt),
            textAlign: isMe ? TextAlign.left : TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 152, 151, 151),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageBubble extends StatelessWidget {
  ImageBubble(this.message, this.isMe, this.userName, this.topic, this.sentAt);

  final Uint8List message;
  final String userName;
  final isMe;
  final topic;
  final sentAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 5.0,
                    maxWidth: 300.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.red[400]
                          : const Color.fromARGB(255, 128, 72, 72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    margin: const EdgeInsets.only(
                      top: 16,
                      right: 8,
                      left: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [Image.memory(message)],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            DateFormat.jm().format(sentAt),
            textAlign: isMe ? TextAlign.left : TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 152, 151, 151),
            ),
          ),
        ),
      ],
    );
  }
}
