import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loader_page.dart';

BuildContext? contexts;

showLoader(
  context,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      contexts = context;
      return const LoaderPage();
    },
  );
}

hideLoader(BuildContext context) {
  Navigator.pop(contexts!);
}

showProgressLoader() {
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(),
    ),
    barrierDismissible: false,
  );
}
