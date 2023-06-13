import 'package:flutter/material.dart';

class LoginSingupButton extends StatelessWidget {
  const LoginSingupButton(
      {super.key, required this.content, required this.onPressed});
  final String content;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, shape: StadiumBorder()),
            onPressed: onPressed,
            child: Text(content)),
      ),
    );
  }
}

class EmailPasswordTextField extends StatelessWidget {
  const EmailPasswordTextField(
      {super.key,
      required this.content,
      required this.onPressed,
      required this.obscuretext,
      this.validator});

  final String content;
  final Function(String) onPressed;
  final bool obscuretext;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        onChanged: onPressed,
        autovalidateMode: AutovalidateMode.always,
        obscureText: obscuretext,
        validator: validator,
        decoration: InputDecoration(
          hintText: content,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.red),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.red),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }
}
