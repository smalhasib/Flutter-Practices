import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(
    String email,
    String username,
    String password,
    File userImageFile,
    bool isLogin,
    BuildContext ctx,
  ) authForm;
  final bool isLoading;

  const AuthForm({Key? key, required this.authForm, required this.isLoading})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  var _isLogin = true;
  String _email = '';
  String _username = '';
  String _password = '';
  File _userImageFile = File('');

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && !_userImageFile.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      widget.authForm(
          _email, _username, _password, _userImageFile, _isLogin, context);
    }
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      imagePickFunction: _pickedImage,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value != null && value.isEmpty ||
                          !value!.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(
                          _isLogin ? _passwordFocusNode : _usernameFocusNode);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _email = newValue.trim();
                      }
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Enter username';
                        }
                        return null;
                      },
                      focusNode: _usernameFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (newValue) {
                        if (newValue != null) {
                          _username = newValue;
                        }
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value != null && value.isEmpty || value!.length < 7) {
                        return 'Must be at least 7 characters long.';
                      }
                      return null;
                    },
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _trySubmit(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _password = newValue;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
