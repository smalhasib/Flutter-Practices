import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String image;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.username,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      username,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(image),
          ),
        ),
      ],
    );
  }
}
