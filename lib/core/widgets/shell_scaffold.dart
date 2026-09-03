import 'package:flutter/material.dart';
import 'app_layout.dart';
import 'address_banner.dart';

class ShellScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool showAddressBanner;

  const ShellScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.showAddressBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          if (showAddressBanner && !LandscapeShellScope.of(context))
            const AddressBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}
