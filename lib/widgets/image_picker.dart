// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/providers/auth_provider.dart';

class ShopPicCard extends StatefulWidget {
  const ShopPicCard({super.key});

  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  late File _image = File(''); // Initialize _image with an empty file

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          authData.getImage().then(
            (image) {
              setState(
                () {
                  _image = image; // Update _image, ensuring it's not null
                  authData.isPickAvailable = _image != File('');
                  print(_image.path);
                },
              );
            },
          );
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: _image.path.isEmpty // Check if _image is empty
                  ? const Center(
                      child: Text(
                        'Add Shop Image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
