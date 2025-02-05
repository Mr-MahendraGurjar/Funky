import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/colorUtils.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          color: HexColor(CommonColor.pinkFont),
        ),
      ),
      color: Colors.black.withOpacity(0.8),
    );
  }
}
