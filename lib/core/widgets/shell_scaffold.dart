import 'package:flutter/material.dart';
import 'app_layout.dart';
import 'address_banner.dart';

class ShellScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const ShellScaffold({super.key, this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          if (!LandscapeShellScope.of(context)) const AddressBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}
