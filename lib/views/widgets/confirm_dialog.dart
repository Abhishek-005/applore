import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmDialog extends StatelessWidget {
  final VoidCallback callback;

  const ConfirmDialog({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Are you sure?',
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            'Do you want to sign out?',
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              //color: Colors.black87,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 50.0,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50.0,
                child: TextButton(
                  onPressed: callback,
                  child: Text(
                    'Yes',
                    style: GoogleFonts.poppins(
                      color: Colors.red.shade700,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
