import 'package:blind_clone_flutter/share/drawer_scaffold.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(body: Center(), title: "검색");
  }
}
