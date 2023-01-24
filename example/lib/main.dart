import 'package:flutter/material.dart';
import 'package:widgets/card_with_avatar/card_with_avatar.dart';
import 'package:widgets/extend_circle_avatar/src/ex_circle_avatar.dart';

Color currenColor = Colors.green;

void main() => runApp(

      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CardWithAvatar(
                avatar: ExtendCircleAvatar(
                  child: Text('USD'),
                  backgroundColor: Colors.green,
                  visibleBadge: true,
                  badgeAddon: FittedBox(
                    child: GestureDetector(
                      onTap: () => null,
                      child: const Icon(
                        Icons.color_lens_outlined,
                      ),
                    ),
                  ),
                  badgeRadius: 12,
                ),
                child: Container()),
          ),
        ),
      ),
    );

