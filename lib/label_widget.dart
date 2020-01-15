import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  final String value;

  const LabelWidget({Key key, this.label, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.subhead),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            color: Colors.white10,
          ),
          margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: Theme.of(context).textTheme.body2),
        ),
      ],
    );
  }
}
