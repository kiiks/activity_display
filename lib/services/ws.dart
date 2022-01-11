import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart';

/// 1. Être sur un réseau wifi
/// 2. Donner l'adresse IP + port (+ potentiel endpoint)
class WebSocketManager {
  static const wsName = "ws://192.168.4.1/ws";
  late WebSocketChannel channel;

  WebSocketManager() {
    // channel is null until ws is connected
    channel = WebSocketChannel.connect(Uri.parse(wsName));
  }

  void reconnect() {
    channel = WebSocketChannel.connect(Uri.parse(wsName));
  }

  void listen({required Function(String data) didRecieve}) async {
    channel.stream.listen((message) {
      print(message);
      didRecieve(message);
    }, onDone: () {
      print("FROM IMPLEM: WS Closed");
      reconnect();
    });
  }
}
