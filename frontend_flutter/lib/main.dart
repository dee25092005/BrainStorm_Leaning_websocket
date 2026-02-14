import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/providers/brainstorm_provider.dart';
import 'package:provider/provider.dart';
import 'features/widgets/brainstorm_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BrainstormProvider()..connect(),
      child: const Brainstorm(),
    ),
  );
}

class Brainstorm extends StatelessWidget {
  const Brainstorm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const BrainstormScreen(),
    );
  }
}
