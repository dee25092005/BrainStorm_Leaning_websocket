import 'package:provider/provider.dart';
import 'package:frontend_flutter/features/providers/brainstorm_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/features/models/idea.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  const IdeaCard({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(idea.text),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${idea.vote}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.blue[200] : Colors.blue[800],
              ),
            ),
            IconButton(
              onPressed: () => _handerVote(context),
              icon: const Icon(Icons.thumb_up, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void _handerVote(BuildContext context) {
    HapticFeedback.lightImpact();
    context.read<BrainstormProvider>().vote(idea.id);
  }
}
