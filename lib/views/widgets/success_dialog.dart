import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSuccessDialog extends StatelessWidget {
  final String message;

  const CustomSuccessDialog({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
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
          const Icon(Icons.cloud_done),
          const SizedBox(
            height: 35.0,
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
          const SizedBox(
            height: 15.0,
          ),
          SizedBox(
            width: size.width * 0.5,
            child: TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.blueAccent),
              onPressed: () {
                Navigator.pop(context, 'ADDED');
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
