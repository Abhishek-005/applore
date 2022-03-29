import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessingDialog extends StatelessWidget {
  final String message;

  const ProcessingDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  //color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
