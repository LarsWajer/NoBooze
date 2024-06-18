import 'package:flutter/material.dart';

class InputCard extends StatefulWidget {
  final String hintText;
  final Function(int) onPressed;

  const InputCard({
    Key? key,
    required this.hintText,
    required this.onPressed,
  }) : super(key: key);

  @override
  _InputCardState createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  TextEditingController _textController = TextEditingController();

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
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String enteredValue = _textController.text.trim();
                    if (enteredValue.isNotEmpty) {
                      int intValue = int.tryParse(enteredValue) ?? 0; // Convert to integer
                      widget.onPressed(intValue); // Pass the integer value to onPressed function
                      _textController.clear(); // Clear the text field
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a value.'),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
