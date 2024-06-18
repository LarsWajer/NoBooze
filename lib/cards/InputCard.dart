import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final String hintText;
  final Function onPressed;
  const InputCard({
    Key? key,
    required this.hintText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 250.0,
        child: Card(
          elevation: 10,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
