import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/models/idea.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  const IdeaCard({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(idea.text),
        subtitle: Text('ID: ${idea.id.substring(idea.id.length - 5)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${idea.vote}', style: const TextStyle(fontSize: 16)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_up)),
          ],
        ),
      ),
    );
  }
}
