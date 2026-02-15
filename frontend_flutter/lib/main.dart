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
    final provider = context.watch<BrainstormProvider>();
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        cardTheme: const CardThemeData(color: Color(0xFF1E1E1E), elevation: 2),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: provider.themeMode,
      home: const BrainstormScreen(),
    );
  }
}
