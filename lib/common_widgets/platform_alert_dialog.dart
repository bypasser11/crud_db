import 'dart:io';

import 'package:crud_db/common_widgets/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      this.cancelActionText,
      @required this.defaultActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    //if it is ios, use the cupertino, if no use the normal one which is material 
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false, //Dismissing the dialogue by taping outside of it
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertineWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    //If action is not null then add
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
        child: Text(cancelActionText),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      );
    }
    //Default action text
    actions.add(
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      )
      );

      return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  PlatformAlertDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertineWidget(BuildContext context) {
    // TODO: implement buildCupertineWidget
    //CupertinoDialogAction is default for cupertino
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
