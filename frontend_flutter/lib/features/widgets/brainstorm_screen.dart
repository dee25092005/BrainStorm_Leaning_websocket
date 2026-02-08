import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/providers/brainstorm_provider.dart';
import 'package:frontend_flutter/features/widgets/idea_car.dart';
import 'package:provider/provider.dart';

class BrainstormScreen extends StatelessWidget {
  const BrainstormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brainstorming Live!!!')),
      body: _buildBody(),
      floatingActionButton: _buildFab(context),
    );
  }

  //ui for the body of the screen

  Widget _buildBody() {
    return Consumer<BrainstormProvider>(
      builder: (context, provider, child) {
        if (provider.ideas.isEmpty) {
          return const Center(child: Text('No idea yet'));
        }
        return ListView.builder(
          itemCount: provider.ideas.length,

          itemBuilder: (context, index) =>
              IdeaCard(idea: provider.ideas[index]),
        );
      },
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showaddIdeaDialog(context),
      child: const Icon(Icons.add),
    );
  }

  //logic
  void _showaddIdeaDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text('New Idea'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _handleSubmission(context, controller.text),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _handleSubmission(BuildContext context, String text) {
    if (text.trim().isEmpty) return;

    context.read<BrainstormProvider>().addNewIdea(text);
    Navigator.pop(context);
  }
}
