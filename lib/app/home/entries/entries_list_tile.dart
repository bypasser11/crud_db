import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EntriesListTileModel {
  const EntriesListTileModel({
    @required this.leadingText,
    @required this.trailingText,
    this.middleText,
    this.isHeader = false,
    this.isDescriptor = false,
  });
  final String leadingText;
  final String trailingText;
  final String middleText;
  final bool isHeader;
  final bool isDescriptor;
}

class EntriesListTile extends StatelessWidget {
  const EntriesListTile({@required this.model});
  final EntriesListTileModel model;

  @override
  Widget build(BuildContext context) {
    const fontSize = 16.0;
    return Container(
      color: model.isHeader ? Colors.indigo[100] : null,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            model.leadingText,
            style: model.isDescriptor
                ? TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)
                : TextStyle(fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
          Expanded(child: Container()),
          if (model.middleText != null)
            SizedBox(
              width: 130.0,
              child: Text(
                model.middleText,
                style: model.isDescriptor
                    ? TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)
                    : TextStyle(color: Colors.green[400], fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: 130.0,
            child: Text(
              model.trailingText,
              style: model.isDescriptor
                  ? TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)
                  : TextStyle(fontSize: fontSize),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
