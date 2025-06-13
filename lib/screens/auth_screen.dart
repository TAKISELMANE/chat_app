import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogIn = true;
  var _entredEmail = '';
  var _entredPass = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (_isLogIn) {
        final userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _entredEmail,
              password: _entredPass,
            );
        if (userCredentials.user != null) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => ChatScreen()));
        }
      } else {
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _entredEmail,
              password: _entredPass,
            );
        if (userCredentials.user != null) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => ChatScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat app')),
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
              width: 150,
              child: Image.asset('assets/images/chat.png'),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Adress',
                              hintText: 'exemple@gmail.com',
                              hintStyle: TextStyle(color: Colors.black38),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Enter a valid Email adress';
                              }
                              return null;
                            },
                            onSaved: (value) => _entredEmail = value!,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 50,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Enter at list 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) => _entredPass = value!,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(_isLogIn ? 'Log in' : 'Sing up'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogIn = !_isLogIn;
                            });
                          },
                          child: Text(
                            _isLogIn
                                ? 'Create an account'
                                : 'I already have an account',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
