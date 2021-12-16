import 'package:web_socket_channel/web_socket_channel.dart';

/// 1. Être sur un réseau wifi
/// 2. Donner l'adresse IP + port (+ potentiel endpoint)
class WebSocketManager {
  static const wsName = "ws://192.168.4.1/ws";
  late WebSocketChannel channel;

  static final WebSocketManager _instance = WebSocketManager._init();

  WebSocketManager._init() {
    channel = WebSocketChannel.connect(Uri.parse(wsName));
  }

  factory WebSocketManager() {
    return _instance;
  }

  void listen({required Function(String data) didRecieve}) async {
    channel.stream.listen((message) {
      didRecieve(message);
    });
  }
}
