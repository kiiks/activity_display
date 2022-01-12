import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._init();

  factory WebSocketManager() {
    return _instance;
  }
  WebSocketManager._init() {
    initWS();
  }

  //static const wsName = "ws://192.168.4.1/ws";
  static const wsName = "wss://echo.websocket.org";
  late WebSocketChannel channel;
  Function(String data)? listenerCallback;

  int reconnectionAttempt = 0;

  void resgisterListener(Function(String data) callback) {
    listenerCallback = callback;
  }

  void initWS() {
    channel = WebSocketChannel.connect(Uri.parse(wsName));
    listen();
  }

  void listen() {
    channel.stream.listen((message) {
      listenerCallback!(message);
    }, onDone: () {
      print("[WSManager]: WS Closed");
      if (reconnectionAttempt < 2) {
        reconnectionAttempt++;
        print("[WSManager]: " +
            reconnectionAttempt.toString() +
            " Reconnection attempt...");
        initWS();
      }
    }, onError: (err) {
      print("[WSManager] - Error: " + err.toString());
    });
  }
}
