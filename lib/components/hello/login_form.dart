import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/components/hello/tabbed_view.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _phoneController, _passwordController;
  bool isRememberMeChecked = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
        Row(
          children: [
            Checkbox(
              value: isRememberMeChecked,
              onChanged: (value) => {
                if (value != null) setState(() => isRememberMeChecked = value)
              },
              visualDensity: VisualDensity.compact,
            ),
            const Text(
              'Remember me',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            Expanded(child: Container()),
          ],
        ),
        space,
        buildRoundButton(() => _doLogin(context)),
      ],
    );
  }

  void _doLogin(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formFinished()) {
      readGlobalBloc(context).add(LoginTriggered(
          phone: _phoneController.text,
          password: _passwordController.text,
          context: context,
          autoLogin: isRememberMeChecked));
    } else {
      _showSnackBar(context);
    }
  }

  bool _formFinished() {
    return (_phoneController.text != '') && (_passwordController.text != '');
  }

  bool _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form unfinished!'),
      ),
    );
    return true;
  }
}
