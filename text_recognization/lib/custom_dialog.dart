import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) {
      return Center(
        child: Container(
          width: size.width * 0.7,
          height: size.height * 0.12,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                child: Text(
                  'Loading ...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    },
  );
}
