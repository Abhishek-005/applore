import '/providers/authentication_provider.dart';
import '/views/Screens/home_screen.dart';
import '/views/widgets/processing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/wide_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String email = "", password = "";

  bool isSignUp = true;

  void signIn() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      email = emailController.text.trim();
      password = passwordController.text.trim();
      showDialog(
          context: context,
          builder: (_) => const ProcessingDialog(message: "Signing In"));
      context
          .read<AuthenticationProvider>()
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
            (Route<dynamic> route) => false);
      });
    }
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        email = emailController.text.trim();
        password = passwordController.text.trim();
        showDialog(
            context: context,
            builder: (_) => const ProcessingDialog(message: "Signing Up"));
        context
            .read<AuthenticationProvider>()
            .signUpWithEmailAndPassword(email: email, password: password)
            .whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (Route<dynamic> route) => false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).devicePixelRatio * 120,
              ),
              const Icon(
                Icons.person,
                size: 100,
              ),
              SizedBox(height: MediaQuery.of(context).devicePixelRatio * 20),

              // Container(
              //   margin: const EdgeInsets.only(top: 20,right:30,bottom: 20),child: RichText(text:const TextSpan( children:[TextSpan(text: "Welcome to Recyclewalah" ,style: TextStyle(color: Colors.black,fontSize: 24)),TextSpan(text: "\n\nPlease register in out application to continue",style: TextStyle(color: Color.fromARGB(70, 0, 0, 0),fontSize: 16),),] ),),),
              SizedBox(height: MediaQuery.of(context).devicePixelRatio * 5),
              Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Email Address is required';
                            }
                            if (!RegExp(
                                    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                                .hasMatch(val)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          enableInteractiveSelection: true,
                          style: GoogleFonts.poppins(
                            //color: Colors.black,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            helperStyle: GoogleFonts.poppins(
                              //color: Colors.black.withOpacity(0.65),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            errorStyle: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            hintStyle: GoogleFonts.poppins(
                              //color: Colors.black54,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 50.0,
                            ),
                            labelText: 'Email address',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          enableInteractiveSelection: false,
                          style: GoogleFonts.poppins(
                            //color: Colors.black,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            helperStyle: GoogleFonts.poppins(
                              //color: Colors.black.withOpacity(0.65),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            errorStyle: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            hintStyle: GoogleFonts.poppins(
                              //color: Colors.black54,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            prefixIcon: const Icon(
                              Icons.key,
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 50.0,
                            ),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        isSignUp
                            ? TextFormField(
                                controller: confirmPasswordController,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                enableInteractiveSelection: false,
                                style: GoogleFonts.poppins(
                                  //color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  helperStyle: GoogleFonts.poppins(
                                    //color: Colors.black.withOpacity(0.65),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  errorStyle: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                    //color: Colors.black54,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.key,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 50.0,
                                  ),
                                  labelText: 'Confirm Password',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  WideButton(
                      width: MediaQuery.of(context).size.width,
                      text: isSignUp ? "Sign Up" : "Login",
                      color: Colors.blueAccent,
                      action: isSignUp ? signUp : signIn),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = !isSignUp;
                          _formKey.currentState?.deactivate();
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                            text: isSignUp
                                ? "Already have an account? "
                                : "Don't have an account? ",
                            style: const TextStyle(color: Colors.blueAccent),
                            children: [
                              TextSpan(
                                  text: isSignUp ? "Login" : "Sign Up",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent))
                            ]),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
