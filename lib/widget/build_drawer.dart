import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../service/auth.dart';

class BuildDrawer extends StatefulWidget {
  String? role;
  dynamic? onTapHome;
  dynamic? onTapItem;
  String? item;
  Color? color;
  IconData? icon;
  BuildDrawer(
      {Key? key,
      this.role,
      this.onTapHome,
      this.item,
      this.onTapItem,
      this.color,
      this.icon})
      : super(key: key);

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  final storage = const FlutterSecureStorage();
  String? name, email;

  readData() async {
    name = await storage.read(key: "name");
    email = await storage.read(key: "email");
    setState(() {});
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("username (${widget.role})"),
          accountEmail: Text("example@gmail.com"),
          currentAccountPicture: const CircleAvatar(
              child: ClipOval(
            child: Image(
              image: AssetImage("assets/avatar.jpg"),
              fit: BoxFit.fill,
            ),
          )),
          decoration: BoxDecoration(
            color: widget.color,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                Icon(widget.icon, size: 15),
                const SizedBox(width: 10),
                Text("${widget.item}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35),
        Divider(
          color: widget.color,
          indent: 10,
        ),
        InkWell(
          onTap: () {
            AuthProvider.logout();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: const [
                Icon(Icons.logout, color: Colors.red, size: 15),
                SizedBox(width: 10),
                Text("Sign Out",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
