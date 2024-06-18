import 'package:flutter/material.dart';

class ScrollableCardWidget extends StatelessWidget {
  final String title;
  final String value;

  const ScrollableCardWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 300.0,
      child: Card(
        elevation: 10,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
