import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_open_chat/components/hello/login_form.dart';
import 'package:re_open_chat/components/hello/register_form.dart';
import 'package:unicons/unicons.dart';

class TabbedView extends StatelessWidget {
  const TabbedView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 30, 0),
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Text('Login'),
                    ),
                    Tab(
                      child: Text('Register'),
                    )
                  ],
                ),
              ),
              Expanded(flex: 2, child: Container())
            ],
          ),
        ),
        const Expanded(
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(36.0),
                  child: LoginForm(),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(36.0),
                  child: RegisterForm(),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

const space = SizedBox(height: 30.0);
const textStyle = TextStyle(
  fontSize: 16.0,
  height: 1,
  textBaseline: TextBaseline.ideographic,
);

TextField buildTextField(String hint, TextEditingController controller,
    {List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    bool? obscureText}) {
  return TextField(
    controller: controller,
    style: textStyle,
    decoration: InputDecoration(
      labelText: hint,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.all(14),
    ),
    obscureText: obscureText ?? false,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
  );
}

Widget buildRoundButton(void Function() onPressed) {
  return IconButton.filled(
    disabledColor: Colors.grey,
    onPressed: onPressed,
    iconSize: 32,
    padding: const EdgeInsets.all(16),
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        const CircleBorder(),
      ),
    ),
    icon: const Icon(
      UniconsLine.arrow_right,
    ),
  );
}
