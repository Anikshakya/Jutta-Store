// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final name, email, phoneNumber, role, adminRole;
  final VoidCallback? ontap;
  const UserTile(
      {Key? key,
      this.ontap,
      this.name,
      this.email,
      this.phoneNumber,
      this.role,
      this.adminRole})
      : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 216, 216, 216),
        child: Column(
          children: [
            //user tile
            Text('Name: ' + widget.name),
            Text('Email: ' + widget.email),
            Text('Contact: ' + widget.phoneNumber),
            Text('Role: ' + widget.role),
            Text('Admin Role: ' + widget.adminRole),
          ],
        ),
      ),
    );
  }
}
