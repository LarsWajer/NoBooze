import 'package:flutter/material.dart';

enum InputType { numeric, text }

class InputCard extends StatefulWidget {
  final String hintText;
  final InputType inputType;
  final Function(int)? onIntegerInput;
  final Function(String)? onTextInput;

  InputCard({
    required this.hintText,
    required this.inputType,
    this.onIntegerInput,
    this.onTextInput,
  });

  @override
  _InputCardState createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (widget.inputType == InputType.numeric && widget.onIntegerInput != null) {
      int? value = int.tryParse(_controller.text);
      if (value != null) {
        widget.onIntegerInput!(value);
      }
    } else if (widget.inputType == InputType.text && widget.onTextInput != null) {
      widget.onTextInput!(_controller.text);
    }
    _controller.clear(); // Clear the input field after submission
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                keyboardType: widget.inputType == InputType.numeric
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
