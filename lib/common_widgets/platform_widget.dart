import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {
  
  Widget buildCupertineWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertineWidget(context);
    }
      return buildMaterialWidget(context);
    
  }
}

