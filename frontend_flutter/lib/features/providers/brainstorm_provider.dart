import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/models/idea.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BrainstormProvider extends ChangeNotifier {
  late WebSocketChannel _channel;
  List<Idea> _ideas = [];
  List<Idea> get ideas => _ideas;

  //connect to websocket
  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'));
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      _handleIncomingMessage(data);
    });
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    debugPrint('Received message: $data');
    final type = data['type'];
    final payload = data['payload'];

    if (type == 'initial_state') {
      //payload is List
      _ideas = (payload as List).map((i) => Idea.fromJson(i)).toList();
      notifyListeners();
    } else if (type == 'idea_added') {
      //payload is Idea
      final newIdea = Idea.fromJson(payload);
      _ideas.add(newIdea);
      notifyListeners();
    } else if (type == 'vote_updated') {
      //payload is Idea
      final updatedIdea = Idea.fromJson(payload);
      final index = _ideas.indexWhere((idea) => idea.id == updatedIdea.id);
      if (index != -1) {
        _ideas[index] = updatedIdea;
      }
      _ideas.sort((a, b) => b.vote.compareTo(a.vote));
      notifyListeners();
    } else if (type == 'idea_deleted') {
      final deleteId = payload.toString();
      _ideas.removeWhere((idea) => idea.id == deleteId);
      notifyListeners();
    }
  }

  void addNewIdea(String text) {
    _channel.sink.add(
      jsonEncode({
        'type': 'new_idea',
        'payload': {'text': text},
      }),
    );
  }

  void deleteIdea(String id) {
    _ideas.removeWhere((idea) => idea.id == id);
    notifyListeners();
    _channel.sink.add(jsonEncode({'type': 'delete_idea', 'payload': id}));
  }

  void vote(String id) {
    _channel.sink.add(jsonEncode({'type': 'vote', 'payload': id}));
  }
}
