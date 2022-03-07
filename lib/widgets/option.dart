// @dart=2.9
import 'package:flutter/material.dart';
import 'package:wordly/providers/question_provider.dart';
import 'package:provider/provider.dart';

class Option extends StatefulWidget {
  final String text;
  final int index;
  const Option({Key key, this.text, this.index}) : super(key: key);

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isChecked)
          setState(() {
            isChecked = false;
          });
        else {
          Provider.of<QuestionProvider>(context, listen: false)
              .lockAnswer(widget.index);
          setState(() {
            isChecked = true;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 12, right: 5, left: 5),
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.index + 1}. ${widget.text}",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(getIcon()),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcon() {
    if (isChecked) return Icons.done;
  }
}
