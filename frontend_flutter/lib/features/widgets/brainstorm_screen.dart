import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/providers/brainstorm_provider.dart';
import 'package:frontend_flutter/features/widgets/idea_car.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/features/models/idea.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';

class BrainstormScreen extends StatelessWidget {
  const BrainstormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrainstormProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brainstorming Live!!!'),
        centerTitle: true,
        leading: IconButton(
          icon: Icons.light_mode == Icons.light_mode
              ? const Icon(Icons.light_mode)
              : const Icon(Icons.dark_mode),
          onPressed: () {
            context.read<BrainstormProvider>().toggleTheme();
          },
        ),
        actions: [
          Icon(
            Icons.circle,
            color: provider.ideas.isEmpty ? Colors.red : Colors.green,
            size: 12,
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => provider.connect(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Reconnect',
          ),
        ],
      ),
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
        return ImplicitlyAnimatedList<Idea>(
          items: provider.ideas,
          areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
          itemBuilder: (context, animation, idea, index) {
            return SizeFadeTransition(
              curve: Curves.easeInOut,
              animation: animation,
              child: Dismissible(
                key: Key(idea.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  context.read<BrainstormProvider>().deleteIdea(idea.id);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted: "${idea.text}"'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          context.read<BrainstormProvider>().undoDelete();
                        },
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                },
                child: IdeaCard(idea: idea),
                confirmDismiss: (direction) async {
                  return await _confirmDelete(context);
                },
              ),
            );
          },
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

  Future<bool?> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (diagContext) => AlertDialog(
        // renamed to diagContext to avoid confusion
        title: const Text("Delete Idea?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(diagContext, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
