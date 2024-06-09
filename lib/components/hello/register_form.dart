import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/components/hello/tabbed_view.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController _phoneController,
      _passwordController,
      _confirmPasswordController;
  bool isRememberMeChecked = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTextField('Phone number', _phoneController),
        space,
        buildTextField('Password', _passwordController, obscureText: true),
        space,
        buildTextField('Confirm password', _passwordController,
            obscureText: true),
        space,
        buildRoundButton(() => _doRegister(context)),
      ],
    );
  }

  void _doRegister(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formFinished()) {
      readGlobalBloc(context).add(CreateUserTriggered(
        phone: _phoneController.text,
        password: _passwordController.text,
      ));
    } else {
      _showSnackBar(context);
    }
  }

  bool _formFinished() {
    return (_phoneController.text != '') && (_passwordController.text != '');
  }

  bool _showSnackBar(BuildContext context) {
    const unfinishedSnackBar = SnackBar(
      content: Text('Form unfinished!'),
    );
    const confirmPasswordSnackBar = SnackBar(
      content: Text('Password does not match!'),
    );

    final isPasswordMatch =
        _passwordController.text == _confirmPasswordController.text;
    ScaffoldMessenger.of(context).showSnackBar(
        (!_formFinished() || isPasswordMatch)
            ? unfinishedSnackBar
            : confirmPasswordSnackBar);
    return true;
  }
}
