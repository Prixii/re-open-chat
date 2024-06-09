import 'package:flutter/material.dart';

class AdministratorSetter extends StatelessWidget {
  const AdministratorSetter({super.key, this.bottomPadding = 0});
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    var isAdmin = false;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'As Administrator',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Switch(value: isAdmin, onChanged: (value) => (isAdmin = value)),
          ],
        ),
      ),
    );
  }
}
