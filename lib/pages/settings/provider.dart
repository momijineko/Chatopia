// lib/pages/settings/provider.dart
import 'package:flutter/material.dart';

class ProviderPage extends StatelessWidget {
  const ProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model Provider'),
      ),
      body: Center(
        child: Text('Model Provider Page'),
      ),
    );
  }
}
